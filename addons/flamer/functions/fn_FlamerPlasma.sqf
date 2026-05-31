#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local plasma projectile trail fired by the Flamer.
 *
 * Arguments:
 * 0: Source object <OBJECT>
 * 1: Shoot direction vector <ARRAY>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_ball", "_shootDir"];

private _ballSfx = "#particlesource" createVehicleLocal (getPos _ball);
_ballSfx setParticleCircle [0, [0, 0, 0]];
_ballSfx setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
_ballSfx setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 0, 32, 1], "", "Billboard", 1, 0.5, [0, 0, 1], [_shootDir select 0, _shootDir select 1, _shootDir select 2], 0, 10, 7.9, 0, [3, 2, 2], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0]], [3], 0, 0, "", "", _ball];
_ballSfx setDropInterval 0.05;
uiSleep 0.5;
deleteVehicle _ballSfx;
