#include "\z\root_anomalies\addons\twins\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Zeus (ZEN) front-end for the Twins.
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
    "Twins Anomaly Settings",
    [
        ["EDIT", ["Twins Object", "Classname of the object used as the Twins."], ["Land_HighVoltageTower_large_F"]],
        ["EDIT", ["Twins Heart", "Classname of the object used as the 'Heart' that must be destroyed to kill the Twins."], ["B_UAV_06_F"]],
        ["SLIDER:RADIUS", ["Tracking Distance", "Radius in meters within which the Twins tracks and chases entities."], [15, 1200, 100, 0, _pos, [7, 120, 32, 1]]],
        ["TOOLBOX:YESNO", ["Enable Electric Sparks", "If true, the Twins emits random electric sparks."], true],
        ["SLIDER:RADIUS", ["Damage Range", "Radius in meters within which the Twins damages and disorients entities."], [10, 1000, 75, 0, _pos, [7, 120, 32, 1]]],
        ["TOOLBOX:YESNO", ["Enable Effects on AI", "If true, AI entities are also affected."], true],
        ["TOOLBOX:YESNO", ["Enable EMP", "If true, the Twins emits an EMP when killed."], true],
        ["TOOLBOX:YESNO", ["Disable Sensitive Lights", "If true, the Twins' flashing/seizure visuals are disabled."], false]
    ],
    {
        params ["_results", "_pos"];
        _results params ["_twinsClass", "_heartClass", "_trackDist", "_sparks", "_dmgRange", "_affectAI", "_emp", "_seizureSafe"];

        if (getNumber (configFile >> "CfgVehicles" >> _heartClass >> "scope") <= 0) then {_heartClass = "B_UAV_06_F"};
        if (getNumber (configFile >> "CfgVehicles" >> _twinsClass >> "scope") <= 0) then {_twinsClass = "Land_HighVoltageTower_large_F"};
        if (_trackDist < _dmgRange) then {_trackDist = _dmgRange + 20};

        private _twins = _twinsClass createVehicle _pos;

        ["Twins Anomaly configured and created!"] call zen_common_fnc_showMessage;
        private _config = createHashMapFromArray [["type", "twins"], ["manageDamage", false], ["captureEnabled", true], ["captureTime", ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME], ["captureRadius", 15]];
        [_twins, _trackDist, _sparks, _dmgRange, _affectAI, _emp, _heartClass, _seizureSafe, _config] remoteExec [QFUNC(TwinsMain), 2];
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
        playSound "FD_Start_F";
    },
    _pos
] call zen_dialog_fnc_create;
