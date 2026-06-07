#include "\z\root_anomalies\addons\worm\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Applies hitpoint damage to a vehicle caught by the worm. Skipped entirely
 *              when the vehicle is not affectable (targeting filter) or not damageable
 *              (allowDamage false) - the knockback FX still fire from the caller.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Damage fraction <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_vehicle", "_dmg"];

if !([_vehicle] call EFUNC(main,isAffectable) && {[_vehicle] call EFUNC(main,isDamageable)}) exitWith {};
{_vehicle setHitPointDamage [_x, (_vehicle getHitPointDamage _x) + random _dmg]} forEach ((getAllHitPointsDamage _vehicle) param [0, []]);
{_vehicle setHitPointDamage [_x, 1]} forEach ["HitLight", "HitBatteries"];
