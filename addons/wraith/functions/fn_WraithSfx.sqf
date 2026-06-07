#include "\z\root_anomalies\addons\wraith\script_component.hpp"
/*
 * Author: Root
 * Description: Client FX for the Wraith: dark fire/smoke aura, eerie flickering light
 *              and a dread effect (camera shake + chromatic aberration) for nearby players.
 *
 * Arguments:
 * 0: Wraith object <OBJECT>
 * 1: Fear radius <NUMBER>
 * 2: Seizure-safe <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_obj", ["_fearRadius", 25, [0]], ["_seizureSafe", false, [false]]];

_seizureSafe = _seizureSafe || SEIZURE_SAFE;

// Ambient murmur.
[_obj] spawn {
    params ["_obj"];
    while {alive _obj} do {
        if (player distance _obj < 600) then {_obj say3D ["murmur", 600]};
        uiSleep 9;
    };
};

private _smoke = "#particlesource" createVehicleLocal (getPosATL _obj);
_smoke setParticleCircle [0.3, [0, 0, 0]];
_smoke setParticleRandom [1, [0.3, 0.3, 0.3], [0, 0, 0.2], 0, 0.3, [0, 0, 0, 0.1], 1, 0];
_smoke setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 2, [0, 0, 0.5], [0, 0, 0.3], 8, 9, 7.9, 0.05, [1, 2, 0.1], [[0, 0, 0, 0.6], [0.1, 0, 0, 0.4], [0, 0, 0, 0]], [1], 1, 0, "", "", _obj];
_smoke setDropInterval 0.04;

private _embers = "#particlesource" createVehicleLocal (getPosATL _obj);
_embers setParticleCircle [0.2, [0, 0, 0]];
_embers setParticleRandom [0.5, [0.3, 0.3, 0.3], [0, 0, 0.5], 0, 0.1, [0, 0, 0, 0], 1, 0];
_embers setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 0.4, [0, 0, 0.5], [0, 0, 0.6], 0, 12, 7.9, 0.02, [0.2, 0.05], [[1, 0.2, 0, 1], [0.4, 0, 0, 0]], [1], 1, 0, "", "", _obj];
_embers setDropInterval 0.05;

private _light = "#lightpoint" createVehicle (getPosATL _obj);
_light lightAttachObject [_obj, [0, 0, 1]];
_light setLightUseFlare false;
_light setLightDayLight true;
_light setLightColor [0.6, 0.1, 0.05];
_light setLightAmbient [0.3, 0.02, 0.02];
_light setLightAttenuation [0, 0, 40, 800, 1, 30];

private _aberration = -1;
while {alive _obj} do {
    if (_seizureSafe) then {
        _light setLightBrightness 2;
        uiSleep 0.5;
    } else {
        _light setLightBrightness (1 + random 6);
        uiSleep (0.08 + random 0.2);
    };

    if (player distance _obj < _fearRadius) then {
        addCamShake [2 + random 3, 2, 30];
        if (!_seizureSafe && {_aberration < 0}) then {
            _aberration = ppEffectCreate ["ChromAberration", 220];
            _aberration ppEffectEnable true;
            _aberration ppEffectAdjust [0.6, 0.5, true];
            _aberration ppEffectCommit 1;
        };
    } else {
        if (_aberration >= 0) then {
            _aberration ppEffectEnable false;
            ppEffectDestroy _aberration;
            _aberration = -1;
        };
    };
};

if (_aberration >= 0) then {_aberration ppEffectEnable false; ppEffectDestroy _aberration};
deleteVehicle _smoke;
deleteVehicle _embers;
deleteVehicle _light;
