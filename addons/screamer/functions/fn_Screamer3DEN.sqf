#include "\z\root_anomalies\addons\screamer\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN Editor front-end for the Screamer.
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

private _model = _logic getVariable ["ROOT_SCREAMER_MODEL", "Land_AncientStatue_01_F"];
private _health = _logic getVariable ["ROOT_SCREAMER_HEALTH", 400];
private _territory = _logic getVariable ["ROOT_SCREAMER_RADIUS", 100];
private _atkRadius = _logic getVariable ["ROOT_SCREAMER_ATKRADIUS", 50];
private _hostilesStr = _logic getVariable ["ROOT_SCREAMER_HOSTILES", "EAST,WEST,GUER,CIV"];
private _spawnSideStr = _logic getVariable ["ROOT_SCREAMER_SPAWNSIDE", "EAST"];
private _affectVehicles = _logic getVariable ["ROOT_SCREAMER_VEHICLE", true];
private _aiEngage = _logic getVariable ["ROOT_SCREAMER_AIENGAGE", false];
private _aiPanic = _logic getVariable ["ROOT_SCREAMER_AIPANIC", false];
private _dmgClose = _logic getVariable ["ROOT_SCREAMER_DMGCLOSE", 0.8];
private _dmgMedium = _logic getVariable ["ROOT_SCREAMER_DMGMED", 0.4];
private _dmgFar = _logic getVariable ["ROOT_SCREAMER_DMGFAR", 0.2];

private _hostiles = [_hostilesStr] call EFUNC(main,parseSides);
if (_hostiles isEqualTo []) then {_hostiles = [east, west, civilian, resistance]};

private _spawnSide = if (_aiEngage) then {([_spawnSideStr] call EFUNC(main,parseSides)) param [0, civilian]} else {civilian};

if (_atkRadius > (_territory / 2)) then {_atkRadius = _territory / 2};
if (_territory < (_atkRadius * 2)) then {_territory = _atkRadius * 2};

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_SCREAMER_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_SCREAMER_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_SCREAMER_%1", _idx];
createMarker [_markerName, getPosATL _logic];

LOG_DEBUG_1("Screamer3DEN activating marker %1",_markerName);

private _config = [_logic, "screamer"] call EFUNC(main,cfgCapture);
_config set ["protGear", [_logic getVariable ["ROOT_PROTGEAR", ""]] call EFUNC(main,parseClassList)];
_config set ["protPct", _logic getVariable ["ROOT_PROTPCT", 0.5]];
_config set ["immGear", [_logic getVariable ["ROOT_IMMGEAR", ""]] call EFUNC(main,parseClassList)];
_config set ["immMode", _logic getVariable ["ROOT_IMMMODE", "Infinite"]];
_config set ["immValue", _logic getVariable ["ROOT_IMMVALUE", 0]];
[_markerName, _model, _dmgClose, _dmgMedium, _dmgFar, _territory, _hostiles, _atkRadius, _affectVehicles, _aiEngage, _aiPanic, _spawnSide, _health, _config] call FUNC(ScreamerMain);
