#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Sets the patrol/move waypoints an anomaly's driver consumes when idle
 *              (no target). Each waypoint is a position [x,y,z]. Replaces any existing
 *              waypoint list.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Waypoints <ARRAY of positions>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp, [getMarkerPos "wp1", getMarkerPos "wp2"]] call root_anomalies_fnc_setWaypoints;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]], ["_wps", [], [[]]]];

if (isNull _obj) exitWith {};
[_obj, createHashMapFromArray [["waypoints", _wps], ["waypointIdx", 0]]] call API(configure);
