#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Spawns an anomaly of the given type at a position/marker, applying an
 *              optional config override on top of the type's registered defaults.
 *              Runs server-side (call from anywhere; it routes to the server). Handles
 *              the common wiring: per-instance config HashMap, unique id, durability,
 *              capture interaction, and the live-instance registry. The type's driver
 *              creates the entity and starts its behaviour.
 *
 *              Supports any number of independent instances of the same type — each
 *              gets its own object, id, config, and capture/killswitch state.
 *
 * Arguments:
 * 0: Type id, e.g. "scp173" <STRING>
 * 1: Position (AGL/ASL array) or marker name <ARRAY|STRING>
 * 2: Config overrides <HASHMAP> (optional)
 *
 * Return Value:
 * Anomaly object (objNull if called on a non-server machine or unknown type) <OBJECT>
 *
 * Example:
 * ["scp173", getPosATL player, createHashMapFromArray [["radius",2000]]] call root_anomalies_fnc_spawn;
 *
 * Public: Yes
 */

params [["_type", "", [""]], ["_posOrMarker", [], [[], ""]], ["_override", createHashMap, [createHashMap]]];

if (!isServer) exitWith {
    [_type, _posOrMarker, _override] remoteExec [QAPI(spawn), 2];
    objNull
};

private _key = toLower _type;
private _driver = GVAR(drivers) getOrDefault [_key, []];
if (_driver isEqualTo []) exitWith { LOG_ERROR("spawn: unknown anomaly type"); objNull };
_driver params ["_handler", "_default"];

// Resolve position (marker name -> position).
private _pos = _posOrMarker;
if (_posOrMarker isEqualType "") then { _pos = getMarkerPos _posOrMarker; };

// Build the per-instance config: clone defaults, layer overrides, stamp identity.
private _config = +_default;
[_config, _override] call FUNC(mergeConfig);

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_INSTANCE_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_INSTANCE_IDX", _idx + 1];
_config set ["id", format ["%1_%2", _key, _idx]];
_config set ["type", _key];

// Driver creates the entity and starts its per-frame behaviour.
private _obj = [_pos, _config] call _handler;
if (isNull _obj) exitWith { LOG_ERROR("spawn: driver returned objNull"); objNull };

_obj setVariable [QGVAR(config), _config, true];

// Durability, damage filtering, killswitch, and capture interaction.
[_obj] call EFUNC(main,initDamage);

GVAR(instances) pushBack _obj;

LOG_DEBUG_2("spawn: %1 created (%2)",_config get "id",_pos);
_obj
