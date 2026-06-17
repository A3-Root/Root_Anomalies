#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Flamer leap: launches toward the target, igniting vegetation and burning/
 *              damaging entities in the landing zone. Entity health damage is gated
 *              (allowDamage + targeting); the leap, sound and vegetation burn always fire.
 *
 * Arguments:
 * 0: Flamer object <OBJECT>
 * 1: Target <OBJECT>
 * 2: Damage fraction <NUMBER>
 * 3: Body parts <ARRAY of STRING>
 * 4: Body-part weights <ARRAY of NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_flamer", "_tgt", "_dmg", "_bodyParts", "_weights"];

private _jumpDir = (getPosATL _flamer vectorFromTo getPosATL _tgt) vectorMultiply round (10 + random 10);
private _blastSound = selectRandom ["01_blast", "02_blast", "03_blast"];
private _veg = nearestTerrainObjects [position _flamer, ["TREE", "SMALL TREE", "BUSH", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "FOREST"], 20, false];
private _nearVik = nearestObjects [position _flamer, ["CAR", "TANK", "PLANE", "HELICOPTER", "Motorcycle", "Air"], 20, false];
[_flamer getVariable [QGVAR(cap), _flamer], [_blastSound, 200]] remoteExec ["say3D"];
private _near = ((ASLToAGL getPosATL _flamer) nearEntities [["CAManBase", "LandVehicle"], 20]) - [_flamer];
{
    private _v = _x;
    if ((typeOf _v != "VirtualCurator_F") && {_v isKindOf "Man"}) then {
        private _gdmg = [_flamer, _v, _dmg] call FUNC(FlamerGear);
        if (_gdmg > 0) then {
            private _bp = _bodyParts selectRandomWeighted _weights;
            [_v, _gdmg, _bp, "burn"] call EFUNC(main,applyDamage);
            [_v, [selectRandom ["04", "burned", "02", "03"], 200]] remoteExec ["say3D"];
        };
    } else {
        if ((_v isKindOf "LandVehicle") || {_v isKindOf "Air"}) then {
            if ([_v] call EFUNC(main,isAffectable) && {[_v] call EFUNC(main,isDamageable)}) then {
                {_v setHitPointDamage [_x, (_v getHitPointDamage _x) + random _dmg]} forEach ((getAllHitPointsDamage _v) param [0, []]);
            };
        };
    };
} forEach _near;
_flamer setVelocity [_jumpDir select 0, _jumpDir select 1, round (10 + random 15)];
{_x setDamage [1, false]; _x hideObjectGlobal true} forEach _veg;
{[_x, _dmg] call EFUNC(main,applyDamage)} forEach (_nearVik - [_flamer]);
