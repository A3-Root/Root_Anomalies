#include "\z\root_anomalies\addons\steamer\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN Editor front-end for the Steamer.
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

private _territory = _logic getVariable ["ROOT_STEAMER_RADIUS", 75];
private _override = _logic getVariable ["ROOT_STEAMER_OVERRIDE", false];
private _damage = _logic getVariable ["ROOT_STEAMER_DAMAGE", 0.2];
private _recharge = _logic getVariable ["ROOT_STEAMER_RECHARGE", 10];
private _deathDamage = _logic getVariable ["ROOT_STEAMER_DEATHDMG", 0.6];
private _travelPath = _logic getVariable ["ROOT_STEAMER_TRAVELPATH", false];

if (!_override && {_territory < 75}) then {_territory = 75};

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_STEAMER_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_STEAMER_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_STEAMER_%1", _idx];
createMarker [_markerName, getPosATL _logic];

LOG_DEBUG_1("Steamer3DEN activating marker %1",_markerName);

[_markerName, _territory, _damage, _recharge, _deathDamage, _travelPath] call Root_fnc_SteamerMain;
