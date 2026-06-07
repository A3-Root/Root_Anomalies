#include "\z\root_anomalies\addons\screamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Applies hitpoint damage to a vehicle caught in the sonic blast. Skipped
 *              entirely when the vehicle is not affectable (targeting filter) or not
 *              damageable (allowDamage false) - the blast knockback still fires from the
 *              caller's per-band push.
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
{_vehicle setHitPointDamage [_x, 1]} forEach ["HitLight", "HitBatteries"];
if (_vehicle isKindOf "Air") then {
    [_vehicle, (_vehicle vectorModelToWorld [10, 10, 10])] remoteExec ["addTorque", _vehicle];
    [_vehicle, [25, -10, -10]] remoteExec ["setVelocity", _vehicle];
};
private _hitPoints = (getAllHitPointsDamage _vehicle) param [0, []];
private _curDmg = _dmg;
{
    [_vehicle, [_x, (_vehicle getHitPointDamage _x) + _curDmg]] remoteExec ["setHitPointDamage", _vehicle];
    _curDmg = random _curDmg;
} forEach _hitPoints;
_vehicle setDamage ((damage _vehicle) + _curDmg);
