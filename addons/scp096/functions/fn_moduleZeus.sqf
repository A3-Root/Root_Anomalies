#include "\z\root_anomalies\addons\scp096\script_component.hpp"
/*
 * Author: Root
 * Description: Zeus (ZEN) front-end for SCP-096. Presents a settings dialog, then spawns
 *              the anomaly through the unified API.
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

private _pos = getPosATL _logic;
deleteVehicle _logic;

[
    "SCP-096 Settings",
    [
        ["EDIT", ["Model", "Classname of the unit used as SCP-096."], ["B_VR_Soldier_F"]],
        ["SLIDER:RADIUS", ["Trigger Range (m)", "Distance within which viewing its face counts."], [20, 2000, 200, 0, _pos, [7, 120, 32, 1]]],
        ["SLIDER", ["View Time (s)", "Seconds of continuous viewing before a viewer becomes a target."], [1, 30, 5, 0]],
        ["SLIDER", ["Rage Speed (m/s)", "Sprint speed while enraged."], [4, 25, 11, 0]],
        ["SLIDER", ["Calm Cooldown (s)", "Seconds enraged after the last target before calming."], [1, 120, 20, 0]],
        ["SLIDER", ["Health", "Hit points absorbed before disabled."], [1, 200, 25, 0]],
        ["TOOLBOX:YESNO", ["Affect AI", "If yes, AI viewers/attackers also become targets."], true],
        ["TOOLBOX:YESNO", ["Capturable", "Allow sedation + capture."], true]
    ],
    {
        params ["_results", "_pos"];
        _results params ["_model", "_trigger", "_viewTime", "_speed", "_cooldown", "_health", "_affectAI", "_capture"];

        private _cfg = createHashMapFromArray [
            ["model", _model], ["triggerRange", _trigger], ["viewTime", _viewTime],
            ["speed", _speed], ["cooldown", _cooldown], ["health", _health],
            ["affectAI", _affectAI], ["captureEnabled", _capture], ["enrageOnDamage", true]
        ];
        ["scp096", _pos, _cfg] call API(spawn);
        ["SCP-096 configured and contained... for now."] call zen_common_fnc_showMessage;
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
    },
    _pos
] call zen_dialog_fnc_create;
