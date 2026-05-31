#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN Editor front-end for the Strigoi.
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

private _health = _logic getVariable ["ROOT_STRIGOI_HEALTH", 400];
private _territory = _logic getVariable ["ROOT_STRIGOI_RADIUS", 75];
private _override = _logic getVariable ["ROOT_STRIGOI_OVERRIDE", false];
private _damage = _logic getVariable ["ROOT_STRIGOI_DAMAGE", 0.6];
private _aiPanic = _logic getVariable ["ROOT_STRIGOI_AIPANIC", false];
private _nightOnly = _logic getVariable ["ROOT_STRIGOI_NIGHTONLY", false];
private _noseize = _logic getVariable ["ROOT_STRIGOI_SEIZURESAFE", false];

if (!_override && {_territory < 75}) then {_territory = 75};

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_STRIGOI_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_STRIGOI_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_STRIGOI_%1", _idx];
createMarker [_markerName, getPosATL _logic];

LOG_DEBUG_1("Strigoi3DEN activating marker %1",_markerName);

private _config = [_logic, "strigoi"] call root_anomalies_main_fnc_cfgCapture;
[_markerName, _territory, _nightOnly, _damage, round _health, _noseize, _aiPanic, _config] call root_anomalies_strigoi_fnc_StrigoiMain;
