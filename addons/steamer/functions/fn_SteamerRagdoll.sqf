#include "\z\root_anomalies\addons\steamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Throws a unit ragdolling away from a steam burst.
 *
 * Arguments:
 * 0: Burst position <ARRAY>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_blowPoz", "_unit"];

private _pressure = 5 + round (random 5);
private _tip = selectRandom ["tip_01", "tip_02", "tip_03", "tip_04", "tip_05"];
private _dir = (_blowPoz vectorFromTo (_unit getRelPos [30, 0])) vectorMultiply _pressure;

private _rag = "Land_PenBlack_F" createVehicle [0, 0, 0];
_rag attachTo [_unit, [0, 0, 0], "Spine3"];
_unit setVelocityModelSpace [_dir select 0, _dir select 1, _pressure];
uiSleep 0.1;
_rag setMass 1e10;
_rag setVelocityModelSpace [_dir select 0, _dir select 1, _pressure];
uiSleep 0.01;
detach _rag;
[_rag, _unit] spawn {
    params ["_rag", "_tgt"];
    uiSleep 0.5;
    deleteVehicle _rag;
    waitUntil {vectorMagnitude velocity _tgt < 0.1};
};
uiSleep 0.2;
[_unit, [_tip, 300]] remoteExec ["say3D"];
