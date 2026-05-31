#include "\z\root_anomalies\addons\worm\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local idle FX for the Worm: head smoke, idle voice and (at night, unless
 *              seizure-safe) a flickering coloured light.
 *
 * Arguments:
 * 0: Worm head object <OBJECT>
 * 1: Worm tail object <OBJECT>
 * 2: Idle-voice object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_head", "_tail", "_voice"];

[_voice, true] remoteExec ["hideObject", 0, true];
[_voice] spawn {
    params ["_v"];
    while {!isNull _v} do {
        _v say3D ["idle_02", 500];
        uiSleep 7.5;
    };
};

while {!isNull _head} do {
    private _smoke = "#particlesource" createVehicleLocal (getPosATL _head);
    _smoke setParticleCircle [0, [0, 0, 0]];
    _smoke setParticleRandom [3, [0.25, 0.25, 0.25], [0.1, 0.1, 0.1], 5, 0.25, [0.1, 0.1, 0.05, 0.1], 1, 0];
    _smoke setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 11, [0, 0, 0], [0, 0, 1], 7, 11, 7.9, 0.0001, [4, 3, 0.5], [[0, 0, 0, 1], [0, 0, 0, 1], [0, 0, 0, 1]], [0.08], 1, 0, "", "", _head, 0, true, 0.1, [[0, 0, 0, 0]]];
    _smoke setDropInterval 0.01;

    if ((sunOrMoon < 1) && {!SEIZURE_SAFE}) then {
        private _light = "#lightpoint" createVehicle (getPosATL _head);
        _light lightAttachObject [_head, [0.1, 0.1, 5]];
        _light setLightUseFlare false;
        _light setLightDayLight true;
        _light setLightFlareSize 1;
        _light setLightFlareMaxDistance 1500;
        _light setLightAttenuation [0, 0, 50, 1000, 1, 50];

        while {player distance _head < 1000} do {
            private _r = random 1;
            private _g = random 1;
            private _b = random 1;
            _light setLightColor [_r, _g, _b];
            _light setLightAmbient [_g, _r, _b];
            private _flicks = 1 + floor (random 9);
            for "_f" from 1 to _flicks do {
                _light setLightBrightness (10 + random 30);
                uiSleep (0.1 + random 0.2);
            };
            _light setLightBrightness 0;
            uiSleep (3 + random 10);
        };
        deleteVehicle _light;
    } else {
        while {player distance _head < 1000} do {uiSleep 15};
    };

    deleteVehicle _smoke;
    waitUntil {player distance _head < 1000};
};
