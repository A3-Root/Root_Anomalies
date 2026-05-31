#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Sets which sides the anomaly may hunt/attack. Empty list = no side
 *              filter (everyone eligible, still subject to global white/blacklist).
 *              Honoured via root_anomalies_fnc_isAffectable.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Sides, e.g. [east] or [west,independent] <ARRAY of SIDE>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp, [east]] call root_anomalies_fnc_setHostileSides;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]], ["_sides", [], [[]]]];

if (isNull _obj) exitWith {};
[_obj, "hostileSides", _sides] call API(setCfg);
