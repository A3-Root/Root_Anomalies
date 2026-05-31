#include "\z\root_anomalies\addons\screamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local teleport/destruction FX when the Screamer leaves (explosion + mines).
 *
 * Arguments:
 * 0: Screamer object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_objEff"];

_objEff say3D ["teleport_screamer", 500];
addCamShake [1, 5, 25];

private _blur = "#particlesource" createVehicleLocal (getPosATL _objEff);
_blur setParticleCircle [0, [0, 0, 0]];
_blur setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_blur setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 2, [0, 0, 0], [0, 0, 0], 12, 12, 6, 0.002, [7, 5, 1], [[1, 1, 1, 0.5], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _objEff];
_blur setDropInterval 0.01;

private _blurPos = getPosATL _objEff;

uiSleep 1;
playSound "earthquakes";

uiSleep 3;
"Bomb_03_F" createVehicle _blurPos;
uiSleep 0.5;

for "_i" from 1 to 3 do {
    private _surround = [(_blurPos select 0) + random [-5, 0, 5], (_blurPos select 1) + random [-5, 0, 5], (_blurPos select 2) + random [1, 2, 3]];
    private _claymore = "ClaymoreDirectionalMine_Remote_Ammo_Scripted" createVehicle _surround;
    _claymore setDamage 1;
    uiSleep (random [0.4, 0.8, 1.2]);
};

{deleteVehicle _x} forEach (_blurPos nearObjects ["Sign_Sphere25cm_F", 100]);

deleteVehicle _blur;
resetCamShake;
