#include "\z\root_anomalies\addons\screamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Zeus (ZEN) front-end for the Screamer.
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

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_SCREAMER_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_SCREAMER_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_SCREAMER_%1", _idx];

private _pos = getPosATL _logic;
createMarker [_markerName, _pos];
deleteVehicle _logic;

[
    "Screamer Anomaly Settings",
    [
        ["SIDES", ["Screamer Side", "Side the Screamer spawns as (first selected). Defaults to civilian. Only used with AI Engage."], []],
        ["SIDES", ["Screamer Targets", "Side(s) the Screamer treats as hostile. None selected = attacks everyone."], []],
        ["EDIT", ["Screamer Model", "Classname of the object used as the anomaly."], ["Land_AncientStatue_01_F"]],
        ["SLIDER", ["Screamer Health", "Damage the Screamer takes before being killed."], [10, 5000, 400, 0]],
        ["SLIDER:RADIUS", ["Screamer Territory", "Radius in meters of the Screamer's territory."], [20, 500, 100, 0, _pos, [7, 120, 32, 1]]],
        ["SLIDER:RADIUS", ["Screamer Effect Distance", "Distance in meters of the Screamer's attack. Auto-clamped to half the territory."], [10, 490, 50, 0, _pos, [7, 120, 32, 1]]],
        ["TOOLBOX:YESNO", ["Affect Vehicles", "If true, vehicles in the scream path are affected."], true],
        ["TOOLBOX:YESNO", ["AI Engages [Experimental]", "If true, AI will engage the Screamer (a visible VR soldier is added for static models)."], false],
        ["TOOLBOX:YESNO", ["AI Panic", "If true, AI flee from the Screamer during attacks."], false],
        ["SLIDER:PERCENT", ["Screamer Damage (Close)", "Fraction of damage at close range."], [0.01, 1, 0.8, 2]],
        ["SLIDER:PERCENT", ["Screamer Damage (Medium)", "Fraction of damage at mid range."], [0.01, 1, 0.4, 2]],
        ["SLIDER:PERCENT", ["Screamer Damage (Far)", "Fraction of damage at far range."], [0.01, 1, 0.2, 2]],
        ["SLIDER:RADIUS", ["Activation Range (m)", "Players within this distance wake the Screamer."], [50, 3000, 1000, 0, _pos, [120, 120, 40, 1]]]
    ],
    {
        params ["_results", "_markerName"];
        _results params ["_spawnSide", "_hostiles", "_model", "_health", "_territory", "_atkRadius", "_affectVehicles", "_aiEngage", "_aiPanic", "_dmgClose", "_dmgMedium", "_dmgFar", "_activation"];

        if (_hostiles isEqualTo []) then {_hostiles = [east, west, civilian, resistance]};
        if (_aiEngage) then {
            _spawnSide = if (_spawnSide isEqualTo []) then {east} else {_spawnSide select 0};
        } else {
            _spawnSide = civilian;
        };
        if (_atkRadius > (_territory / 2)) then {_atkRadius = _territory / 2};
        if (_territory < (_atkRadius * 2)) then {_territory = _atkRadius * 2};

        ["Screamer Anomaly configured and active!"] call zen_common_fnc_showMessage;
        private _config = createHashMapFromArray [["type", "screamer"], ["manageDamage", false], ["captureEnabled", true], ["captureTime", ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME], ["captureRadius", 15], ["activationRange", _activation]];
        [_markerName, _model, _dmgClose, _dmgMedium, _dmgFar, _territory, _hostiles, _atkRadius, _affectVehicles, _aiEngage, _aiPanic, _spawnSide, _health, _config] remoteExec [QFUNC(ScreamerMain), 2];
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
        playSound "FD_Start_F";
    },
    _markerName
] call zen_dialog_fnc_create;
