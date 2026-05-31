#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Zeus (ZEN) front-end for the Strigoi.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_logic"];

if (!hasInterface) exitWith {};

if !(isClass (configFile >> "CfgPatches" >> "zen_custom_modules")) exitWith {
    LOG_ERROR("ZEN not detected - Zeus modules require Zeus Enhanced.");
};

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_STRIGOI_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_STRIGOI_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_STRIGOI_%1", _idx];

private _pos = getPosATL _logic;
createMarker [_markerName, _pos];
deleteVehicle _logic;

[
    "Strigoi Anomaly Settings",
    [
        ["SLIDER", ["Strigoi Health", "Damage the Strigoi takes before being killed."], [10, 5000, 400, 0]],
        ["TOOLBOX:YESNO", ["Override Minimum Territory", "If true, the minimum territory radius of 75m can be reduced."], false],
        ["SLIDER:RADIUS", ["Strigoi Territory", "Radius in meters of the Strigoi's territory."], [10, 1000, 75, 0, _pos, [7, 120, 32, 1]]],
        ["SLIDER:PERCENT", ["Strigoi Damage", "Fraction of damage the Strigoi does to its target."], [0.01, 1, 0.6, 2]],
        ["TOOLBOX:YESNO", ["AI Panic", "If true, AI flee from the Strigoi during attacks."], false],
        ["TOOLBOX:YESNO", ["Night Mode Only", "If true, the Strigoi is only active during the night."], false],
        ["TOOLBOX:YESNO", ["Disable Sensitive Lights", "If true, the Strigoi's flashing/seizure visual is disabled."], false]
    ],
    {
        params ["_results", "_markerName"];
        _results params ["_health", "_override", "_territory", "_damage", "_aiPanic", "_nightOnly", "_noseize"];

        if (!_override && {_territory < 75}) then {_territory = 75};

        ["Strigoi Anomaly configured and created!"] call zen_common_fnc_showMessage;
        [_markerName, _territory, _nightOnly, _damage, round _health, _noseize, _aiPanic] remoteExec ["Root_fnc_StrigoiMain", 2];
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
        playSound "FD_Start_F";
    },
    _markerName
] call zen_dialog_fnc_create;
