#include "\z\root_anomalies\addons\worm\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Zeus (ZEN) front-end for the Worm.
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

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_WORM_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_WORM_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_WORM_%1", _idx];

private _pos = getPosATL _logic;
createMarker [_markerName, _pos];
deleteVehicle _logic;

[
    "Worm Anomaly Settings",
    [
        ["TOOLBOX:YESNO", ["Override Minimum Territory", "If true, the minimum territory radius of 200m can be reduced."], false],
        ["SLIDER:RADIUS", ["Worm Territory", "Radius in meters of the Worm's territory."], [50, 1000, 200, 0, _pos, [7, 120, 32, 1]]],
        ["TOOLBOX:YESNO", ["AI Panic", "If true, AI flee from the Worm during attacks."], false],
        ["EDIT", ["Worm Diffuser", "Classname of the throwable used to kill the Worm."], ["SmokeShellGreen"]],
        ["SLIDER:PERCENT", ["Worm Damage", "Fraction of damage the Worm does to its target."], [0.01, 1, 0.6, 2]]
    ],
    {
        params ["_results", "_markerName"];
        _results params ["_override", "_territory", "_aiPanic", "_diffuser", "_damage"];

        if (!_override && {_territory < 200}) then {_territory = 200};
        if (getNumber (configFile >> "CfgVehicles" >> _diffuser >> "scope") <= 0) then {_diffuser = "SmokeShellGreen"};

        ["Worm Anomaly configured and active!"] call zen_common_fnc_showMessage;
        private _config = createHashMapFromArray [["type", "worm"], ["manageDamage", false], ["captureEnabled", true], ["captureTime", ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME], ["captureRadius", 15]];
        [_markerName, _damage, _territory, _aiPanic, _diffuser, _config] remoteExec ["root_anomalies_worm_fnc_WormMain", 2];
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
        playSound "FD_Start_F";
    },
    _markerName
] call zen_dialog_fnc_create;
