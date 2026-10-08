#include "\z\root_anomalies\addons\wraith\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local presence effects for the Wraith: a low murmur that carries even when
 *              it cannot be seen, and a smoky, ember-shedding aura plus a dim red glow that
 *              only show while the player can actually see it (night vision / thermal, as
 *              decided by WraithViewLocal), so the aura never gives it away to the naked eye.
 *
 * Arguments:
 * 0: Wraith <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_wraith] spawn root_anomalies_wraith_fnc_WraithSfx;
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params [["_obj", objNull, [objNull]]];

if (isNull _obj) exitWith {};

private _seizureSafe = SENS_LIGHTS_OFF;

private _smoke = "#particlesource" createVehicleLocal (getPosATL _obj);
_smoke setParticleCircle [0.3, [0, 0, 0]];
_smoke setParticleRandom [1, [0.3, 0.3, 0.3], [0, 0, 0.2], 0, 0.3, [0, 0, 0, 0.1], 1, 0];
_smoke setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 2, [0, 0, 0.5], [0, 0, 0.3], 8, 9, 7.9, 0.05, [1, 2, 0.1], [[0, 0, 0, 0.6], [0.1, 0, 0, 0.4], [0, 0, 0, 0]], [1], 1, 0, "", "", _obj];
_smoke setDropInterval 100;

private _embers = "#particlesource" createVehicleLocal (getPosATL _obj);
_embers setParticleCircle [0.2, [0, 0, 0]];
_embers setParticleRandom [0.5, [0.3, 0.3, 0.3], [0, 0, 0.5], 0, 0.1, [0, 0, 0, 0], 1, 0];
_embers setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 0.4, [0, 0, 0.5], [0, 0, 0.6], 0, 12, 7.9, 0.02, [0.2, 0.05], [[1, 0.2, 0, 1], [0.4, 0, 0, 0]], [1], 1, 0, "", "", _obj];
_embers setDropInterval 100;

private _light = "#lightpoint" createVehicleLocal (getPosATL _obj);
_light lightAttachObject [_obj, [0, 0, 1]];
_light setLightUseFlare false;
_light setLightDayLight true;
_light setLightColor [0.6, 0.1, 0.05];
_light setLightAmbient [0.3, 0.02, 0.02];
_light setLightAttenuation [0, 0, 40, 800, 1, 30];
_light setLightBrightness 0;

// Hidden objects do not reliably play sounds, so a never-hidden helper carries them.
private _voice = _obj getVariable [QGVAR(voice), objNull];
if (isNull _voice) then {_voice = _obj};

private _shown = false;
private _nextMurmur = 0;
while {!isNull _obj && {alive _obj}} do {
    private _visible = _obj getVariable [QGVAR(seen), false];
    if (_visible isNotEqualTo _shown) then {
        _shown = _visible;
        _smoke setDropInterval ([100, 0.04] select _visible);
        _embers setDropInterval ([100, 0.05] select _visible);
        if (!_visible) then {_light setLightBrightness 0};
    };
    if (_shown) then {
        _light setLightBrightness ([1 + random 4, 1.5] select _seizureSafe);
    };

    if (time >= _nextMurmur) then {
        _nextMurmur = time + 9;
        if (player distance _obj < 600) then {_voice say3D ["murmur", 600]};
    };
    if (player distance _obj < 15) then {addCamShake [1 + random 2, 1.5, 25]};

    uiSleep ([0.08 + random 0.2, 0.5] select _seizureSafe);
};

deleteVehicle _smoke;
deleteVehicle _embers;
deleteVehicle _light;
