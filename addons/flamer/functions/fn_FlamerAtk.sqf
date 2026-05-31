#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local ground-fire FX where the Flamer attacks.
 *
 * Arguments:
 * 0: Flamer object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_flamer"];

private _burnGround = "Land_HelipadEmpty_F" createVehicleLocal [getPosATL _flamer select 0, getPosATL _flamer select 1, 0];
_burnGround say3D ["furnal", 300];
enableCamShake true;

private _dust = "#particlesource" createVehicleLocal (getPosATL _flamer);
_dust setParticleCircle [3, [-3, -3, 0]];
_dust setParticleRandom [0.5, [2, 2, 0], [-7, -7, 0], 5, 1, [0, 0, 0, 1], 1, 0.5];
_dust setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d", 8, 0, 40, 1], "", "Billboard", 1, 2, [0, 0, 0], [0, 0, 0.1], 0, 10, 7.9, 0, [1, 10], [[0.3, 0.27, 0.15, 0.3], [0.3, 0.27, 0.15, 0]], [0.5], 1, 0.5, "", "", _flamer, 0, true];
_dust setDropInterval 0.01;

private _flame = "#particlesource" createVehicleLocal (getPosATL _flamer);
_flame setParticleCircle [3, [0, 0, 0]];
_flame setParticleRandom [1, [2, 2, 0], [0, 0, 0], 0, 0.1, [0, 0, 0, 0], 1, 0];
_flame setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 10, 32, 1], "", "Billboard", 1, 9, [0, 0, 0], [0, 0, 0], 0, 10.07, 7.9, 0, [2, 2, 2], [[1, 1, 1, 0], [1, 1, 1, 1], [1, 1, 1, 0]], [0.8], 0, 0, "", "", _flamer, 0, true];
_flame setDropInterval 0.02;

private _light = "#lightpoint" createVehicle [getPosATL _flamer select 0, getPosATL _flamer select 1, 3];
_light setLightUseFlare false;
_light setLightAttenuation [0, 0, 100, 0, 0.1, round (10 + random 5)];
_light setLightBrightness 10;
_light setLightDayLight true;
_light setLightAmbient [1, 0.2, 0.1];
_light setLightColor [1, 0.2, 0.1];
uiSleep 0.5;
deleteVehicle _dust;
deleteVehicle _flame;

private _brightness = 8;
while {_brightness > 0} do {
    if (player distance _light < 6) then {addCamShake [5, 2, 5]; call BIS_fnc_flamesEffect; [10] call BIS_fnc_bloodEffect; call BIS_fnc_indicateBleeding};
    _light setLightBrightness _brightness;
    _light setLightAttenuation [0, 0, 100, 0, 0.1, 15 + (random 1)];
    uiSleep 2.3;
    _brightness = _brightness - 2;
};
deleteVehicle _light;
uiSleep 5;
deleteVehicle _burnGround;
