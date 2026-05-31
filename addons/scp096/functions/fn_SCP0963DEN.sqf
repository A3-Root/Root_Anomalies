#include "\z\root_anomalies\addons\scp096\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN Editor front-end for SCP-096.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 * 1: Synced units <ARRAY>
 * 2: Activated <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_logic", "_units", "_activated"];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};

private _model = _logic getVariable ["ROOT_SCP096_MODEL", "B_VR_Soldier_F"];
private _triggerRange = _logic getVariable ["ROOT_SCP096_TRIGGER", 200];
private _speed = _logic getVariable ["ROOT_SCP096_SPEED", 11];
private _cooldown = _logic getVariable ["ROOT_SCP096_COOLDOWN", 20];
private _damage = _logic getVariable ["ROOT_SCP096_DAMAGE", 1];
private _affectAI = _logic getVariable ["ROOT_SCP096_AI", true];

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_SCP096_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_SCP096_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_SCP096_%1", _idx];
createMarker [_markerName, getPosATL _logic];

LOG_DEBUG_1("SCP0963DEN activating marker %1",_markerName);

[_markerName, _model, _triggerRange, _speed, _cooldown, _damage, _affectAI] call Root_fnc_SCP096Main;
