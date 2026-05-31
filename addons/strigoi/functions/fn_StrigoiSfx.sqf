#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local spectral FX for the Strigoi while visible (glow particles that
 *              change between day and night, plus tease/idle voices).
 *
 * Arguments:
 * 0: Strigoi object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_strigoi"];

private _effectArrays = [
    [
        [0.1, [0.1, 0.1, 0.5], [0, 0, 0.2], 1, 0.1, [0, 0, 0, 0], 1, 0],
        {[["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 0.6, [0, 0, 0], [0, 0, 0.1], 1, 10.1, 7.9, 0.0001, [0.6, 0.2, 0.01], [[1, 1, 1, 1], [1, 1, 1, 0.5], [1, 1, 1, 0]], [1], 1, 0, "", "", _this]}
    ],
    [
        [0.5, [0, 0, 0.25], [0.175, 0.175, 0.1], 0, 0.25, [0, 0, 0, 0.1], 0, 0],
        {[["\A3\data_f\cl_feathers2", 1, 0, 1], "", "SpaceObject", 1, 0.5, [0, 0, 0], [0, 0, 0.1], 3, 10, 7.9, 0.0075, [15, 15, 15], [[1, 1, 1, 0.5], [1, 1, 1, 0.5], [1, 1, 1, 0]], [1], 1, 0, "", "", _this]}
    ]
];

private _makeSpectral = {
    params ["_parts", "_effectArrays"];
    private _sources = [];
    private _arr = _effectArrays select (parseNumber (sunOrMoon >= 0.5));
    {
        private _src = "#particlesource" createVehicleLocal (getPosATL _x);
        _src setParticleCircle [0, [0, 0, 0]];
        _src setParticleRandom (_arr select 0);
        _src setParticleParams (_x call (_arr select 1));
        _src setDropInterval 0.05;
        _sources pushBackUnique _src;
    } forEach _parts;

    [_sources, _effectArrays, _parts] spawn {
        params ["_sources", "_effectArrays", "_parts"];
        while {(_sources isNotEqualTo []) && {!isNull (_parts select 0)}} do {
            uiSleep 3;
            private _arr = _effectArrays select (parseNumber (sunOrMoon >= 0.5));
            {
                _x setParticleRandom (_arr select 0);
                _x setParticleParams ((_parts select (_sources find _x)) call (_arr select 1));
            } forEach _sources;
        };
    };
    _sources
};

player setSpeaker "NoVoice";

waitUntil {uiSleep 5; player distance _strigoi < 1000};
_strigoi spawn {
    params ["_s"];
    while {alive _s} do {
        if (_s getVariable [QGVAR(visible), false]) then {[_s, ["casp_voice", 100]] remoteExec ["say3D"]};
        uiSleep 20;
    };
};

private _bones = ["spine3", "leftshoulder", "leftforearmroll", "leftleg", "leftfoot", "leftupleg", "rightshoulder", "rightforearmroll", "rightupleg", "rightleg", "rightfoot", "pelvis", "neck", "leftforearm", "rightforearm"];
private _anchors = [];
{
    private _anchor = "Land_HelipadEmpty_F" createVehicle [0, 0, 0];
    _anchors pushBack _anchor;
    _anchor attachTo [_strigoi, [0, 0, 0], _x];
} forEach _bones;

[_anchors, _strigoi] spawn {
    params ["_mouths", "_strigoi"];
    while {alive _strigoi} do {
        (selectRandom _mouths) say3D [selectRandom ["01_tease", "02_tease", "NoSound"], 100];
        uiSleep 20;
    };
};

private _glow = [_anchors, _effectArrays] call _makeSpectral;

private _haze = "#particlesource" createVehicleLocal (getPosATL _strigoi);
_haze setParticleCircle [0, [0, 0, 0]];
_haze setParticleRandom [0, [0.3, 0.5, 0.5], [0, 0, 0.1], 0, 0, [0, 0, 0, 0], 0, 0];
_haze setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 1, [0, 0, 0], [0, 0, 0.2], 5, 10.1, 7.9, 0, [3, 2, 5], [[1, 1, 1, 1], [1, 1, 1, 0.5], [1, 1, 1, 0]], [1], 0, 0, "", "", _strigoi];
_haze setDropInterval 0.05;

waitUntil {uiSleep 2; !(_strigoi getVariable [QGVAR(visible), false]) || {!alive _strigoi}};
deleteVehicle _haze;
{deleteVehicle _x} forEach (_anchors + _glow);

private _vanish = "#particlesource" createVehicleLocal (getPosATL _strigoi);
_vanish setParticleCircle [0, [0, 0, 0]];
_vanish setParticleRandom [0.1, [0.5, 0.5, 2], [0, 0, 0.3], 0.1, 0.1, [0, 0, 0, 0], 0, 0];
_vanish setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "SpaceObject", 1, 1, [0, 0, 2], [0, 0, 0], 3, 10.5, 7.9, 0, [0.5, 0.3, 0.01], [[1, 1, 1, 1], [1, 1, 1, 0.5], [1, 1, 1, 0]], [1], 1, 0, "", "", _strigoi];
_vanish setDropInterval 0.05;

uiSleep 3;
deleteVehicle _vanish;
