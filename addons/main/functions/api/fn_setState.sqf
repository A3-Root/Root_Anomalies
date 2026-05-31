#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Sets the generic behaviour state of an anomaly. Drivers interpret these:
 *              "NORMAL"  - default behaviour
 *              "DOCILE"  - passive / will not attack
 *              "ENRAGE"  - aggressive / max speed
 *              "SLOW"    - movement slowed
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: State <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp, "ENRAGE"] call root_anomalies_fnc_setState;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]], ["_state", "NORMAL", [""]]];

if (isNull _obj) exitWith {};
[_obj, "state", toUpper _state] call API(setCfg);
