#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Burns everything within 20m of the Flamer: ACE-aware burn damage for people
 *              (via applyDamage), hitpoint damage for vehicles. Vehicle damage is gated by
 *              the targeting filter and allowDamage; people damage by applyDamage's own gate.
 *
 * Arguments:
 * 0: Flamer object <OBJECT>
 * 1: Damage fraction <NUMBER>
 * 2: Body parts <ARRAY of STRING>
 * 3: Body-part weights <ARRAY of NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_flamer", "_dmg", "_bodyParts", "_weights"];

private _near = ((ASLToAGL getPosATL _flamer) nearEntities [["CAManBase", "LandVehicle", "Helicopter"], 20]) - [_flamer];
{
    private _v = _x;
    if ((typeOf _v != "VirtualCurator_F") && {_v isKindOf "Man"}) then {
        private _bp = _bodyParts selectRandomWeighted _weights;
        [_v, _dmg, _bp, "burn"] call EFUNC(main,applyDamage);
        [_v, [selectRandom ["04", "burned", "02", "03"], 200]] remoteExec ["say3D"];
    } else {
        if ((_v isKindOf "LandVehicle") || {_v isKindOf "Air"}) then {
            if ([_v] call EFUNC(main,isAffectable) && {[_v] call EFUNC(main,isDamageable)}) then {
                {_v setHitPointDamage [_x, (_v getHitPointDamage _x) + random 0.3]} forEach ((getAllHitPointsDamage _v) param [0, []]);
            };
        };
    };
} forEach _near;
