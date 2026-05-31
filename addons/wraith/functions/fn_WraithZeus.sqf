#include "\z\root_anomalies\addons\wraith\script_component.hpp"
/*
 * Author: Root
 * Description: Zeus (ZEN) front-end for the Wraith.
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

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_WRAITH_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_WRAITH_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_WRAITH_%1", _idx];

private _pos = getPosATL _logic;
createMarker [_markerName, _pos];
deleteVehicle _logic;

[
    "Wraith Anomaly Settings",
    [
        ["EDIT", ["Model", "Classname of the unit used as the Wraith."], ["B_VR_Soldier_F"]],
        ["SLIDER", ["Health", "Damage the Wraith takes before being killed."], [10, 5000, 400, 0]],
        ["SLIDER:RADIUS", ["Territory", "Radius in meters within which the Wraith stalks."], [20, 1000, 150, 0, _pos, [7, 120, 32, 1]]],
        ["SLIDER", ["Attack Interval (s)", "Seconds between the Wraith's teleport strikes."], [2, 60, 8, 0]],
        ["SLIDER:PERCENT", ["Damage", "Fraction of fire damage dealt to victims per strike."], [0.01, 1, 0.4, 2]],
        ["SLIDER:RADIUS", ["Fear Radius", "Radius in meters within which the Wraith inflicts dread effects."], [5, 200, 25, 0, _pos, [7, 120, 32, 1]]],
        ["TOOLBOX:YESNO", ["Disable Sensitive Lights", "If true, the Wraith's flickering light/dread visuals are disabled."], false]
    ],
    {
        params ["_results", "_markerName"];
        _results params ["_model", "_health", "_territory", "_interval", "_damage", "_fearRadius", "_noseize"];

        ["Wraith Anomaly configured and summoned!"] call zen_common_fnc_showMessage;
        [_markerName, _model, round _health, _territory, _interval, _damage, _fearRadius, _noseize] remoteExec ["root_anomalies_wraith_fnc_WraithMain", 2];
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
        playSound "FD_Start_F";
    },
    _markerName
] call zen_dialog_fnc_create;
