#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Flamer plasma attack: spits fire, burning people and damaging vehicles in
 *              range. People/vehicle health damage is gated (allowDamage + targeting);
 *              the plasma visual and proximity ignition always fire.
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

private _shootDir = (getPosATL _flamer vectorFromTo getPosATL _tgt) vectorMultiply 15;
[_flamer getVariable [QGVAR(cap), _flamer], ["foc_initial", 500]] remoteExec ["say3D"];
[_flamer, _shootDir] remoteExec [QFUNC(FlamerPlasma), [0, -2] select isDedicated];
uiSleep 0.5;
private _near = ((ASLToAGL getPosATL _flamer) nearEntities [["CAManBase", "LandVehicle", "Helicopter"], 20]) - [_flamer];
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
private _nearVik = nearestObjects [position _flamer, ["CAR", "TANK", "PLANE", "HELICOPTER", "Motorcycle", "Air"], 7, false];
{[_x, _dmg * 5] call EFUNC(main,applyDamage)} forEach (_nearVik - [_flamer]);
uiSleep 4;
_flamer setVariable [QGVAR(atk), false];
