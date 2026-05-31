#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Captures an anomaly: neutralises it and raises the global "root_anomalies_captured"
 *              CBA event. A captured anomaly idles until uncaptured. Server-routed.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp] call root_anomalies_fnc_capture;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]]];

if (isNull _obj) exitWith {};
[_obj, true] call EFUNC(main,doCapture);
