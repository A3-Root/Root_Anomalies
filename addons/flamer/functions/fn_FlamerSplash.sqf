#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local hit-flash particle when the Flamer is struck.
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
_hit setParticleCircle [0, [0, 0, 0]];
_hit setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
_hit setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 0, 32, 0], "", "Billboard", 1, 1, [0, 0, 1], [0, 0, 0], 5, 10, 7.9, 0, [3, 3], [[1, 1, 1, 1], [1, 1, 1, 1]], [3], 0, 0, "", "", _posHit];
_hit setDropInterval 5;

uiSleep 0.2;
deleteVehicle _hit;
