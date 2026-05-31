#include "\z\root_anomalies\addons\worm\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local impact FX when the Worm strikes the ground (dust, debris, crater).
 *
 * Arguments:
 * 0: Worm head object <OBJECT>
 * 1: Worm tail object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_head", "_tail"];

enableCamShake true;
_head say3D [selectRandom ["impact_30", "impact_27"], 500];

private _dust = "#particlesource" createVehicleLocal (getPosATL _head);
_dust setParticleCircle [6, [-3, -3, 0]];
_dust setParticleRandom [2, [2, 2, 0], [-15, -15, 0], 5, 1, [0, 0, 0, 1], 1, 0];
_dust setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 7, [0, 0, 0], [0, 0, 0.1], 7, 10, 7.9, 0.005, [5, 7, 13], [[0.3, 0.27, 0.15, 1], [0.3, 0.27, 0.15, 0.5], [0.3, 0.27, 0.15, 0]], [0.08], 1, 0, "", "", _head];
_dust setDropInterval 0.002;

private _shake = linearConversion [0, 1000, player distance _head, 5, 0, true];
addCamShake [_shake, 4, 13 + (random 33)];

private _debris = "#particlesource" createVehicleLocal (getPosATL _head);
_debris setParticleCircle [2, [0, 0, 0]];
_debris setParticleRandom [1, [0.25, 0.25, 0], [10, 10, 15], 0.5, 0.25, [0, 0, 0, 0.1], 0, 0];
_debris setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 10, [0, 0, 0], [0, 0, 13], 3, 20, 7.9, 0.0001, [.6, .6, .6], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _head, 0, true, 0.3, [[0, 0, 0, 0]]];
_debris setDropInterval 0.007;

uiSleep 0.25;
deleteVehicle _debris;
private _crater = createVehicle ["CraterLong", [getPos _head select 0, getPos _head select 1, 0], [], 0, "CAN_COLLIDE"];
_crater setDir (random 360);
uiSleep 0.5;
deleteVehicle _dust;

if (player distance _head < 500) then {playSound (selectRandom ["post_impact_01", "post_impact_02", "post_impact_03", "post_impact_04"])};
uiSleep 60;
deleteVehicle _crater;
