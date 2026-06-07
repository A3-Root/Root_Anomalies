#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Hides the Strigoi (spectral vanish) and disables its simulation.
 *
 * Arguments:
 * 0: Strigoi object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_strigoi"];

_strigoi setVariable [QGVAR(visible), false, true];
[_strigoi getVariable [QGVAR(cap), _strigoi], ["03_tip_casp", 1000]] remoteExec ["say3D"];
_strigoi enableSimulationGlobal false;
_strigoi hideObjectGlobal true;
