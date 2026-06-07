#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Hides the Flamer (vanish) and disables its simulation.
 *
 * Arguments:
 * 0: Flamer object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_flamer"];

_flamer setVariable [QGVAR(visible), false, true];
[_flamer getVariable [QGVAR(cap), _flamer], ["foc_initial", 1000]] remoteExec ["say3D"];
_flamer enableSimulationGlobal false;
_flamer hideObjectGlobal true;
