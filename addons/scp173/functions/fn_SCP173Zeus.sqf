#include "\z\root_anomalies\addons\scp173\script_component.hpp"
/*
 * Author: Root
 * Description: Zeus (ZEN) front-end for SCP-173.
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

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_SCP173_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_SCP173_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_SCP173_%1", _idx];

private _pos = getPosATL _logic;
createMarker [_markerName, _pos];
deleteVehicle _logic;

[
    "SCP-173 Settings",
    [
        ["EDIT", ["Model", "Classname of the unit used as SCP-173."], ["B_VR_Soldier_F"]],
        ["SLIDER:RADIUS", ["Territory", "Radius in meters within which SCP-173 hunts."], [20, 1000, 150, 0, _pos, [7, 120, 32, 1]]],
        ["SLIDER", ["Blink Distance", "Maximum distance SCP-173 closes each time it is unobserved."], [1, 50, 8, 0]],
        ["SLIDER", ["Kill Distance", "Distance within which SCP-173 snaps a target's neck."], [1, 10, 2.5, 1]],
        ["TOOLBOX:YESNO", ["Affect AI", "If true, AI also count as observers and as prey."], true]
    ],
    {
        params ["_results", "_markerName"];
        _results params ["_model", "_territory", "_blink", "_killDist", "_affectAI"];

        ["SCP-173 configured and contained... for now."] call zen_common_fnc_showMessage;
        [_markerName, _model, _territory, _blink, _killDist, _affectAI] remoteExec ["Root_fnc_SCP173Main", 2];
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
        playSound "FD_Start_F";
    },
    _markerName
] call zen_dialog_fnc_create;
