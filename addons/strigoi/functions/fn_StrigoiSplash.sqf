#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local spark hit-flash when the Strigoi is struck.
 *
 * Arguments:
 * 0: Position reference <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_posHit"];

private _hit = "#particlesource" createVehicleLocal (getPos _posHit);
_hit setParticleCircle [0, [5, 5, 5]];
_hit setParticleRandom [0.5, [0, 0, 2], [-5, -5, -5], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_hit setParticleParams [["\A3\data_f\blesk1", 1, 0, 1], "", "SpaceObject", 1, 0.3, [0, 0, 0], [0, 0, 0], 5, 10, 7.9, 0, [0.005, 0.0006], [[1, 1, 1, 1], [1, 1, 1, 0.5], [1, 1, 1, 0]], [0.08], 1, 0, "", "", _posHit];
_hit setDropInterval 0.01;

uiSleep 0.2;
deleteVehicle _hit;
