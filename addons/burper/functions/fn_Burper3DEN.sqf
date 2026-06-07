#include "\z\root_anomalies\addons\burper\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN Editor front-end for the Burper. Reads the module attributes and
 *              hands off to root_anomalies_burper_fnc_BurperMain on the server.
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

private _radius = _logic getVariable ["ROOT_BURPER_RADIUS", 10];
private _vehicleAllowed = _logic getVariable ["ROOT_BURPER_VEHICLE", true];
private _roaming = _logic getVariable ["ROOT_BURPER_ROAMING", false];
private _detectable = _logic getVariable ["ROOT_BURPER_DETECTABLE", true];
private _protectable = _logic getVariable ["ROOT_BURPER_PROTECTABLE", true];
private _killable = _logic getVariable ["ROOT_BURPER_KILLABLE", true];
private _aiPanic = _logic getVariable ["ROOT_BURPER_AIPANIC", true];
private _killRange = _logic getVariable ["ROOT_BURPER_KILLRANGE", 20];
private _detector = _logic getVariable ["ROOT_BURPER_DETECTOR", "MineDetector"];
private _protector = _logic getVariable ["ROOT_BURPER_PROTECTOR", "B_Kitbag_mcamo"];
private _killDevice = _logic getVariable ["ROOT_BURPER_KILLDEVICE", "O_Truck_03_device_F"];

if (!_detectable) then {_detector = ""};
if (!_protectable) then {_protector = ""};
if (!_killable) then {_killDevice = ""; _killRange = 1};

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_BURPER_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_BURPER_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_BURPER_%1", _idx];
createMarker [_markerName, getPosATL _logic];

LOG_DEBUG_1("Burper3DEN activating marker %1",_markerName);

private _config = [_logic, "burper"] call EFUNC(main,cfgCapture);
[_markerName, _roaming, _detector, _protector, _killDevice, _radius, _vehicleAllowed, _killRange, _aiPanic, _config] call FUNC(BurperMain);
