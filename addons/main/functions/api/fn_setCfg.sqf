#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Sets a single config key on an anomaly instance (thin wrapper over
 *              root_anomalies_fnc_configure). Server-routed; applies at runtime.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Key <STRING>
 * 2: Value <ANY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp, "speed", 14] call root_anomalies_fnc_setCfg;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]], ["_key", "", [""]], ["_value", 0]];

if (isNull _obj || {_key isEqualTo ""}) exitWith {};
[_obj, createHashMapFromArray [[_key, _value]]] call API(configure);
