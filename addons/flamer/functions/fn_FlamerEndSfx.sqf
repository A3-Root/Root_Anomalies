#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local death explosion FX for the Flamer (flash, shockwave, mushroom).
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

private _src = "Land_HelipadEmpty_F" createVehicleLocal (getPosATL _flamer);
enableCamShake true;

[_src] spawn {
    params ["_o"];
    uiSleep 2;
    _o say3D ["eko_sharp", 500];
    uiSleep 1.5;
    _o say3D ["eko_bomb", 500];
};

private _light = "#lightpoint" createVehicle getPosATL _src;
_light lightAttachObject [_src, [0, 0, 3]];
_light setLightAttenuation [0, 0, 0, 0, 0, 300];
_light setLightIntensity 1000;
_light setLightBrightness 6;
_light setLightDayLight true;
_light setLightFlareSize 150;
_light setLightFlareMaxDistance 2000;
_light setLightAmbient [1, 0.2, 0.1];
_light setLightColor [1, 0.2, 0.1];

private _sparks = "#particlesource" createVehicleLocal getPosATL _src;
_sparks setParticleCircle [2, [40, 40, 50]];
_sparks setParticleRandom [1, [0.5, 0.5, 0.5], [30, 30, 20], 0, 0.1, [0, 0, 0, 0.1], 1, 0];
_sparks setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 3, [0, 0, 1], [0, 0, 0], 0, 300, 10, 15, [0.3, 0.1], [[1, 1, 1, 1], [1, 1, 1, 1]], [1], 1, 0, "", "", _src, 0, false, -1, [[1, 0.1, 0, 1]]];
_sparks setDropInterval 0.01;
[_sparks] spawn {params ["_p"]; uiSleep 0.5; deleteVehicle _p};

private _flash = "#particlesource" createVehicleLocal getPos _src;
_flash setParticleCircle [0, [0, 0, 0]];
_flash setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
_flash setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 0, 32, 0], "", "Billboard", 1, 1, [0, 0, 0], [0, 0, 0], 5, 10, 7.9, 0, [5, 15], [[1, 1, 1, 1], [1, 1, 1, 1]], [2], 0, 0, "", "", _src];
_flash setDropInterval 5;
[_flash] spawn {params ["_p"]; uiSleep 0.3; deleteVehicle _p};

private _vapor = "#particlesource" createVehicleLocal getPosATL _src;
_vapor setParticleCircle [0, [0, 0, 0]];
_vapor setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
_vapor setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 0.5, [0, 0, 0], [0, 0, 3], 0, 10, 7.9, 0, [1, 100], [[1, 1, 1, 0.5], [1, 1, 1, 0]], [1], 0, 0, "", "", _src];
_vapor setDropInterval 500;
[_vapor] spawn {params ["_p"]; uiSleep 0.5; deleteVehicle _p};
uiSleep 0.1;

private _wave = "#particlesource" createVehicleLocal getPosATL _src;
_wave setParticleCircle [3, [20, 20, 0]];
_wave setParticleRandom [0.1, [3, 3, 0], [-10, -10, 0], 0, 0.1, [0, 0, 0, 0.1], 0, 0];
_wave setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d", 8, 0, 40, 1], "", "Billboard", 1, 2, [0, 0, 0], [0, 0, 0], 0, 17, 13, 0, [10, 30], [[0, 0, 0, 0.5], [0, 0, 0, 0]], [1], 0, 0, "", "", _src];
_wave setDropInterval 0.005;
[_wave] spawn {params ["_p"]; uiSleep 0.2; deleteVehicle _p};
uiSleep 0.1;

private _cap = "#particlesource" createVehicleLocal getPos _src;
_cap setParticleCircle [2, [-0.5, -0.5, 0]];
_cap setParticleRandom [0.5, [1, 1, 0.3], [0.3, 0.3, 0], 0, 0.1, [0, 0, 0, 0.1], 1, 0];
_cap setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 3, 112, 0], "", "Billboard", 1, 3, [0, 0, 0], [0, 0, 6], 0, 15, 7.9, 0, [2, 5], [[1, 1, 1, 1], [0, 0, 0, 0]], [0.1], 1, 0, "", "", _src, 45];
_cap setDropInterval 0.001;
[_cap] spawn {params ["_p"]; uiSleep 0.3; deleteVehicle _p};
uiSleep 0.2;

private _stem = "#particlesource" createVehicleLocal getPos _src;
_stem setParticleCircle [0.5, [0, 0, 0]];
_stem setParticleRandom [0.5, [0, 0, 0.3], [0, 0, 0], 0, 0.1, [0, 0, 0, 0.1], 0, 0];
_stem setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 1.5, [0, 0, 0], [0, 0, 3.5], 3, 10, 7.9, 0, [4, 0.5], [[1, 1, 1, 1], [1, 1, 1, 0]], [1], 0, 0, "", "", _src, 90];
_stem setDropInterval 0.05;
[_stem] spawn {params ["_p"]; uiSleep 1; deleteVehicle _p};

private _stemSmoke = "#particlesource" createVehicleLocal getPos _src;
_stemSmoke setParticleCircle [1, [0, 0, 0]];
_stemSmoke setParticleRandom [0.5, [0.3, 0.3, 0.3], [0, 0, 0], 0, 0.1, [0, 0, 0, 0.1], 0, 0];
_stemSmoke setParticleParams [["\a3\Data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 1.5, [0, 0, 0], [0, 0, 3.5], 0, 10, 7.9, 0, [3, 3, 2, 2, 2, 1], [[0, 0, 0, 1], [0, 0, 0, 1], [0, 0, 0, 1], [0, 0, 0, 1], [0, 0, 0, 0.5], [0, 0, 0, 0]], [0.2], 0, 0, "", "", _src, 90];
_stemSmoke setDropInterval 0.02;
[_stemSmoke] spawn {params ["_p"]; uiSleep 1.1; deleteVehicle _p};

if (player distance _src < 100) then {
    [] spawn {
        cutText ["", "WHITE OUT", 1];
        uiSleep 0.1;
        titleCut ["", "WHITE IN", 1];
        "dynamicBlur" ppEffectEnable true;
        "dynamicBlur" ppEffectAdjust [1];
        "dynamicBlur" ppEffectCommit 0;
        "dynamicBlur" ppEffectAdjust [0.0];
        "dynamicBlur" ppEffectCommit 5;
        uiSleep 5;
        "dynamicBlur" ppEffectEnable false;
    };
    addCamShake [5, 3, 10];
};
if (player distance _src < 10) then {playSound "burned"; addCamShake [5, 2, 5]; call BIS_fnc_flamesEffect; [10] call BIS_fnc_bloodEffect; call BIS_fnc_indicateBleeding};
uiSleep 0.1;

private _fog = "#particlesource" createVehicleLocal (getPos _src);
_fog setParticleCircle [50, [0, 0, 0]];
_fog setParticleRandom [1, [50, 50, 0], [0, 0, 0], 1, 0.1, [0, 0, 0, 0.1], 0, 0];
_fog setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 10, [0, 0, 1], [0, 0, 0], 3, 10.1, 7.9, 0.01, [1, 10, 20], [[0.1, 0.09, 0.09, 0], [0.1, 0.09, 0.09, 0.5], [0.1, 0.09, 0.09, 0]], [1], 1, 0, "", "", _src];
_fog setDropInterval 0.01;
[_fog] spawn {params ["_p"]; uiSleep 3; deleteVehicle _p};
uiSleep 2;

private _flame = "#particlesource" createVehicleLocal (getPosATL _src);
_flame setParticleCircle [10, [0, 0, 0]];
_flame setParticleRandom [1, [10, 10, 0], [0, 0, 0], 0, 0.1, [0, 0, 0, 0], 1, 0];
_flame setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 10, 32, 1], "", "Billboard", 1, 5, [0, 0, 0], [0, 0, 0], 0, 10.07, 7.9, 0, [1, 5, 1], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0]], [0.8], 0, 0, "", "", _src, 0, true];
_flame setDropInterval 0.02;
[_flame] spawn {params ["_p"]; uiSleep 1.1; deleteVehicle _p};

private _brightness = 5;
while {_brightness > 0} do {
    _light setLightBrightness _brightness;
    _brightness = _brightness - 0.1;
    uiSleep 0.1;
};
deleteVehicle _light;
uiSleep 5;
deleteVehicle _src;
