#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Convenience setter for the full per-instance targeting filter in one call:
 *              explicit unit/group include lists plus unit/group exclude lists. Excludes
 *              win; explicit includes override the side filter; empty lists = no constraint.
 *              Use root_anomalies_fnc_setHostileSides for the side filter. Server-routed;
 *              applies at runtime. Honoured via root_anomalies_fnc_isAffectable.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Target units <ARRAY of OBJECT> (default [])
 * 2: Target groups <ARRAY of GROUP> (default [])
 * 3: Exclude units <ARRAY of OBJECT> (default [])
 * 4: Exclude groups <ARRAY of GROUP> (default [])
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp, [player], [], [], [group vip]] call root_anomalies_fnc_setTargets;
 *
 * Public: Yes
 */

params [
    ["_obj", objNull, [objNull]],
    ["_units", [], [[]]],
    ["_groups", [], [[]]],
    ["_exUnits", [], [[]]],
    ["_exGroups", [], [[]]]
];

if (isNull _obj) exitWith {};
[_obj, createHashMapFromArray [
    ["targetUnits", _units],
    ["targetGroups", _groups],
    ["excludeUnits", _exUnits],
    ["excludeGroups", _exGroups]
]] call API(configure);
