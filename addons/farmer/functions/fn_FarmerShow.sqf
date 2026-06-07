#include "\z\root_anomalies\addons\farmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Surfaces the Farmer at a position (teleport-in) and plays the emerge FX.
 *
 * Arguments:
 * 0: Farmer object <OBJECT>
 * 1: Emerge position <ARRAY>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_farmer", "_originPos"];

_farmer setPos _originPos;
_farmer setVariable [QGVAR(visible), true, true];
[_farmer, ["punch_7", 1000]] remoteExec ["say3D"];
_farmer hideObjectGlobal false;
[_farmer] remoteExec [QFUNC(FarmerTeleport), [0, -2] select isDedicated];
_farmer setAnimSpeedCoef 0.8;
_farmer switchMove "AmovPknlMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon";
_farmer setUnitPos "UP";
uiSleep 1;
[_farmer, ["eko", 1000]] remoteExec ["say3D"];
