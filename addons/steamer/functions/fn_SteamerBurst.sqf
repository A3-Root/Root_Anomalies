#include "\z\root_anomalies\addons\steamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local geyser-burst FX at a target position (mud, water column, sounds).
 *
 * Arguments:
 * 0: Target position <ARRAY>
 * 1: Spawn a persistent chimney <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_tgtPoz", ["_craterBool", false, [false]]];

private _blow = "CraterLong_small" createVehicleLocal [_tgtPoz select 0, _tgtPoz select 1, -0.5];
_blow hideObjectGlobal true;
_blow setDir (round (random 360));
_blow setVectorUp surfaceNormal getPosATL _blow;
enableCamShake true;

_blow say3D ["explozie_3", 100];

private _rocks = "#particlesource" createVehicleLocal (getPos _blow);
_rocks setParticleCircle [0.5, [-3, -3, 0]];
_rocks setParticleRandom [0.1, [0.3, 0.3, 0], [5, 5, 50], 0, 0.2, [0, 0, 0, 0.1], 1, 0];
_rocks setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 10, [0, 0, 0], [2, 2, 20], 2, 200, 5, 3, [0.5, 0.5, 0.5], [[0, 0, 0, 1], [0, 0, 0, 1], [0, 0, 0, 1]], [1], 1, 0, "", "", _blow, round (random 360), true, 0.1];
_rocks setDropInterval 0.01;
[_rocks] spawn {params ["_p"]; uiSleep 0.5; deleteVehicle _p};

private _pp = linearConversion [0, 100, player distance _blow, 5, 0, true];
addCamShake [_pp, 2, 30];
uiSleep 0.5;

_blow say3D ["gheizer_1", 400];

private _blast = "#particlesource" createVehicleLocal (getPos _blow);
_blast setParticleCircle [1, [0, 0, 0]];
_blast setParticleRandom [0.1, [0.1, 0.1, 0.1], [0, 0, 0], 2, 0.1, [0, 0, 0, 0.1], 1, 0];
_blast setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 3, [0, 0, 0], [0, 0, 3], 5, 13, 7.9, 0, [4, 10, 15], [[1, 1, 1, 0.1], [1, 1, 1, 0.2], [1, 1, 1, 0]], [0.8], 0, 0, "", "", _blow];
_blast setDropInterval 0.05;
[_blast] spawn {params ["_p"]; uiSleep 0.5; deleteVehicle _p};

private _wave = "#particlesource" createVehicleLocal (getPos _blow);
_wave setParticleCircle [0.5, [-3, -3, 0]];
_wave setParticleRandom [0.1, [0.1, 0.1, 0.1], [-7, -7, 0], 5, 0.1, [0, 0, 0, 0.1], 1, 0];
_wave setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 1, [0, 0, 0], [0, 0, 0.1], 5, 10, 7.9, 0, [3, 3, 3], [[1, 1, 1, 0.1], [1, 1, 1, 0.2], [1, 1, 1, 0]], [0.5], 1, 0, "", "", _blow];
_wave setDropInterval 0.002;
[_wave] spawn {params ["_p"]; uiSleep 0.5; deleteVehicle _p};

_blow hideObjectGlobal false;
if (_craterBool) then {[_blow] spawn root_anomalies_steamer_fnc_SteamerChimney};

private _column = "#particlesource" createVehicleLocal (getPos _blow);
_column setParticleCircle [0, [0, 0, 0]];
_column setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_column setParticleParams [["\A3\data_f\cl_water", 1, 0, 1], "", "Billboard", 1, 4, [0, 0, 0], [0, 0, 15], 5, 55, 7.9, 0.05, [1.2, 7, 10], [[1, 1, 1, 0.5], [1, 1, 1, 0.2], [1, 1, 1, 0]], [0.1], 1, 0, "", "", _blow];
_column setDropInterval 0.01;
[_column] spawn {params ["_p"]; uiSleep 1; deleteVehicle _p};

[_blow] spawn {params ["_o"]; uiSleep 1; _o say3D [selectRandom ["eko_01", "eko_02"], 400]};

uiSleep 3.3;
private _drops = "#particlesource" createVehicleLocal (getPos _blow);
_drops setParticleCircle [3.5, [0, 0, 0]];
_drops setParticleRandom [0.1, [3, 3, 0], [0, 0, 0], 3, 0.1, [0, 0, 0, 0.1], 0, 0];
_drops setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 0.2, [0, 0, 0], [0, 0, 0.15], 11, 12, 7.9, 0.075, [0.3, 2, 1], [[1, 1, 1, 0.3], [1, 1, 1, 0.1], [1, 1, 1, 0]], [1], 1, 0, "", "", _blow, 0, true];
_drops setDropInterval 0.01;
[_drops] spawn {params ["_p"]; uiSleep 1.6; deleteVehicle _p};
_blow say3D [selectRandom ["drops_01", "drops_02", "drops_03"], 400];

if (player distance _blow < 50) then {playSound "debris"};

uiSleep 60;
deleteVehicle _blow;
