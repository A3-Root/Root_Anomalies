#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Reads a single config key from an anomaly instance.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Key <STRING>
 * 2: Default if unset <ANY> (optional)
 *
 * Return Value:
 * Value <ANY>
 *
 * Example:
 * [_scp, "radius", 150] call root_anomalies_fnc_getCfg;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]], ["_key", "", [""]], ["_default", objNull]];

if (isNull _obj) exitWith { _default };
(_obj getVariable [QGVAR(config), createHashMap]) getOrDefault [_key, _default]
