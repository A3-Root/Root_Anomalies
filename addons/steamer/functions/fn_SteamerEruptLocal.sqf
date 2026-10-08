#include "\z\root_anomalies\addons\steamer\script_component.hpp"
/*
 * Author: Root
 * Description: Local death eruption for the Steamer: the ground tears open under it, dust
 *              is sucked into a spiral, a shockwave races outwards and soil, splinters and
 *              rock are thrown clear on bouncing arcs. Self-contained (no Root's Effects
 *              dependency); no light or alarm.
 *
 * Arguments:
 * 0: Eruption position ATL <ARRAY>
 * 1: Eruption radius in meters <NUMBER> (default 30)
 *
 * Return Value:
 * None
 *
 * Example:
 * [getPosATL _steamer, 30] call root_anomalies_steamer_fnc_SteamerEruptLocal;
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params [["_pos", [0, 0, 0], [[]], 3], ["_radius", 30, [0]]];

private _src = "Land_HelipadEmpty_F" createVehicleLocal _pos;
_src setPosATL _pos;

// Dust swept inwards on a tightening spiral.
private _vortex = "#particlesource" createVehicleLocal _pos;
_vortex setParticleCircle [_radius, [-25, -25, 0]];
_vortex setParticleRandom [2, [_radius / 4, _radius / 4, 3], [5, 5, 2], 0, 0.4, [0, 0, 0, 0.1], 0, 0];
_vortex setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 9, 0], "", "Billboard", 1, 4, [0, 0, 1], [0, 0, 4], 0, 10, 7.5, 0.03, [4, 12, 2], [[0.3, 0.28, 0.26, 0.5], [0.35, 0.3, 0.3, 0.3], [0.4, 0.35, 0.35, 0]], [0.3, 0.8], 1, 0, "", "", _src];
_vortex setDropInterval 0.006;

// Ground ripple racing outwards.
private _shock = "#particlesource" createVehicleLocal _pos;
_shock setParticleCircle [4, [60, 60, 0]];
_shock setParticleRandom [1, [3, 3, 0], [-20, -20, 0], 0, 0.5, [0, 0, 0, 0], 0, 0];
_shock setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 1.5, [0, 0, 1], [0, 0, 0], 0, 9, 7, 0, [6, 20], [[1, 1, 1, 0], [1, 1, 1, 1], [1, 1, 1, 0]], [1], 0, 0, "", "", _src];
_shock setDropInterval 0.002;

// Steam column punching up out of the vent.
private _steam = "#particlesource" createVehicleLocal _pos;
_steam setParticleCircle [3, [0, 0, 0]];
_steam setParticleRandom [1, [2, 2, 0], [3, 3, 6], 0, 0.3, [0, 0, 0, 0.1], 0, 0];
_steam setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 6, [0, 0, 0], [0, 0, 25], 3, 9, 7, 0.1, [4, 12, 20], [[1, 1, 1, 0.6], [1, 1, 1, 0.3], [1, 1, 1, 0]], [1], 1, 0, "", "", _src];
_steam setDropInterval 0.01;

// Debris thrown clear: soil, splinters and rock on bouncing arcs.
private _fountains = [];
{
    private _debris = "#particlesource" createVehicleLocal _pos;
    _debris setParticleCircle [_radius / 6, [0, 0, 0]];
    _debris setParticleRandom [2, [8, 8, 4], [20, 20, 25], 0, 0.5, [0, 0, 0, 0.2], 1, 0];
    _debris setParticleParams [[_x, 1, 0, 1], "", "SpaceObject", 1, 8, [0, 0, 2], [0, 0, 55], 1, 250, 6, 0, [1.5, 1.5, 1], [[0.25, 0.22, 0.2, 1], [0.3, 0.28, 0.25, 1], [0.35, 0.33, 0.3, 0]], [0.3, 0.8], 1, 0, "", "", _src, 0, true, 0.55, [[0, 0, 0, 0]]];
    _debris setDropInterval 0.05;
    _fountains pushBack _debris;
} forEach [
    "\A3\data_f\ParticleEffects\Universal\Mud.p3d",
    "\A3\data_f\ParticleEffects\Universal\TreePart.p3d",
    "\A3\data_f\ParticleEffects\Universal\StoneSmall.p3d"
];

private _distance = player distance2D _pos;
if (_distance < _radius * 8) then {
    private _falloff = linearConversion [0, _radius * 8, _distance, 1, 0.1, true];
    enableCamShake true;
    addCamShake [9 * _falloff, 1.5, 30];
    [{
        params ["_falloff"];
        addCamShake [3 * _falloff, 6, 18];
        [{addCamShake [0.8 * (_this select 0), 20, 10]}, [_falloff], 5] call CBA_fnc_waitAndExecute;
    }, [_falloff], 1.5] call CBA_fnc_waitAndExecute;
};

// Impact, then the echo rolling back off the terrain.
_src say3D ["steamer_erupt_1", 4000];
[{
    params ["_src"];
    if (!isNull _src) then {_src say3D ["steamer_erupt_2", 4500]};
}, [_src], 0.8] call CBA_fnc_waitAndExecute;

[{
    params ["_shock", "_steam"];
    deleteVehicle _shock;
    deleteVehicle _steam;
}, [_shock, _steam], 1.5] call CBA_fnc_waitAndExecute;

[{
    params ["_fountains"];
    {deleteVehicle _x} forEach _fountains;
}, [_fountains], 2.5] call CBA_fnc_waitAndExecute;

[{
    params ["_vortex", "_src"];
    deleteVehicle _vortex;
    deleteVehicle _src;
}, [_vortex, _src], 12] call CBA_fnc_waitAndExecute;
