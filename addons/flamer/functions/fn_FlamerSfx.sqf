#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local "burning body" FX for the Flamer while it is visible, plus
 *              proximity burn damage to the local player.
 *
 * Arguments:
 * 0: Flamer object <OBJECT>
 * 1: Damage fraction <NUMBER>
 * 2: Origin position <ARRAY>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_flamer", ["_damage", 0.4, [0]]];

player setSpeaker "NoVoice";
enableCamShake true;

waitUntil {uiSleep 5; player distance _flamer < 1000};
_flamer spawn {
    params ["_f"];
    while {alive _f} do {
        if (_f getVariable [QGVAR(visible), false]) then {[_f, ["flamer_voice", 100]] remoteExec ["say3D"]};
        uiSleep (5 + random 1);
    };
};

private _bones = ["spine3", "leftshoulder", "leftforearmroll", "leftleg", "leftfoot", "leftupleg", "rightshoulder", "rightforearmroll", "rightupleg", "rightleg", "rightfoot", "pelvis", "neck", "leftforearm", "rightforearm"];
private _anchors = [];
{
    private _anchor = "Land_HelipadEmpty_F" createVehicleLocal [0, 0, 0];
    _anchors pushBack _anchor;
    _anchor attachTo [_flamer, [0, 0, 0], _x];
} forEach _bones;
private _flames = [_anchors] call FUNC(FlamerFlames);

private _haze = "#particlesource" createVehicleLocal (getPosATL _flamer);
_haze setParticleCircle [0, [0, 0, 0]];
_haze setParticleRandom [0, [0.3, 0.5, 0.5], [0, 0, 0.1], 0, 0, [0, 0, 0, 0], 0, 0];
_haze setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 0.5, [0, 0, 1], [0, 0, 0.2], 5, 10, 7.9, 0, [3, 2, 5], [[1, 1, 1, 1], [1, 1, 1, 0.5], [1, 1, 1, 0]], [1], 0, 0, "", "", _flamer];
_haze setDropInterval 0.05;

private _light = "#lightpoint" createVehicle getPosATL _flamer;
_light lightAttachObject [_flamer, [0, 0, 3]];
_light setLightAttenuation [0, 0, 0, 0, 0.1, 10];
_light setLightBrightness 1;
_light setLightDayLight true;
_light setLightAmbient [1, 0.2, 0.1];
_light setLightColor [1, 0.2, 0.1];

while {(_flamer getVariable [QGVAR(visible), false]) && {alive _flamer}} do {
    _light setLightBrightness 5 + (random 1);
    _light setLightAttenuation [0, 0, 100, 0, 0.1, 15 + (random 1)];
    uiSleep (0.05 + random 0.1);
    uiSleep 1;
    if (player distance _flamer < 25) then {
        addCamShake [5, 2, 5];
        call BIS_fnc_flamesEffect;
        [10] call BIS_fnc_bloodEffect;
        call BIS_fnc_indicateBleeding;
        private _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.47, 0.69, 0.59, 0.55, 0.61, 0.58];
        if (typeOf player != "VirtualCurator_F") then {
            [player, _damage, _bodyPart, "burn"] call EFUNC(main,applyDamage);
        };
    };
};

deleteVehicle _haze;
deleteVehicle _light;
{deleteVehicle _x} forEach (_anchors + _flames);
