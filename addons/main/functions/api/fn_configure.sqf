#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Merges config overrides into a live anomaly instance. Drivers read the
 *              config HashMap each frame, so changes take effect immediately at runtime
 *              (mid-mission re-tuning of radius, speed, health, sides, capture, etc.).
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Config overrides <HASHMAP>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp, createHashMapFromArray [["radius",3000],["state","ENRAGE"]]] call root_anomalies_fnc_configure;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]], ["_override", createHashMap, [createHashMap]]];

if (isNull _obj) exitWith {};

if (!isServer) exitWith {
    [_obj, _override] remoteExec [QAPI(configure), 2];
};

private _config = _obj getVariable [QGVAR(config), createHashMap];
[_config, _override] call FUNC(mergeConfig);
_obj setVariable [QGVAR(config), _config, true];

private _id = _config getOrDefault ["id", "?"];
LOG_DEBUG_1("configure: %1 updated",_id);
