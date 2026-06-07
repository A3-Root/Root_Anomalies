#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Client suction FX loop for the Smuggler (leaf/dust vortex + sound) that
 *              runs while the player's loopDust flag is set.
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
