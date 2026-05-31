#include "\z\root_anomalies\addons\burper\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local gore particle burst at a position.
 *
 * Arguments:
 * 0: Position object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_splashPoint"];

private _bloodSplash = "#particlesource" createVehicleLocal (getPosATL _splashPoint);
_bloodSplash setParticleCircle [0, [0, 0, 0]];
_bloodSplash setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_bloodSplash setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 13, 1], "", "Billboard", 1, 0.5, [0, 0, 0], [0, 0, 0.5], 2, 10, 7.9, 0.075, [1, 3, 7], [[1, 0, 0.1, 1], [1, 0, 0.1, 1], [1, 1, 0.1, 0]], [0.08], 1, 0, "", "", _splashPoint];
_bloodSplash setDropInterval 60;

uiSleep 0.1;

private _meatPieces = "#particlesource" createVehicleLocal (getPosATL _splashPoint);
_meatPieces setParticleCircle [0, [0, 0, 0]];
_meatPieces setParticleRandom [0, [0.25, 0.25, 0.25], [9, 9, 10], 0, 1.5, [0, 0, 0, 0.1], 0, 0];
_meatPieces setParticleParams [["\A3\data_f\ParticleEffects\Universal\Meat_ca.p3d", 1, 0, 1], "", "SpaceObject", 1, 10, [0, 0, 0], [0, 0, 0.75], 0, 19, 7.9, 0.1, [2, 2, 2], [[1, 0.1, 0.1, 1], [1, 0.25, 0.25, 0.5], [1, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _splashPoint, 0, true, 0.25, [[0, 0, 0, 0]]];
_meatPieces setDropInterval 0.005;

uiSleep 0.2;
deleteVehicle _meatPieces;
uiSleep 1;
deleteVehicle _bloodSplash;
