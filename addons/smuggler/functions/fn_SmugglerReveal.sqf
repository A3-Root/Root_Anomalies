#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Client reveal FX for the Smuggler while detected: distortion bubbles and a
 *              pulsing coloured light (suppressed when seizure-safe), plus an idle voice.
 *
 * Arguments:
 * 0: Anomaly object <OBJECT>
 * 1: Core object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_obj", "_core"];

[_core] spawn {
    params ["_c"];
    while {player distance _c < 1000} do {_c say3D ["smugg_03", 500]; uiSleep 13};
};

private _bubbles = "#particlesource" createVehicleLocal (getPosATL _obj);
_bubbles setParticleCircle [0, [0, 0, 0]];
_bubbles setParticleRandom [0.1, [1, 1, 1], [0, 0, 0], 0, 0.1, [0, 0, 0, 0.1], 1, 0];
_bubbles setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 2, [0, 0, 0], [0, 0, 0], 17, 10, 7.9, 0, [2, 0.5, 2], [[0, 0, 0, 0.5], [0, 0, 0, 1], [0, 0, 0, 0]], [1], 1, 0, "", "", _obj];
_bubbles setDropInterval 0.01;

private _light = "#lightpoint" createVehicle (getPosATL _core);
_light lightAttachObject [_core, [random 1, random 1, 1]];
_light setLightUseFlare false;
_light setLightFlareSize 1;
_light setLightFlareMaxDistance 1500;
_light setLightAttenuation [0, 0, 50, 1000, 1, 50];
_light setLightDayLight true;

private _seizureSafe = SEIZURE_SAFE;
while {(player distance _obj < 1000) && {player getVariable [QGVAR(detected), false]}} do {
    uiSleep (0.5 + random 1);
    if (_seizureSafe) then {
        _light setLightBrightness 0;
    } else {
        private _r = random 1;
        private _g = random 1;
        private _b = random 1;
        _light setLightColor [_r, _g, _b];
        _light setLightAmbient [_g, _r, _b];
        private _peak = round (10 + random 30);
        private _b2 = 0;
        while {_b2 < _peak} do {_light setLightBrightness _b2; _b2 = _b2 + 1; uiSleep 0.1};
        while {_b2 > 0} do {_light setLightBrightness _b2; _b2 = _b2 - 1; uiSleep 0.1};
    };
    uiSleep (0.5 + random 1);
};
detach _light;
deleteVehicle _light;
deleteVehicle _bubbles;
