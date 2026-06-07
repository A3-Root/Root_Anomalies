#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Returns whether a hit's ammo or projectile classname matches any class in a
 *              list (CfgAmmo isKindOf, or exact). Used by handleDamage for the killswitch,
 *              damage-type whitelist and blacklist checks.
 *
 * Arguments:
 * 0: Class list <ARRAY of STRING>
 * 1: Ammo classname <STRING> (default "")
 * 2: Projectile classname <STRING> (default "")
 *
 * Return Value:
 * A class matched <BOOL>
 *
 * Public: No
 */

params ["_list", ["_ammoCls", "", [""]], ["_projCls", "", [""]]];

private _hit = false;
{
    private _cls = _x;
    if (_ammoCls != "" && {_ammoCls isKindOf [_cls, configFile >> "CfgAmmo"]}) exitWith {_hit = true};
    if (_projCls != "" && {_projCls isKindOf [_cls, configFile >> "CfgAmmo"]}) exitWith {_hit = true};
} forEach _list;
_hit
