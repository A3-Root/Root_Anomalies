#include "\z\root_anomalies\addons\burper\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local blast FX for the Burper: leaves, dust and distortion bursts with
 *              near/far blast sounds. Runs until the cycle completes.
 *
 * Arguments:
 * 0: Anomaly object (range/cycle reference) <OBJECT>
 * 1: Visual sphere object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_workObj", "_sphere"];

while {((player distance _workObj) < 1500) && {(_workObj getVariable [QGVAR(cycCompli), 1]) < 3}} do {
    if ((player distance _workObj) < 100) then {
        private _near = selectRandom ["01_blast", "02_blast", "03_blast"];
        enableCamShake true;
        addCamShake [1, 4, 13 + (random 33)];
        _workObj say3D [_near, 100];
    } else {
        private _far = selectRandom ["01_far_blast", "02_far_blast", "03_far_blast"];
        _workObj say3D [_far, 500];
    };

    private _leaves = "#particlesource" createVehicleLocal (getPosATL _sphere);
    _leaves setParticleCircle [5, [-3, -3, 0]];
    _leaves setParticleRandom [2, [6, 6, 0], [-7, -7, 0], 5, 1, [0, 0, 0, 1], 1, 1];
    _leaves setParticleParams [["\A3\data_f\ParticleEffects\Hit_Leaves\Leaves_Green.p3d", 1, 0, 1], "", "SpaceObject", 1, 1, [0, 0, 0], [2, 2, 2], 0, 12, 7.9, 0.075, [2, 2, 2], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _sphere];
    _leaves setDropInterval 0.005;

    private _dust = "#particlesource" createVehicleLocal (getPosATL _sphere);
    _dust setParticleCircle [3, [-3, -3, 0]];
    _dust setParticleRandom [2, [2, 2, 0], [-7, -7, 0], 5, 1, [0, 0, 0, 1], 1, 1];
    _dust setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 2, [0, 0, 0], [0, 0, 0.1], 0, 10, 7.9, 0.075, [1, 3, 5], [[0.3, 0.27, 0.15, 0.1], [0.3, 0.27, 0.15, 0.01], [0.3, 0.27, 0.15, 0]], [0.08], 1, 0, "", "", _sphere];
    _dust setDropInterval 0.01;

    private _distort = "#particlesource" createVehicleLocal (getPosATL _sphere);
    _distort setParticleCircle [0, [0, 0, 0]];
    _distort setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
    _distort setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 1.5, [0, 0, 0], [0, 0, 0], 7, 10, 7.9, 0.007, [2, 2, 30, 1], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _sphere];
    _distort setDropInterval 0.4;

    private _smoke = "#particlesource" createVehicleLocal (getPosATL _sphere);
    _smoke setParticleCircle [0, [0, 0, 0]];
    _smoke setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
    _smoke setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 1, [0, 0, 0], [0, 0, 0.75], 15, 10, 7.9, 0.001, [5, 10, 1], [[1, 1, 1, 0.01], [1, 1, 1, 0.05], [0, 0, 0, 0]], [0.08], 1, 0, "", "", _sphere];
    _smoke setDropInterval 0.5;

    uiSleep (0.5 + random 1);
    deleteVehicle _dust;
    deleteVehicle _leaves;
    deleteVehicle _distort;
    deleteVehicle _smoke;
    uiSleep (5 + random 3);
};
