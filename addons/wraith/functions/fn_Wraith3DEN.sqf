#include "\z\root_anomalies\addons\wraith\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN Editor front-end for the Wraith.
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

private _model = _logic getVariable ["ROOT_WRAITH_MODEL", "B_VR_Soldier_F"];
private _health = _logic getVariable ["ROOT_WRAITH_HEALTH", 400];
private _territory = _logic getVariable ["ROOT_WRAITH_RADIUS", 150];
private _interval = _logic getVariable ["ROOT_WRAITH_INTERVAL", 8];
private _damage = _logic getVariable ["ROOT_WRAITH_DAMAGE", 0.4];
private _fearRadius = _logic getVariable ["ROOT_WRAITH_FEAR", 25];
private _noseize = _logic getVariable ["ROOT_WRAITH_SEIZURESAFE", false];

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_WRAITH_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_WRAITH_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_WRAITH_%1", _idx];
createMarker [_markerName, getPosATL _logic];

LOG_DEBUG_1("Wraith3DEN activating marker %1",_markerName);

[_markerName, _model, round _health, _territory, _interval, _damage, _fearRadius, _noseize] call root_anomalies_wraith_fnc_WraithMain;
