#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN Editor front-end for the Flamer.
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

private _health = _logic getVariable ["ROOT_FLAMER_HEALTH", 400];
private _territory = _logic getVariable ["ROOT_FLAMER_RADIUS", 75];
private _override = _logic getVariable ["ROOT_FLAMER_OVERRIDE", false];
private _damage = _logic getVariable ["ROOT_FLAMER_DAMAGE", 0.4];
private _recharge = _logic getVariable ["ROOT_FLAMER_RECHARGE", 1];
private _deathDamage = _logic getVariable ["ROOT_FLAMER_DEATHDMG", 1];
private _aiPanic = _logic getVariable ["ROOT_FLAMER_AIPANIC", false];

if (!_override && {_territory < 75}) then {_territory = 75};

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_FLAMER_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_FLAMER_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_FLAMER_%1", _idx];
createMarker [_markerName, getPosATL _logic];

LOG_DEBUG_1("Flamer3DEN activating marker %1",_markerName);

private _config = [_logic, "flamer"] call EFUNC(main,cfgCapture);
[_markerName, _territory, _damage, _recharge, round _health, _deathDamage, _aiPanic, _config] call FUNC(FlamerMain);
