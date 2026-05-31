#include "\z\root_anomalies\addons\screamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local sonic-scream FX (refraction wave, vapour, ground dust + sounds).
 *
 * Arguments:
 * 0: Effect origin object <OBJECT>
 * 1: Emitter object (the Screamer) <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_objEff", "_emit"];

_emit say3D ["scream", 500];
_objEff say3D ["stones_scream", 500];

enableCamShake true;
if ((player distance _emit) < 150) then {addCamShake [1, 5, 25]};

private _blur = "#particlesource" createVehicleLocal (getPosATL _objEff);
_blur setParticleCircle [0, [0, 0, 0]];
_blur setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_blur setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 0.5, [0, 0, 0], [0, 0, 0], 12, 12, 6, 0.00001, [0.2, 3, 15], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0.2]], [0.08], 1, 0, "", "", _objEff];
_blur setDropInterval 0.01;

private _vapour = "#particlesource" createVehicleLocal (getPosATL _objEff);
_vapour setParticleCircle [0, [0, 0, 0]];
_vapour setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_vapour setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 2, [0, 0, 0], [0, 0, 0], 12, 12, 6, 0.002, [1, 2, 3], [[1, 1, 1, 0.005], [1, 1, 1, 0.05], [1, 1, 1, 0]], [0.08], 1, 0, "", "", _objEff];
_vapour setDropInterval 0.01;

private _ground = "#particlesource" createVehicleLocal (getPosATL _objEff);
_ground setParticleCircle [0.3, [0, 0, 0]];
_ground setParticleRandom [0, [0.25, 0.25, 0], [0, 0, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_ground setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 10, [0, 0, 0], [0, 0, 0.1], 0, 20, 7.9, 0.075, [1, 1, 1], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _objEff, 0, true, 0.1, [[0, 0, 0, 0]]];
_ground setDropInterval 0.001;

uiSleep 0.1;

private _dust = "#particlesource" createVehicleLocal (getPosATL _objEff);
_dust setParticleCircle [1, [0, 0, 0]];
_dust setParticleRandom [0, [0.25, 0.25, 0], [4, 4, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_dust setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 5, [0, 0, 0], [0, 0, 5], 3, 20, 7.9, 0.075, [0.2, 0.2, 0.2], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _objEff, 0, true, 0.3, [[0, 0, 0, 0]]];
_dust setDropInterval 0.005;

uiSleep 1;
if ((player distance _emit) < 100) then {playSound "earthquakes"};

uiSleep 2;
deleteVehicle _blur;
resetCamShake;
uiSleep 2;
deleteVehicle _dust;
deleteVehicle _ground;
deleteVehicle _vapour;
