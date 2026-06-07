#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Spawns the burning-body flame particle sources on the Flamer's bone anchors.
 *              Returns the source objects for later cleanup.
 *
 * Arguments:
 * 0: Anchor parts <ARRAY of OBJECT>
 *
 * Return Value:
 * Particle source objects <ARRAY of OBJECT>
 *
 * Public: No
 */

params ["_parts"];

private _sources = [];
{
    private _src = "#particlesource" createVehicleLocal (getPosATL _x);
    _src setParticleCircle [0, [0, 0, 0]];
    _src setParticleRandom [0.1, [0.1, 0.1, 0.5], [0, 0, 0.2], 1, 0.1, [0, 0, 0, 0], 1, 0];
    _src setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d", 16, 15, 10, 1], "", "Billboard", 1, 0.3, [0, 0, 0], [0, 0, 0], 15, 7, 7.9, 1, [0.5, 0.5, 0.1], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0]], [2], 1, 0, "", "", _x];
    _src setDropInterval 0.05;
    _sources pushBackUnique _src;
} forEach _parts;
_sources
