#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Zeus (ZEN) front-end for the Smuggler.
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

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_SMUGGLER_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_SMUGGLER_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_SMUGGLER_%1", _idx];

private _pos = getPosATL _logic;
createMarker [_markerName, _pos];
deleteVehicle _logic;

[
    "Smuggler Anomaly Settings",
    [
        ["TOOLBOX:YESNO", ["Enable Roaming Smuggler", "If true, the Smuggler teleports to random positions over time."], false],
        ["TOOLBOX:YESNO", ["Enable Detection Device", "If true, the Smuggler is invisible unless a unit carries the detection device."], true],
        ["TOOLBOX:YESNO", ["Enable Teleport Protection", "If true, units carrying the protection device are not teleported."], true],
        ["TOOLBOX:YESNO", ["Disable Object Spawning", "If true, the Smuggler will not spawn random objects/entities."], false],
        ["EDIT", ["Detection Device", "Classname of the detection device."], ["MineDetector"]],
        ["EDIT", ["Protection Device", "Classname of the protection device."], ["B_Kitbag_mcamo"]],
        ["EDIT:MULTI", ["Spawn Objects Allowed", "Comma-separated classnames (no spaces) the Smuggler may spawn."], ["Land_OfficeCabinet_01_F,Land_ArmChair_01_F,B_G_Soldier_AR_F,C_man_1,O_Soldier_GL_F", {}, 4]],
        ["SLIDER", ["Spawn Objects Delay", "Additional delay in seconds between spawns (10s base always added)."], [0, 600, 10, 0]],
        ["SLIDER:PERCENT", ["Smuggler Damage", "Fraction of damage per teleport. 0 = no damage."], [0, 1, 0.1, 2]],
        ["TOOLBOX:YESNO", ["Disable Sensitive Lights", "If true, the bright screen effects during teleport are disabled."], false]
    ],
    {
        params ["_results", "_markerName"];
        _results params ["_roaming", "_detectable", "_protectable", "_disableSpawn", "_detector", "_protector", "_spawnStr", "_spawnDelay", "_damage", "_seizureSafe"];

        if (!_detectable) then {_detector = ""};
        if (!_protectable) then {_protector = ""};
        private _spawnList = if (_disableSpawn) then {[]} else {[_spawnStr] call EFUNC(main,parseClassList)};

        ["Smuggler Anomaly configured and created!"] call zen_common_fnc_showMessage;
        private _config = createHashMapFromArray [["type", "smuggler"], ["manageDamage", false], ["captureEnabled", true], ["captureTime", ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME], ["captureRadius", 15]];
        [_markerName, _roaming, _detector, _spawnList, _spawnDelay, _protector, _damage, _seizureSafe, _config] remoteExec [QFUNC(SmugglerMain), 2];
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
        playSound "FD_Start_F";
    },
    _markerName
] call zen_dialog_fnc_create;
