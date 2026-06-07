#include "\z\root_anomalies\addons\farmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Hides the Farmer underground (burrow) and plays the teleport-out FX.
 *
 * Arguments:
 * 0: Farmer object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_farmer"];

_farmer setAnimSpeedCoef 0.8;
_farmer switchMove "AmovPknlMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon";
_farmer setVariable [QGVAR(visible), false, true];
[_farmer, ["pietre", 1000]] remoteExec ["say3D"];
[_farmer] remoteExec [QFUNC(FarmerTeleport), [0, -2] select isDedicated];
_farmer hideObjectGlobal true;
