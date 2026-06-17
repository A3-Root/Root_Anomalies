#include "\z\root_anomalies\addons\farmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Farmer shockwave attack: flings nearby units/vehicles and damages them.
 *              Knockback always fires; health/hitpoint damage is gated by the targeting
 *              filter and allowDamage (effects yes, damage no for protected entities).
 *
 * Arguments:
 * 0: Farmer object <OBJECT>
 * 1: Damage fraction <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_farmer", "_damage"];

_farmer setUnitPos "UP";
[_farmer, _damage] remoteExec [QFUNC(FarmerShock), [0, -2] select isDedicated];
private _targets = ((ASLToAGL getPosATL _farmer) nearEntities [["CAManBase", "LandVehicle"], 20]) - [_farmer];

uiSleep 1.2;
{
    private _victim = _x;
    if (!(isPlayer _victim) && {_victim != _farmer}) then {
        private _jumpDir = (getPosATL _farmer vectorFromTo getPosATL _victim) vectorMultiply 3;
        private _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
        if ((typeOf _victim != "VirtualCurator_F") && {_victim isKindOf "CAManBase"}) then {
            _victim setVelocity [_jumpDir select 0, _jumpDir select 1, 9];
            [_victim, _damage, _bodyPart, "falling", _farmer] call EFUNC(main,applyDamage);
        };
    };
    if ((_victim isKindOf "LandVehicle") && {_victim != _farmer}) then {
        private _jumpDir = (getPosATL _farmer vectorFromTo getPosATL _victim) vectorMultiply 5;
        _victim setVelocity [_jumpDir select 0, _jumpDir select 1, 7];
        if ([_victim] call EFUNC(main,isAffectable) && {[_victim] call EFUNC(main,isDamageable)}) then {
            private _hitPoints = (getAllHitPointsDamage _victim) param [0, []];
            {
                private _dmg = random [0, _damage, 1];
                _victim setHitPointDamage [_x, (_victim getHitPointDamage _x) + _dmg];
            } forEach _hitPoints;
        };
    };
} forEach _targets;
