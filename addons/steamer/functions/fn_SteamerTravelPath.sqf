#include "\z\root_anomalies\addons\steamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Fires the airborne travel-path marker prop from the Steamer toward its
 *              target, showing the geyser's approach.
 *
 * Arguments:
 * 0: Steamer object <OBJECT>
 * 1: Target <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_steamer", "_tgt"];

private _ragProp = "Land_PenBlack_F" createVehicle [getPosATL _steamer select 0, getPosATL _steamer select 1, 3000];
private _dir = (getPosATL _steamer vectorFromTo getPosATL _tgt) vectorMultiply 20;
_ragProp setVelocity [_dir select 0, _dir select 1, 5];
[_ragProp] remoteExec [QFUNC(SteamerTravel)];
uiSleep 1;
deleteVehicle _ragProp;
