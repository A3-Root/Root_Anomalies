#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server loop that teleports unprotected units and vehicles that linger
 *              near the Smuggler.
 *
 * Arguments:
 * 0: Anomaly object <OBJECT>
 * 1: Core object <OBJECT>
 * 2: Teleport damage fraction <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params ["_obj", "_core", ["_damage", 0.1, [0]]];

while {alive _obj && {!(_obj getVariable [QGVAR(terminate), false])}} do {
    private _protector = _obj getVariable [QGVAR(protector), ""];
    private _cfg = _obj getVariable [QGVAR(config), createHashMap];
    private _damageLive = _cfg getOrDefault ["damage", _damage];
    private _tpRange = _cfg getOrDefault ["tpRange", 300];

    {
        private _unit = _x;
        if (!([_unit, _protector] call FUNC(SmugglerProtected)) && {isNil {_unit getVariable QGVAR(teleportedIn)}} && {[_unit, _obj] call EFUNC(main,isAffectable)}) then {
            [_obj, ["tele_message", 100]] remoteExec ["say3D"];
            [_unit] call FUNC(SmugglerBlink);
            if (isPlayer _unit) then {
                [_unit, _obj, _damageLive] remoteExec [QFUNC(SmugglerTeleEffect), _unit];
            } else {
                _unit setPos ([getPos _obj, _tpRange, -1, 5, 0, 0.5, 0] call BIS_fnc_findSafePos);
                [_unit, _damageLive, "body", "stab"] call EFUNC(main,applyDamage);
            };
        };
    } forEach ((position _obj) nearEntities ["CAManBase", 15]);

    {
        private _veh = _x;
        if ((isNil {_veh getVariable QGVAR(teleportedIn)}) && {[_veh, _obj] call EFUNC(main,isAffectable)}) then {
            [_obj, ["tele_message", 100]] remoteExec ["say3D"];
            [_veh] call FUNC(SmugglerBlink);
            _veh setPos ([getPos _obj, _tpRange, -1, 5, 0, 0.5, 0] call BIS_fnc_findSafePos);
            [_veh, _damageLive] call EFUNC(main,applyDamage);
        };
    } forEach ((position _obj) nearEntities ["LandVehicle", 15]);

    uiSleep 2;
};
