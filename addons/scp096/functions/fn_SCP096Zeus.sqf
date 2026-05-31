#include "\z\root_anomalies\addons\scp096\script_component.hpp"
/*
 * Author: Root
 * Description: Zeus (ZEN) front-end for SCP-096.
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

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_SCP096_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_SCP096_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_SCP096_%1", _idx];

private _pos = getPosATL _logic;
createMarker [_markerName, _pos];
deleteVehicle _logic;

[
    "SCP-096 Settings",
    [
        ["EDIT", ["Model", "Classname of the unit used as SCP-096."], ["B_VR_Soldier_F"]],
        ["SLIDER:RADIUS", ["Trigger Range", "Distance within which seeing SCP-096's face enrages it."], [20, 1000, 200, 0, _pos, [7, 120, 32, 1]]],
        ["SLIDER", ["Rage Speed (m/s)", "How fast SCP-096 sprints toward its victims while enraged."], [4, 30, 11, 0]],
        ["SLIDER", ["Calm Cooldown (s)", "Seconds SCP-096 stays enraged after its last victim before calming."], [1, 120, 20, 0]],
        ["SLIDER:PERCENT", ["Damage", "Fraction of damage dealt to a victim on contact (100% = instant kill)."], [0.01, 1, 1, 2]],
        ["TOOLBOX:YESNO", ["Affect AI", "If true, AI that damage SCP-096 also become targets."], true]
    ],
    {
        params ["_results", "_markerName"];
        _results params ["_model", "_triggerRange", "_speed", "_cooldown", "_damage", "_affectAI"];

        ["SCP-096 configured. Do NOT look at its face."] call zen_common_fnc_showMessage;
        [_markerName, _model, _triggerRange, _speed, _cooldown, _damage, _affectAI] remoteExec ["Root_fnc_SCP096Main", 2];
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
        playSound "FD_Start_F";
    },
    _markerName
] call zen_dialog_fnc_create;
