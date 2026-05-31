#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Sets an anomaly's maximum health (hit points it can absorb before being
 *              killed/disabled). Runtime-mutable; anomalies are tanky by default.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Max health <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp, 50] call root_anomalies_fnc_setHealth;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]], ["_health", ROOT_ANOMALIES_DEFAULT_HEALTH, [0]]];

if (isNull _obj) exitWith {};
[_obj, "health", _health] call API(setCfg);
