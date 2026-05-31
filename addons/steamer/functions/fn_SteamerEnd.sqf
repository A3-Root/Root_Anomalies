#include "\z\root_anomalies\addons\steamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local death explosion FX for the Steamer.
 *
 * Arguments:
 * 0: Steamer position <ARRAY>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_steamerPoz"];

enableCamShake true;

private _src = "Land_HelipadEmpty_F" createVehicleLocal [_steamerPoz select 0, _steamerPoz select 1, 10];
_src say3D ["explozie_3", 100];
[_src] spawn {params ["_o"]; uiSleep 3; deleteVehicle _o};

private _dust = "#particlesource" createVehicleLocal _steamerPoz;
_dust setParticleCircle [3, [-5, -5, 0]];
_dust setParticleRandom [0.1, [2, 2, 0], [-10, -10, 0], 5, 0.1, [0, 0, 0, 0.1], 1, 0.5];
_dust setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d", 8, 0, 40, 1], "", "Billboard", 1, 5, [0, 0, 0], [0, 0, 0.1], 0, 10, 7.9, 0, [10, 30], [[0.3, 0.27, 0.15, 0.3], [0.3, 0.27, 0.15, 0]], [0.5], 1, 0.5, "", "", _steamerPoz];
_dust setDropInterval 0.001;
[_dust] spawn {params ["_p"]; uiSleep 0.1; deleteVehicle _p};

private _cap = "#particlesource" createVehicleLocal _steamerPoz;
_cap setParticleCircle [10, [0, 0, 0]];
_cap setParticleRandom [0.1, [0, 0, 0], [0, 0, 0], 1, 0.1, [0, 0, 0, 0], 0, 0];
_cap setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 7, [0, 0, 0], [0, 0, 5], 13, 8, 7, 0.05, [5, 10, 15], [[1, 1, 1, 0.5], [1, 1, 1, 0.3], [1, 1, 1, 0]], [1], 1, 0, "", "", _steamerPoz];
_cap setDropInterval 0.001;
[_cap] spawn {params ["_p"]; uiSleep 0.1; deleteVehicle _p};

private _steam = "#particlesource" createVehicleLocal _steamerPoz;
_steam setParticleCircle [15, [0, 0, 0]];
_steam setParticleRandom [1, [10, 10, 0], [0, 0, 0], 1, 0.5, [0, 0, 0, 1], 0, 0];
_steam setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 12, [0, 0, 0], [0, 0, 0], 3, 9, 7, 0.1, [10, 15, 20], [[1, 1, 1, 0], [1, 1, 1, 0.1], [1, 1, 1, 0]], [1], 1, 0, "", "", _steamerPoz];
_steam setDropInterval 0.01;
[_steam] spawn {params ["_p"]; uiSleep 0.5; deleteVehicle _p};

if (player distance _steamerPoz < 200) then {addCamShake [5, 2, 5]};
uiSleep 1.5;

private _cap2 = "#particlesource" createVehicleLocal _steamerPoz;
_cap2 setParticleCircle [10, [0, 0, 0]];
_cap2 setParticleRandom [0.1, [0, 0, 0], [0, 0, 0], 1, 0.1, [0, 0, 0, 0], 0, 0];
_cap2 setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 5, [0, 0, 0], [0, 0, 5], 13, 8, 7, 0.05, [10, 15, 20], [[1, 1, 1, 0], [1, 1, 1, 0.1], [1, 1, 1, 0]], [1], 1, 0, "", "", _steamerPoz];
_cap2 setDropInterval 0.001;
[_cap2] spawn {params ["_p"]; uiSleep 0.1; deleteVehicle _p};
