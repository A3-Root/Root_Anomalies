#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Common post-creation wiring for an anomaly entity: stores its config,
 *              registers it in the live-instance list, and sets up durability (if managed)
 *              + sedation + the capture interaction. Called by root_anomalies_fnc_spawn for
 *              normal drivers, or directly by "deferred" drivers (legacy creatures whose
 *              blocking Main creates the entity itself and calls this once it exists).
 *
 * Arguments:
 * 0: Anomaly entity <OBJECT>
 * 1: Config <HASHMAP>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params [["_obj", objNull, [objNull]], ["_config", createHashMap, [createHashMap]]];

if (isNull _obj) exitWith {};

if !("id" in _config) then {
    private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_INSTANCE_IDX", 0];
    missionNamespace setVariable ["ROOT_ANOMALIES_INSTANCE_IDX", _idx + 1];
    _config set ["id", format ["%1_%2", _config getOrDefault ["type", "anomaly"], _idx]];
};

_obj setVariable [QGVAR(config), _config, true];

if (isNil QGVAR(instances)) then { GVAR(instances) = []; };
GVAR(instances) pushBackUnique _obj;

[_obj] call FUNC(initDamage);

private _id = _config getOrDefault ["id", "?"];
LOG_DEBUG_1("finalizeInstance: %1",_id);
