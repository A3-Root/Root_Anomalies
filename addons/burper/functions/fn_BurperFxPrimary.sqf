#include "\z\root_anomalies\addons\burper\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local "revealed" FX for the Burper: refract column, coloured pulsing
 *              light and a looping vortex sound. Runs until the cycle ends or the
 *              player moves out of range.
 *
 * Arguments:
 * 0: Anomaly object (range/cycle reference) <OBJECT>
 * 1: Visual sphere object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_workObj", "_sphere"];

[_sphere] spawn {
    params ["_sphere"];
    while {!isNull _sphere} do {
        _sphere say3D ["vortex", 50];
        uiSleep 8;
    };
};

private _refract = "#particlesource" createVehicleLocal (getPosATL _sphere);
_refract setParticleCircle [0, [0, 0, 0]];
_refract setParticleRandom [0, [0.25, 0.25, 0], [5, 5, 5], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_refract setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 0.3, [0, 0, 2], [0, 0, 0], 17, 10, 7.9, 0.007, [4, 0.5], [[0, 0, 0, 1], [0, 0, 0, 1]], [0.08], 1, 0, "", "", _sphere];
_refract setDropInterval 0.01;

private _light = "#lightpoint" createVehicle (getPosATL _sphere);
_light lightAttachObject [_sphere, [0.1, 0.1, 3]];
_light setLightUseFlare false;
_light setLightFlareSize 1;
_light setLightFlareMaxDistance 1500;
_light setLightAttenuation [0, 0, 50, 1000, 1, 50];

private _seizureSafe = SEIZURE_SAFE;

while {((player distance _workObj) < 1500) && {(_workObj getVariable [QGVAR(cycSimple), 1]) != (_workObj getVariable [QGVAR(cycCompli), 1])}} do {
    private _r = random 1;
    private _g = random 1;
    private _b = random 1;
    private _brightness = 10 + random 30;
    if (_seizureSafe) then {
        _light setLightBrightness 0;
        uiSleep 1;
    } else {
        _light setLightColor [_r, _g, _b];
        _light setLightAmbient [_g, _r, _b];
        _light setLightDayLight true;
        uiSleep 0.5;
        _light setLightBrightness _brightness;
        uiSleep 0.5;
        while {_brightness > 8} do {
            _light setLightBrightness _brightness;
            _brightness = _brightness - 0.5;
            uiSleep 0.1;
        };
    };
    uiSleep (1 + random 5);
};

deleteVehicle _refract;
deleteVehicle _light;
