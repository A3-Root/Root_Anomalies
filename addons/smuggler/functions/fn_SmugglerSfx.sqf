#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Client FX for the Smuggler: a pulsing distortion core (revealed by the
 *              detector, or always when none is required) plus a leaf/dust "suction".
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

if (!hasInterface) exitWith {};

params ["_obj", "_core"];

private _detector = _obj getVariable [QGVAR(detector), ""];

// Suction FX loop (runs while loopDust is set).
private _secondary = {
    params ["_obj", "_core"];
    player setVariable [QGVAR(loopDust), true];
    while {player getVariable [QGVAR(loopDust), false]} do {
        _core say3D [selectRandom ["rafala_smug_01", "rafala_smug_02", "rafala_smug_03"], 500];
        private _leaves = "#particlesource" createVehicleLocal (getPosATL _obj);
        _leaves setParticleCircle [5, [0, 0, 0]];
        _leaves setParticleRandom [0.1, [6, 6, 0], [-7, -7, 0.5], 0.25, 0.5, [0, 0, 0, 1], 1, 0.5];
        _leaves setParticleParams [["\A3\data_f\ParticleEffects\Hit_Leaves\Leaves_Green.p3d", 1, 0, 1], "", "SpaceObject", 1, 10, [0, 0, 0], [0, 0, 2], 1, 12, 7.9, 1, [3, 3, 3], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [1], 1, 0.5, "", "", _obj, random 360, true, 0.3];
        _leaves setDropInterval 0.01;
        private _dust = "#particlesource" createVehicleLocal (getPosATL _obj);
        _dust setParticleCircle [6, [-3, -3, 0]];
        _dust setParticleRandom [0.5, [2, 2, 0], [-7, -7, 0], 3, 0.5, [0, 0, 0, 1], 1, 0.5];
        _dust setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 2, [0, 0, 0], [0, 0, 0.1], 0, 10, 7.9, 0, [3, 5, 10], [[0.3, 0.27, 0.15, 0], [0.3, 0.27, 0.15, 0.05], [0.3, 0.27, 0.15, 0]], [0.08], 1, 0, "", "", _obj];
        _dust setDropInterval 0.01;
        uiSleep 1;
        deleteVehicle _leaves;
        deleteVehicle _dust;
        uiSleep (round (7 + random 7));
    };
};

// Reveal FX (pulsing coloured light + bubbles) while the player can see the Smuggler.
private _primary = {
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
};

if (_detector != "") then {
    while {!isNull _obj} do {
        waitUntil {uiSleep 5; player distance _obj < 1000};
        [_obj, _core] spawn _secondary;
        waitUntil {[player, _detector] call BIS_fnc_hasItem};
        player setVariable [QGVAR(detected), true];
        [_obj, _detector] spawn {
            params ["_obj", "_detector"];
            waitUntil {uiSleep 1; !([player, _detector] call BIS_fnc_hasItem)};
            player setVariable [QGVAR(detected), false];
        };
        [_obj, _core] call _primary;
        player setVariable [QGVAR(loopDust), false];
        uiSleep 10;
    };
} else {
    player setVariable [QGVAR(detected), true];
    while {!isNull _obj} do {
        waitUntil {uiSleep 5; player distance _obj < 1000};
        [_obj, _core] spawn _secondary;
        [_obj, _core] call _primary;
        player setVariable [QGVAR(loopDust), false];
        uiSleep 10;
    };
};
