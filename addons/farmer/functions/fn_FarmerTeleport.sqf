#include "\z\root_anomalies\addons\farmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local ground-eruption crater FX where the Farmer teleports.
 *
 * Arguments:
 * 0: Crater position reference <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_crater"];

enableCamShake true;

private _ground = "#particlesource" createVehicleLocal (getPos _crater);
_ground setParticleCircle [2, [0, 0, 0]];
_ground setParticleRandom [0, [0.2, 0.2, 0], [0, 0, 0], 0, 0.5, [0, 0, 0, 0], 0, 0];
_ground setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 20, [0, 0, 0], [0, 0, 0.1], 0, 20, 7.9, 0, [1.5, 0.1], [[0, 0, 0, 1], [0, 0, 0, 0]], [1], 0, 0, "", "", _crater, 0, true, 0.1, [[0, 0, 0, 0]]];
_ground setDropInterval 0.05;
[_ground] spawn {params ["_p"]; uiSleep 0.5; deleteVehicle _p};

private _earth = "#particlesource" createVehicleLocal (getPos _crater);
_earth setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 0], "", "BillBoard", 1, 3, [0, 0, 1], [0, 0, 10], 0, 50, 0.01, 0, [5, 20], [[0.1, 0.1, 0.1, 1], [0.1, 0.1, 0.1, 0]], [1000], 1, 0, "", "", _crater];
_earth setParticleRandom [0.5, [1, 1, 0.5], [1, 1, 2], 20, 0.1, [0, 0, 0, 0.5], 1, 0, 1, 0];
_earth setParticleCircle [0, [0, 0, 0]];
_earth setDropInterval 0.2;
[_earth] spawn {params ["_p"]; uiSleep 0.5; deleteVehicle _p};

private _blastWave = "#particlesource" createVehicleLocal (getPos _crater);
_blastWave setParticleCircle [0, [-0.2, -0.2, 0]];
_blastWave setParticleRandom [0.1, [0.3, 0.3, 0.5], [0.2, 0.2, 0.5], 0, 0.1, [0, 0, 0, 0.1], 1, 0];
_blastWave setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 5, [0, 0, 0.3], [0, 0, 2], 5, 10, 7, 1, [5, 10], [[0.05, 0.04, 0.03, 1], [0.05, 0.04, 0.03, 0]], [1], 1, 0, "", "", _crater];
_blastWave setDropInterval 0.1;
[_blastWave] spawn {params ["_p"]; uiSleep 0.5; deleteVehicle _p};

private _rocks = "#particlesource" createVehicleLocal (getPos _crater);
_rocks setParticleCircle [1, [-5, -5, 0]];
_rocks setParticleRandom [0.1, [1, 1, 0], [5, 5, 5], 0, 0.2, [0, 0, 0, 1], 1, 0];
_rocks setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 10, [0, 0, 0], [0, 0, 10], 2, 200, 5, 3, [0.5, 0.5, 0.5], [[0, 0, 0, 1], [0, 0, 0, 1], [0, 0, 0, 0]], [1], 1, 0, "", "", _crater, round (random 360), true, 0.1];
_rocks setDropInterval 0.05;
[_rocks] spawn {params ["_p"]; uiSleep 0.5; deleteVehicle _p};

private _pp = linearConversion [0, 100, player distance _crater, 5, 0, true];
addCamShake [_pp, 2, 30];
