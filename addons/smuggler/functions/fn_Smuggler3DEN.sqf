#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN Editor front-end for the Smuggler.
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

private _roaming = _logic getVariable ["ROOT_SMUGGLER_ROAMING", false];
private _detectable = _logic getVariable ["ROOT_SMUGGLER_DETECTABLE", true];
private _protectable = _logic getVariable ["ROOT_SMUGGLER_PROTECTABLE", true];
private _disableSpawn = _logic getVariable ["ROOT_SMUGGLER_DISABLESPAWN", false];
private _detector = _logic getVariable ["ROOT_SMUGGLER_DETECTOR", "MineDetector"];
private _protector = _logic getVariable ["ROOT_SMUGGLER_PROTECTOR", "B_Kitbag_mcamo"];
private _spawnStr = _logic getVariable ["ROOT_SMUGGLER_SPAWNLIST", ""];
private _spawnDelay = _logic getVariable ["ROOT_SMUGGLER_SPAWNDELAY", 10];
private _damage = _logic getVariable ["ROOT_SMUGGLER_DAMAGE", 0.1];
private _seizureSafe = _logic getVariable ["ROOT_SMUGGLER_SEIZURESAFE", false];

if (!_detectable) then {_detector = ""};
if (!_protectable) then {_protector = ""};
private _spawnList = if (_disableSpawn) then {[]} else {[_spawnStr] call EFUNC(main,parseClassList)};

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_SMUGGLER_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_SMUGGLER_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_SMUGGLER_%1", _idx];
createMarker [_markerName, getPosATL _logic];

LOG_DEBUG_1("Smuggler3DEN activating marker %1",_markerName);

private _config = [_logic, "smuggler"] call EFUNC(main,cfgCapture);
[_markerName, _roaming, _detector, _spawnList, _spawnDelay, _protector, _damage, _seizureSafe, _config] call FUNC(SmugglerMain);
