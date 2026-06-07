#include "\z\root_anomalies\addons\swarmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local blood-jet particle FX at a single feeding spot (bone anchor).
 *
 * Arguments:
 * 0: Spot/anchor object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_spot"];

private _splash = "#particlesource" createVehicleLocal (getPosATL _spot);
_splash setParticleCircle [0, [0, 0, 0]];
_splash setParticleRandom [0.1, [0.2, 0.2, 0.2], [0, 0, 0.1], 0, 0.2, [0, 0, 0, 0.1], 1, 0];
_splash setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 13, 1], "", "Billboard", 1, 0.15, [0, 0, 0], [0, 0, 0], 2, 10, 7.9, 0, [0.2, 0.8], [[1, 0, 0.1, 1], [1, 1, 0.1, 1]], [1], 1, 0, "", "", _spot];
_splash setDropInterval 0.2;
uiSleep 10;
deleteVehicle _splash;
