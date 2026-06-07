#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Sets a list of groups the anomaly must never hunt/affect. Excludes take
 *              priority over every positive filter (side, targetUnits, targetGroups):
 *              any unit whose group is excluded is never affectable. Empty list = no
 *              exclusions. Honoured via root_anomalies_fnc_isAffectable.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Groups <ARRAY of GROUP>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp, [group vip]] call root_anomalies_fnc_setExcludeGroups;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]], ["_groups", [], [[]]]];

if (isNull _obj) exitWith {};
[_obj, "excludeGroups", _groups] call API(setCfg);
