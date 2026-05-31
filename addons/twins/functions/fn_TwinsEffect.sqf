#include "\z\root_anomalies\addons\twins\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local electric spark flash on the Twins object.
 *
 * Arguments:
 * 0: Emitter object <OBJECT>
 * 1: Pause duration <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_emit", ["_pause", 1, [0]]];

private _sparkSound = selectRandom ["spark1", "spark11", "spark2", "spark22", "spark5", "spark4"];
private _drop = 0.001 + (random 0.05);
private _spark = "#particlesource" createVehicleLocal (getPosATL _emit);

if (selectRandom ["white", "orange"] == "orange") then {
    _spark setParticleCircle [0, [0, 0, 0]];
    _spark setParticleRandom [2, [0.1, 0.1, 0.1], [0, 0, 0], 0, 0.25, [0, 0, 0, 0], 0, 0];
    _spark setParticleParams [["\A3\data_f\proxies\muzzle_flash\muzzle_flash_silencer.p3d", 1, 0, 1], "", "SpaceObject", 1, 1.5, [0, 0, 0], [0, 0, 0], 0, 15, 7.9, 0, [2, 2, 1], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0.5]], [0.08], 1, 0, "", "", _emit];
    _spark setDropInterval _drop;
    _emit say3D [_sparkSound, 350];
    uiSleep _pause;
} else {
    _spark setParticleCircle [0, [0, 0, 0]];
    _spark setParticleRandom [1, [0.05, 0.05, 0.1], [5, 5, 3], 0, 0.0025, [0, 0, 0, 0], 0, 0];
    _spark setParticleParams [["\A3\data_f\proxies\muzzle_flash\muzzle_flash_silencer.p3d", 1, 0, 1], "", "SpaceObject", 1, 1.5, [0, 0, 0], [0, 0, 0], 0, 20, 7.9, 0, [1, 1, 0.5], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0.5]], [0.08], 1, 0, "", "", _emit];
    _spark setDropInterval 0.001;
    _emit say3D [_sparkSound, 350];
    uiSleep (0.1 + random 0.4);
};

deleteVehicle _spark;
