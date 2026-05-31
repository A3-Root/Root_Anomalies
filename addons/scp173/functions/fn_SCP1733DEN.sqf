#include "\z\root_anomalies\addons\scp173\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN Editor front-end for SCP-173.
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

private _model = _logic getVariable ["ROOT_SCP173_MODEL", "B_VR_Soldier_F"];
private _territory = _logic getVariable ["ROOT_SCP173_RADIUS", 150];
private _blink = _logic getVariable ["ROOT_SCP173_BLINK", 8];
private _killDist = _logic getVariable ["ROOT_SCP173_KILLDIST", 2.5];
private _affectAI = _logic getVariable ["ROOT_SCP173_AI", true];

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_SCP173_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_SCP173_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_SCP173_%1", _idx];
createMarker [_markerName, getPosATL _logic];

LOG_DEBUG_1("SCP1733DEN activating marker %1",_markerName);

[_markerName, _model, _territory, _blink, _killDist, _affectAI] call Root_fnc_SCP173Main;
