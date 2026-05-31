#include "\z\root_anomalies\addons\swarmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Zeus (ZEN) front-end for the Swarmer.
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
    "Swarmer Anomaly Settings",
    [
        ["EDIT", ["Swarmer Hive Object", "Classname of the object used to spawn the Swarmer."], ["Land_GarbageBags_F"]],
        ["TOOLBOX:YESNO", ["Override Minimum Territory", "If true, the minimum territory radius of 75m can be reduced."], false],
        ["SLIDER:RADIUS", ["Swarmer Territory", "Radius in meters of the Swarmer's territory."], [1, 1000, 75, 0, _pos, [7, 120, 32, 1]]],
        ["TOOLBOX:YESNO", ["Disable Pesticide", "If true, the Swarmer cannot be killed with pesticide."], false],
        ["EDIT", ["Pesticide", "Classname of the throwable (grenade/smoke) used to kill the Swarmer."], ["SmokeShellGreen"]],
        ["SLIDER:PERCENT", ["Swarmer Damage", "Fraction of damage the Swarmer does to its target."], [0.01, 1, 0.6, 2]]
    ],
    {
        params ["_results", "_pos"];
        _results params ["_hiveClass", "_override", "_territory", "_disablePesticide", "_pesticide", "_damage"];

        if (getNumber (configFile >> "CfgVehicles" >> _hiveClass >> "scope") <= 0) then {_hiveClass = "Land_GarbageBags_F"};
        if (getNumber (configFile >> "CfgVehicles" >> _pesticide >> "scope") <= 0) then {_pesticide = "SmokeShellGreen"};
        if (_disablePesticide) then {_pesticide = ""};
        if (!_override && {_territory < 75}) then {_territory = 75};

        private _hive = _hiveClass createVehicle _pos;

        ["Swarmer Anomaly configured and active!"] call zen_common_fnc_showMessage;
        [_hive, _territory, _pesticide, _damage] remoteExec ["root_anomalies_swarmer_fnc_SwarmerMain", 2];
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
        playSound "FD_Start_F";
    },
    _pos
] call zen_dialog_fnc_create;
