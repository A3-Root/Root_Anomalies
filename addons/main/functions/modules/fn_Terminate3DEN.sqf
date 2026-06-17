#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN front-end for the Terminate module. On mission start, removes anomalies
 *              within its radius (or the single anomaly it is placed on). Mainly a Zeus tool;
 *              in 3DEN it fires once at init.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 * 1: Synced units <ARRAY>
 * 2: Activated <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_logic", "_units", "_activated"];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};

private _radius = _logic getVariable ["ROOT_TERM_RADIUS", 100];
[getPosATL _logic, _radius] call FUNC(doTerminate);
