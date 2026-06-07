#include "\z\root_anomalies\addons\steamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Damages a vehicle caught in a geyser burst. Skipped entirely when the
 *              vehicle is not affectable (targeting filter) or not damageable
 *              (allowDamage false) - the burst FX and ragdoll still fire from the caller.
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
_vehicle setVelocity [25, 25, 25];
{_vehicle setHitPointDamage [_x, (_vehicle getHitPointDamage _x) + random _dmg]} forEach ((getAllHitPointsDamage _vehicle) param [0, []]);
{_vehicle setHitPointDamage [_x, 1]} forEach ["HitLight", "HitBatteries"];
