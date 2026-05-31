#include "\z\root_anomalies\addons\farmer\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN Editor front-end for the Farmer.
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

private _health = _logic getVariable ["ROOT_FARMER_HEALTH", 400];
private _territory = _logic getVariable ["ROOT_FARMER_RADIUS", 75];
private _override = _logic getVariable ["ROOT_FARMER_OVERRIDE", false];
private _damage = _logic getVariable ["ROOT_FARMER_DAMAGE", 0.6];
private _recharge = _logic getVariable ["ROOT_FARMER_RECHARGE", 5];
private _aiPanic = _logic getVariable ["ROOT_FARMER_AIPANIC", false];

if (!_override && {_territory < 75}) then {_territory = 75};

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_FARMER_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_FARMER_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_FARMER_%1", _idx];
createMarker [_markerName, getPosATL _logic];

LOG_DEBUG_1("Farmer3DEN activating marker %1",_markerName);

private _config = [_logic, "farmer"] call root_anomalies_main_fnc_cfgCapture;
[_markerName, _territory, _damage, _recharge, round _health, _aiPanic, _config] call root_anomalies_farmer_fnc_FarmerMain;
