#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Resolves a throwable classname typed by a mission maker into the ammo
 *              class of the projectile that actually lands in the world. Accepts either a
 *              CfgMagazines class (e.g. "SmokeShellRed", mapped to its ammo) or a CfgAmmo
 *              class (kept as is). Smoke grenades live in CfgAmmo/CfgMagazines, never in
 *              CfgVehicles, so checking CfgVehicles rejects every valid smoke.
 *
 * Arguments:
 * 0: Classname <STRING>
 *
 * Return Value:
 * Ammo classname, "" when unknown <STRING>
 *
 * Example:
 * ["SmokeShellRed"] call root_anomalies_main_fnc_resolveThrowable; // "SmokeShellRed"
 *
 * Public: No
 */

params [["_class", "", [""]]];

if (_class isEqualTo "") exitWith {""};

if (isClass (configFile >> "CfgAmmo" >> _class)) exitWith {configName (configFile >> "CfgAmmo" >> _class)};

private _mag = configFile >> "CfgMagazines" >> _class;
if (isClass _mag) exitWith {
    private _ammo = getText (_mag >> "ammo");
    [_ammo, ""] select (_ammo isEqualTo "" || {!isClass (configFile >> "CfgAmmo" >> _ammo)})
};

LOG_DEBUG_1("resolveThrowable: %1 is neither a magazine nor an ammo class",_class);
""
