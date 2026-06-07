#include "\z\root_anomalies\addons\farmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Burrows the Farmer toward its target underground, showing the travel
 *              trail, and records the surfacing position in QGVAR(newPos).
 *
 * Arguments:
 * 0: Farmer object <OBJECT>
 * 1: Target <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_farmer", "_tgt"];

_farmer setUnitPos "DOWN";
private _ragProp = "Land_PenBlack_F" createVehicle [getPosATL _farmer select 0, getPosATL _farmer select 1, 3000];
private _jumpDir = (getPosATL _farmer vectorFromTo getPosATL _tgt) vectorMultiply 20;
_ragProp setVelocity [_jumpDir select 0, _jumpDir select 1, 5];
[_ragProp] remoteExec [QFUNC(FarmerTravel), [0, -2] select isDedicated];
uiSleep (round (2 + random 2));
_farmer setVariable [QGVAR(newPos), getPos _ragProp];
deleteVehicle _ragProp;
