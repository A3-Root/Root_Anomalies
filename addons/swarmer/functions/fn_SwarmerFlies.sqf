#include "\z\root_anomalies\addons\swarmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Per-particle onTimer script for the Swarmer fly swarm. Re-drops a fly
 *              particle steered toward the hive or its current target.
 *              (Invoked by the engine `drop` command, not called directly.)
 *
 * Arguments:
 * _this: current particle position <ARRAY>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

private _agent = missionNamespace getVariable ["ROOT_ANOMALIES_SWARMER_AGENT", objNull];
if ((isNull _agent) || {!alive _agent} || {player distance _agent > 1000}) exitWith {};

private _tgt = _agent getVariable [QGVAR(tgt), objNull];
private _atk = missionNamespace getVariable ["ROOT_ANOMALIES_SWARMER_ATK", false];
private _flowBack = [0, 0, 0];

if (isNull _tgt) then {
    _flowBack = _this vectorFromTo [(getPosATL _agent select 0) + random (selectRandom [1, -1]), (getPosATL _agent select 1) + random (selectRandom [1, -1]), random 2];
} else {
    if (_atk) then {
        _flowBack = (_this vectorFromTo [getPosATL _tgt select 0, getPosATL _tgt select 1, 0.5 + random 1]) vectorMultiply (3 + random 5);
    } else {
        _flowBack = (_this vectorFromTo [(getPosATL _agent select 0) + random 2, (getPosATL _agent select 1) + random 2, 0.5 + random 1]) vectorMultiply (3 + random 5);
    };
};

drop [["\A3\animals_f\fly.p3d", 1, 0, 1, 1], "", "SpaceObject", 1, 0.5, _this, _flowBack, 0, 10, 7.9, 0, [6], [[1, 1, 1, 1]], [1], 1, 1, "", "\z\root_anomalies\addons\swarmer\functions\fn_SwarmerFlies.sqf", _this];
drop [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d", 8, 0, 40, 0], "", "Billboard", 1, 0.5, _this, [0, 0, 0], 0, 10, 8, 0, [5, 5, 5], [[0, 0, 0, 0], [0, 0, 0, 0.01], [0, 0, 0, 0]], [1], 0, 0, "", "", _this];
