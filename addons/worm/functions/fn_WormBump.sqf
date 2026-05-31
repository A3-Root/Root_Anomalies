#include "\z\root_anomalies\addons\worm\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Small local dust puff as the Worm surfaces.
 *
 * Arguments:
 * 0: Worm head object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_head"];

private _dust = "#particlesource" createVehicleLocal (getPosATL _head);
_dust setParticleCircle [3, [-3, -3, 0]];
_dust setParticleRandom [2, [2, 2, 0], [-15, -15, 0], 5, 1, [0, 0, 0, 1], 1, 0];
_dust setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 3, [0, 0, 0], [0, 0, 0.1], 7, 10, 7.9, 0.005, [5, 7, 13], [[0.3, 0.27, 0.15, 1], [0.3, 0.27, 0.15, 0.5], [0.3, 0.27, 0.15, 0]], [0.08], 1, 0, "", "", _head];
_dust setDropInterval 0.002;
uiSleep 0.2;
deleteVehicle _dust;
