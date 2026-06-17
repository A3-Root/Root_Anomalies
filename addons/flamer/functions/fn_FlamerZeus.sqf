#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Zeus (ZEN) front-end for the Flamer.
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

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_FLAMER_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_FLAMER_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_FLAMER_%1", _idx];

private _pos = getPosATL _logic;
createMarker [_markerName, _pos];
deleteVehicle _logic;

[
    "Flamer Anomaly Settings",
    [
        ["SLIDER", ["Flamer Health", "Damage the Flamer takes before being killed."], [10, 5000, 400, 0]],
        ["TOOLBOX:YESNO", ["Override Minimum Territory", "If true, the minimum territory radius of 75m can be reduced."], false],
        ["SLIDER:RADIUS", ["Flamer Territory", "Radius in meters of the Flamer's territory."], [1, 1000, 75, 0, _pos, [7, 120, 32, 1]]],
        ["SLIDER:PERCENT", ["Flamer Damage", "Fraction of damage the Flamer does to its target."], [0.01, 1, 0.4, 2]],
        ["TOOLBOX:YESNO", ["AI Panic", "If true, AI flee from the Flamer during attacks."], false],
        ["SLIDER", ["Flamer Recharge Delay", "Seconds between Flamer actions. Lower is more aggressive."], [1, 60, 1, 0]],
        ["SLIDER:PERCENT", ["Flamer Damage on Death", "Fraction of damage the Flamer does to the surroundings when it dies."], [0.01, 1, 1, 2]],
        ["EDIT", ["Protective Gear (CSV)", "Gear classnames that reduce Flamer damage. Empty = none."], [""]],
        ["SLIDER:PERCENT", ["Protection", "Fraction of damage removed while wearing protective gear."], [0, 1, 0.5, 2]],
        ["EDIT", ["Immunity Gear (CSV)", "Gear classnames granting full immunity until durability is spent. Empty = none."], [""]],
        ["COMBO", ["Immunity Mode", "How immunity gear wears out."], [["Infinite", "Time", "Damage"], ["Infinite (never fails)", "Time (seconds)", "Damage (absorbed)"], 0]],
        ["SLIDER", ["Immunity Value", "Seconds (Time) or total damage (Damage) the gear lasts. 0 = never."], [0, 600, 0, 0]],
        ["SIDES", ["Hostile Sides", "Sides the Flamer attacks. None selected = all."], []],
        ["SLIDER:RADIUS", ["Activation Range (m)", "Players within this distance wake the Flamer."], [50, 3000, 1000, 0, _pos, [120, 120, 40, 1]]]
    ],
    {
        params ["_results", "_markerName"];
        _results params ["_health", "_override", "_territory", "_damage", "_aiPanic", "_recharge", "_deathDamage", "_protGear", "_protPct", "_immGear", "_immMode", "_immValue", "_sides", "_activation"];

        if (!_override && {_territory < 75}) then {_territory = 75};

        ["Flamer Anomaly configured and created!"] call zen_common_fnc_showMessage;
        private _config = createHashMapFromArray [["type", "flamer"], ["manageDamage", false], ["captureEnabled", true], ["captureTime", ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME], ["captureRadius", 15], ["hostileSides", _sides], ["activationRange", _activation], ["protGear", [_protGear] call EFUNC(main,parseClassList)], ["protPct", _protPct], ["immGear", [_immGear] call EFUNC(main,parseClassList)], ["immMode", _immMode], ["immValue", _immValue]];
        [_markerName, _territory, _damage, _recharge, round _health, _deathDamage, _aiPanic, _config] remoteExec [QFUNC(FlamerMain), 2];
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
        playSound "FD_Start_F";
    },
    _markerName
] call zen_dialog_fnc_create;
