#include "\z\root_anomalies\addons\scp173\script_component.hpp"
/*
 * Author: Root
 * Description: Zeus (ZEN) front-end for SCP-173. Presents a settings dialog, then spawns
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
    "SCP-173 Settings",
    [
        ["EDIT", ["Model", "Classname of the unit used as SCP-173."], ["B_VR_Soldier_F"]],
        ["SLIDER:RADIUS", ["Territory (m)", "Radius within which SCP-173 hunts (up to 5km)."], [20, 5000, 150, 0, _pos, [7, 120, 32, 1]]],
        ["SLIDER", ["Observation Range (m)", "How close a viewer must be to freeze it (own eyes/binos; UAV excluded)."], [100, 5000, 1000, 0]],
        ["SLIDER", ["Blink Interval (s)", "Seconds between forced blinks while observing."], [2, 30, 7, 0]],
        ["SLIDER", ["Speed (m/s)", "Movement speed while unobserved."], [3, 25, 7, 0]],
        ["SLIDER", ["Kill Distance (m)", "Range at which it snaps a target's neck."], [1, 10, 2.5, 1]],
        ["SLIDER", ["Health", "Hit points absorbed before disabled."], [1, 200, 25, 0]],
        ["TOOLBOX:YESNO", ["Affect AI", "If yes, AI also count as observers and prey."], true],
        ["TOOLBOX:YESNO", ["Capturable", "Allow sedation + capture."], true]
    ],
    {
        params ["_results", "_pos"];
        _results params ["_model", "_radius", "_observe", "_blinkInt", "_speed", "_killDist", "_health", "_affectAI", "_capture"];

        private _cfg = createHashMapFromArray [
            ["model", _model], ["radius", _radius], ["observeDist", _observe],
            ["blinkInterval", _blinkInt], ["speed", _speed], ["killDist", _killDist],
            ["health", _health], ["affectAI", _affectAI], ["captureEnabled", _capture]
        ];
        ["scp173", _pos, _cfg] call API(spawn);
        ["SCP-173 configured and contained... for now."] call zen_common_fnc_showMessage;
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
    },
    _pos
] call zen_dialog_fnc_create;
