#include "\z\root_anomalies\addons\steamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Zeus (ZEN) front-end for the Steamer.
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

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_STEAMER_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_STEAMER_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_STEAMER_%1", _idx];

private _pos = getPosATL _logic;
createMarker [_markerName, _pos];
deleteVehicle _logic;

[
    "Steamer Anomaly Settings",
    [
        ["TOOLBOX:YESNO", ["Override Minimum Territory", "If true, the minimum territory radius of 75m can be reduced."], false],
        ["SLIDER:RADIUS", ["Steamer Territory", "Radius in meters of the Steamer's territory."], [10, 1000, 75, 0, _pos, [7, 120, 32, 1]]],
        ["SLIDER:PERCENT", ["Steamer Damage", "Fraction of damage the Steamer does to its target."], [0.01, 1, 0.2, 2]],
        ["SLIDER", ["Steamer Recharge Delay", "Seconds between Steamer bursts."], [5, 60, 10, 0]],
        ["SLIDER:PERCENT", ["Steamer Damage on Death", "Fraction of damage the Steamer does on death."], [0.01, 1, 0.6, 2]],
        ["TOOLBOX:YESNO", ["Enable Travel Path", "If true, the Steamer digs a visible mud trail toward its target."], false]
    ],
    {
        params ["_results", "_markerName"];
        _results params ["_override", "_territory", "_damage", "_recharge", "_deathDamage", "_travelPath"];

        if (!_override && {_territory < 75}) then {_territory = 75};

        ["Steamer Anomaly configured and created!"] call zen_common_fnc_showMessage;
        [_markerName, _territory, _damage, _recharge, _deathDamage, _travelPath] remoteExec ["root_anomalies_steamer_fnc_SteamerMain", 2];
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
        playSound "FD_Start_F";
    },
    _markerName
] call zen_dialog_fnc_create;
