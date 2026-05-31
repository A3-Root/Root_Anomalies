#include "\z\root_anomalies\addons\swarmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local fly-swarm particle emitter around the Swarmer hive.
 *
 * Arguments:
 * 0: Swarmer agent <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_hive"];

while {alive _hive} do {
    waitUntil {uiSleep 1; player distance _hive < 1000};
    private _swarm = "#particlesource" createVehicleLocal (getPos _hive);
    _swarm setParticleCircle [0, [-0.1, -0.1, -0.1]];
    _swarm setParticleRandom [0.1, [3, 3, 2], [0.2, 0.2, -0.1], 0, 0, [0, 0, 0, 1], 1, 1];
    private _flow = (getPosATL _hive vectorFromTo (_hive getRelPos [10, 0])) vectorMultiply 3;
    _swarm setParticleParams [["\A3\animals_f\fly.p3d", 1, 0, 1, 1], "", "SpaceObject", 1, 2, [0, 0, 0], [_flow select 0, _flow select 1, 0], 0, 10, 7.9, 0, [6], [[1, 1, 1, 1]], [1], 1, 1, "", "\z\root_anomalies\addons\swarmer\functions\fn_SwarmerFlies.sqf", _hive, 0];
    _swarm setDropInterval 0.01;
    [_swarm] spawn {params ["_p"]; uiSleep 1.1; deleteVehicle _p};
    waitUntil {player distance _hive > 1000};
};
