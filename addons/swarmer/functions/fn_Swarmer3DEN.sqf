#include "\z\root_anomalies\addons\swarmer\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN Editor front-end for the Swarmer.
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

private _hiveClass = _logic getVariable ["ROOT_SWARMER_HIVE", "Land_GarbageBags_F"];
private _territory = _logic getVariable ["ROOT_SWARMER_RADIUS", 75];
private _override = _logic getVariable ["ROOT_SWARMER_OVERRIDE", false];
private _disablePesticide = _logic getVariable ["ROOT_SWARMER_DISABLEPEST", false];
private _pesticide = _logic getVariable ["ROOT_SWARMER_PESTICIDE", "SmokeShellGreen"];
private _damage = _logic getVariable ["ROOT_SWARMER_DAMAGE", 0.6];

if (getNumber (configFile >> "CfgVehicles" >> _hiveClass >> "scope") <= 0) then {_hiveClass = "Land_GarbageBags_F"};
if (getNumber (configFile >> "CfgVehicles" >> _pesticide >> "scope") <= 0) then {_pesticide = "SmokeShellGreen"};
if (_disablePesticide) then {_pesticide = ""};
if (!_override && {_territory < 75}) then {_territory = 75};

private _hive = _hiveClass createVehicle getPosATL _logic;

LOG_DEBUG_1("Swarmer3DEN activating hive %1",_hiveClass);

[_hive, _territory, _pesticide, _damage] call Root_fnc_SwarmerMain;
