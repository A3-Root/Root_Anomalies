#include "\z\root_anomalies\addons\swarmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local death FX for the Swarmer hive (dispersing flies + death buzz).
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

private _swarm = "#particlesource" createVehicleLocal (getPos _hive);
_swarm setParticleCircle [0, [0.1, 0.1, 0]];
_swarm setParticleRandom [0, [1, 1, 1], [-0.1, -0.1, 0.5], 0, 0.2, [0, 0, 0, 1], 0.5, 0.5];
_swarm setParticleParams [["\A3\animals_f\fly.p3d", 1, 0, 1, 1], "", "SpaceObject", 1, 30, [0, 0, 3], [0.1, 0.1, 1], 0, 10.5, 7.9, 0, [5, 10, 10], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [1], 0.5, 0.5, "", "", _hive, 0, true, 0];
_swarm setDropInterval 0.05;

private _src = "Land_HelipadEmpty_F" createVehicleLocal (getPosATL _hive);
_src say3D ["roi_mort", 100];
[_src] spawn {params ["_o"]; uiSleep 5; deleteVehicle _o};

uiSleep 5;
private _decr = 10;
private _dropVar = 0.01;
while {_decr > 0} do {
    _swarm setDropInterval _dropVar;
    uiSleep 1;
    _dropVar = _dropVar + 0.05;
    _decr = _decr - 1;
};
deleteVehicle _swarm;
