#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local energy-drain FX flowing from the target toward the Strigoi.
 *
 * Arguments:
 * 0: Strigoi object <OBJECT>
 * 1: Target object <OBJECT>
 * 2: Seizure-safe <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_strigoi", "_tgt"];

private _flow = (getPosATL _tgt vectorFromTo getPosATL _strigoi) vectorMultiply 10;

private _field = "#particlesource" createVehicleLocal (getPosATL _tgt);
_field setParticleCircle [0, [0, 0, 0]];
_field setParticleRandom [0, [0.3, 0.3, 0.3], [0, 0, 0.3], 0, 0, [0, 0, 0, 0], 0, 0];
_field setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 0.3, [0, 0, 0], [_flow select 0, _flow select 1, _flow select 2], 1, 10.5, 7.9, 0.0001, [2, 0.5], [[1, 1, 1, 0.3], [1, 1, 1, 0]], [1], 0, 0, "", "", _tgt];
_field setDropInterval 0.05;

private _cloud = "#particlesource" createVehicleLocal (getPosATL _tgt);
_cloud setParticleCircle [0, [0, 0, 0]];
_cloud setParticleRandom [0.5, [0.3, 0.3, 1], [0, 0, 0.3], 0.5, 0, [0, 0, 0, 0], 0, 0];
_cloud setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 0.5, [0, 0, 0], [_flow select 0, _flow select 1, _flow select 2], 1, 10.5, 7.9, 0.0001, [3, 1, 0.1], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0]], [1], 0, 0, "", "", _tgt];
_cloud setDropInterval 0.03;

uiSleep 0.5;
deleteVehicle _field;
deleteVehicle _cloud;
