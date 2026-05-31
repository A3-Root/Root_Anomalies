#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Appends a single waypoint to an anomaly's patrol list.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Waypoint position <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp, getPosATL player] call root_anomalies_fnc_addWaypoint;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]], ["_wp", [], [[]]]];

if (isNull _obj || {_wp isEqualTo []}) exitWith {};

private _wps = [_obj, "waypoints", []] call API(getCfg);
_wps pushBack _wp;
[_obj, "waypoints", _wps] call API(setCfg);
