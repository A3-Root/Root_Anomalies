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
        ["SLIDER", ["Wraith Health", "Hits the Wraith takes before it dies."], [10, 5000, 400, 0]],
        ["SLIDER:RADIUS", ["Wraith Territory", "Radius in meters the Wraith hunts in."], [20, 1000, 150, 0, _pos, [120, 20, 20, 1]]],
        ["SLIDER", ["Attack Interval (s)", "Seconds between claw attacks."], [1, 30, 4, 0]],
        ["SLIDER:PERCENT", ["Wraith Damage", "Damage per claw."], [0.01, 1, 0.3, 2]],
        ["COMBO", ["Visible Through", "Which optics reveal the Wraith. To the naked eye it is invisible."], [[0, 1, 2], ["Night vision only", "Thermal only", "Night vision or thermal"], 2]],
        ["SLIDER", ["Run Speed", "Animation speed multiplier while it walks and runs."], [0.6, 2, 1.2, 1]],
        ["EDIT", ["Protective Gear (CSV)", "Gear classnames that reduce the Wraith's damage. Empty = none."], [""]],
        ["SLIDER:PERCENT", ["Protection", "Fraction of damage removed while wearing protective gear."], [0, 1, 0.5, 2]],
        ["EDIT", ["Immunity Gear (CSV)", "Gear classnames granting full immunity until durability is spent. Empty = none."], [""]],
        ["COMBO", ["Immunity Mode", "How immunity gear wears out."], [["Infinite", "Time", "Damage"], ["Infinite (never fails)", "Time (seconds)", "Damage (absorbed)"], 0]],
        ["SLIDER", ["Immunity Value", "Seconds (Time) or total damage (Damage) the gear lasts. 0 = never."], [0, 600, 0, 0]],
        ["SIDES", ["Hostile Sides", "Sides the Wraith attacks. None selected = all."], []],
        ["SLIDER:RADIUS", ["Activation Range (m)", "Players within this distance wake the Wraith."], [50, 3000, 1000, 0, _pos, [120, 120, 40, 1]]]
    ] + ([] call EFUNC(main,zeusCaptureRows)),
    {
        params ["_results", "_markerName"];
        _results params ["_health", "_territory", "_interval", "_damage", "_vision", "_speed", "_protGear", "_protPct", "_immGear", "_immMode", "_immValue", "_sides", "_activation"];

        ["Wraith Anomaly configured and created!"] call zen_common_fnc_showMessage;
        private _config = createHashMapFromArray [["type", "wraith"], ["manageDamage", false], ["territory", _territory], ["damage", _damage], ["interval", _interval], ["hostileSides", _sides], ["activationRange", _activation], ["protGear", [_protGear] call EFUNC(main,parseClassList)], ["protPct", _protPct], ["immGear", [_immGear] call EFUNC(main,parseClassList)], ["immMode", _immMode], ["immValue", _immValue]];
        [_config, _results] call EFUNC(main,zeusCaptureApply);
        [_markerName, round _health, _territory, round _interval, _damage, _vision, _speed, _config] remoteExec [QFUNC(WraithMain), 2];
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
        playSound "FD_Start_F";
    },
    _markerName
] call zen_dialog_fnc_create;
