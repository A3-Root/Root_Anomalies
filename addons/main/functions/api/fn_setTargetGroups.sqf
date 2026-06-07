#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Sets an explicit list of groups the anomaly may hunt/affect. Any unit whose
 *              group is in this list is affectable even if its side is not in the hostile-
 *              sides filter (explicit include overrides side). Empty list = no group
 *              constraint. Honoured via root_anomalies_fnc_isAffectable. Excludes always win.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Groups <ARRAY of GROUP>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp, [group player]] call root_anomalies_fnc_setTargetGroups;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]], ["_groups", [], [[]]]];

if (isNull _obj) exitWith {};
[_obj, "targetGroups", _groups] call API(setCfg);
