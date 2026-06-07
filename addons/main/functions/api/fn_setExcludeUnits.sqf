#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Sets a list of units the anomaly must never hunt/affect. Excludes take
 *              priority over every positive filter (side, targetUnits, targetGroups):
 *              an excluded unit is never affectable. Empty list = no exclusions.
 *              Honoured via root_anomalies_fnc_isAffectable.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Units <ARRAY of OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp, [vip]] call root_anomalies_fnc_setExcludeUnits;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]], ["_units", [], [[]]]];

if (isNull _obj) exitWith {};
[_obj, "excludeUnits", _units] call API(setCfg);
