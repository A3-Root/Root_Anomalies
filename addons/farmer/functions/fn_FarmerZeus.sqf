#include "\z\root_anomalies\addons\farmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Zeus (ZEN) front-end for the Farmer. Opens a configuration dialog and
 *              hands off to Root_fnc_FarmerMain on the server.
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

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_FARMER_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_FARMER_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_FARMER_%1", _idx];

private _pos = getPosATL _logic;
createMarker [_markerName, _pos];
deleteVehicle _logic;

[
    "Farmer Anomaly Settings",
    [
        ["SLIDER", ["Farmer Health", "Damage the Farmer takes before being killed."], [10, 5000, 400, 0]],
        ["TOOLBOX:YESNO", ["Override Minimum Territory", "If true, the minimum territory radius of 75m can be reduced."], false],
        ["SLIDER:RADIUS", ["Farmer Territory", "Radius in meters of the Farmer's territory."], [10, 1000, 75, 0, _pos, [7, 120, 32, 1]]],
        ["TOOLBOX:YESNO", ["AI Panic", "If true, AI flee from the Farmer during attacks."], false],
        ["SLIDER:PERCENT", ["Farmer Damage", "Fraction of damage the Farmer does to its target."], [0.01, 1, 0.6, 2]],
        ["SLIDER", ["Farmer Recharge Delay", "Seconds between Farmer attacks."], [3, 60, 5, 0]]
    ],
    {
        params ["_results", "_markerName"];
        _results params ["_health", "_override", "_territory", "_aiPanic", "_damage", "_recharge"];

        if (!_override && {_territory < 75}) then {_territory = 75};

        ["Farmer Anomaly configured and created!"] call zen_common_fnc_showMessage;
        [_markerName, _territory, _damage, _recharge, round _health, _aiPanic] remoteExec ["Root_fnc_FarmerMain", 2];
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
        playSound "FD_Start_F";
    },
    _markerName
] call zen_dialog_fnc_create;
