#include "\z\root_anomalies\addons\twins\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN Editor front-end for the Twins.
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

private _twinsClass = _logic getVariable ["ROOT_TWINS_OBJECT", "Land_HighVoltageTower_large_F"];
private _heartClass = _logic getVariable ["ROOT_TWINS_HEART", "B_UAV_06_F"];
private _trackDist = _logic getVariable ["ROOT_TWINS_TRACKDIST", 100];
private _dmgRange = _logic getVariable ["ROOT_TWINS_DMGRANGE", 75];
private _sparks = _logic getVariable ["ROOT_TWINS_SPARKS", true];
private _affectAI = _logic getVariable ["ROOT_TWINS_AI", true];
private _emp = _logic getVariable ["ROOT_TWINS_EMP", true];
private _noseize = _logic getVariable ["ROOT_TWINS_SEIZURESAFE", false];

if (getNumber (configFile >> "CfgVehicles" >> _heartClass >> "scope") <= 0) then {_heartClass = "B_UAV_06_F"};
if (getNumber (configFile >> "CfgVehicles" >> _twinsClass >> "scope") <= 0) then {_twinsClass = "Land_HighVoltageTower_large_F"};
if (_trackDist < _dmgRange) then {_trackDist = _dmgRange + 20};

private _twins = _twinsClass createVehicle getPosATL _logic;

LOG_DEBUG_1("Twins3DEN activating object %1",_twinsClass);

[_twins, _trackDist, _sparks, _dmgRange, _affectAI, _emp, _heartClass, _noseize] call root_anomalies_twins_fnc_TwinsMain;
