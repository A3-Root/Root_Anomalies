#include "\z\root_anomalies\addons\worm\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN Editor front-end for the Worm.
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

private _territory = _logic getVariable ["ROOT_WORM_RADIUS", 200];
private _override = _logic getVariable ["ROOT_WORM_OVERRIDE", false];
private _aiPanic = _logic getVariable ["ROOT_WORM_AIPANIC", false];
private _diffuser = _logic getVariable ["ROOT_WORM_DIFFUSER", "SmokeShellGreen"];
private _damage = _logic getVariable ["ROOT_WORM_DAMAGE", 0.6];
private _forceTgt = _logic getVariable ["ROOT_WORM_FORCETGT", ""];
private _forceN = _logic getVariable ["ROOT_WORM_FORCEN", 3];

if (!_override && {_territory < 200}) then {_territory = 200};
if (getNumber (configFile >> "CfgVehicles" >> _diffuser >> "scope") <= 0) then {_diffuser = "SmokeShellGreen"};

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_WORM_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_WORM_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_WORM_%1", _idx];
createMarker [_markerName, getPosATL _logic];

LOG_DEBUG_1("Worm3DEN activating marker %1",_markerName);

private _config = [_logic, "worm"] call EFUNC(main,cfgCapture);
_config set ["damage", _damage];
_config set ["forceTarget", _forceTgt];
_config set ["forceN", _forceN];
_config set ["protGear", [_logic getVariable ["ROOT_PROTGEAR", ""]] call EFUNC(main,parseClassList)];
_config set ["protPct", _logic getVariable ["ROOT_PROTPCT", 0.5]];
_config set ["immGear", [_logic getVariable ["ROOT_IMMGEAR", ""]] call EFUNC(main,parseClassList)];
_config set ["immMode", _logic getVariable ["ROOT_IMMMODE", "Infinite"]];
_config set ["immValue", _logic getVariable ["ROOT_IMMVALUE", 0]];
[_markerName, _damage, _territory, _aiPanic, _diffuser, _config] call FUNC(WormMain);
