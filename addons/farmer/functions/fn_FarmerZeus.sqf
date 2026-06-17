#include "\z\root_anomalies\addons\farmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Zeus (ZEN) front-end for the Farmer. Opens a configuration dialog and
 *              hands off to root_anomalies_farmer_fnc_FarmerMain on the server.
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
        ["SLIDER", ["Farmer Recharge Delay", "Seconds between Farmer attacks."], [3, 60, 5, 0]],
        ["EDIT", ["Protective Gear (CSV)", "Gear classnames that reduce the Farmer's damage. Empty = none."], [""]],
        ["SLIDER:PERCENT", ["Protection", "Fraction of damage removed while wearing protective gear."], [0, 1, 0.5, 2]],
        ["EDIT", ["Immunity Gear (CSV)", "Gear classnames granting full immunity until durability is spent. Empty = none."], [""]],
        ["COMBO", ["Immunity Mode", "How immunity gear wears out."], [["Infinite", "Time", "Damage"], ["Infinite (never fails)", "Time (seconds)", "Damage (absorbed)"], 0]],
        ["SLIDER", ["Immunity Value", "Seconds (Time) or total damage (Damage) the gear lasts. 0 = never."], [0, 600, 0, 0]],
        ["SIDES", ["Hostile Sides", "Sides the Farmer attacks. None selected = all."], []],
        ["SLIDER:RADIUS", ["Activation Range (m)", "Players within this distance wake the Farmer."], [50, 3000, 1000, 0, _pos, [120, 120, 40, 1]]]
    ],
    {
        params ["_results", "_markerName"];
        _results params ["_health", "_override", "_territory", "_aiPanic", "_damage", "_recharge", "_protGear", "_protPct", "_immGear", "_immMode", "_immValue", "_sides", "_activation"];

        if (!_override && {_territory < 75}) then {_territory = 75};

        ["Farmer Anomaly configured and created!"] call zen_common_fnc_showMessage;
        private _config = createHashMapFromArray [["type", "farmer"], ["manageDamage", false], ["captureEnabled", true], ["captureTime", ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME], ["captureRadius", 15], ["hostileSides", _sides], ["activationRange", _activation], ["protGear", [_protGear] call EFUNC(main,parseClassList)], ["protPct", _protPct], ["immGear", [_immGear] call EFUNC(main,parseClassList)], ["immMode", _immMode], ["immValue", _immValue]];
        [_markerName, _territory, _damage, _recharge, round _health, _aiPanic, _config] remoteExec [QFUNC(FarmerMain), 2];
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
        playSound "FD_Start_F";
    },
    _markerName
] call zen_dialog_fnc_create;
