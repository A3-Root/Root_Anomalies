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
 * 3: Seizure-safe <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params ["_obj", "_core", ["_damage", 0.1, [0]], ["_noseize", false, [false]]];

private _blink = {
    params ["_unit"];
    for "_i" from 1 to 3 do {
        _unit hideObjectGlobal true;
        uiSleep 0.2;
        _unit hideObjectGlobal false;
        uiSleep 0.2;
    };
};

private _isProtected = {
    params ["_unit", "_protector"];
    if (_protector == "") exitWith {false};
    (headgear _unit == _protector) || {goggles _unit == _protector} || {uniform _unit == _protector} || {vest _unit == _protector} || {backpack _unit == _protector} || {_protector in (assignedItems _unit + items _unit)}
};

while {alive _obj} do {
    private _protector = _obj getVariable [QGVAR(protector), ""];

    {
        private _unit = _x;
        if (!([_unit, _protector] call _isProtected) && {isNil {_unit getVariable QGVAR(teleportedIn)}}) then {
            [_obj, ["tele_message", 100]] remoteExec ["say3D"];
            [_unit] call _blink;
            if (isPlayer _unit) then {
                [_unit, _obj, _noseize, _damage] remoteExec ["root_anomalies_smuggler_fnc_SmugglerTeleEffect", _unit];
            } else {
                _unit setPos ([getPos _obj, 300, -1, 5, 0, 0.5, 0] call BIS_fnc_findSafePos);
                [_unit, _damage, "body", "stab"] call root_anomalies_main_fnc_applyDamage;
            };
        };
    } forEach ((position _obj) nearEntities ["CAManBase", 15]);

    {
        private _veh = _x;
        if (isNil {_veh getVariable QGVAR(teleportedIn)}) then {
            [_obj, ["tele_message", 100]] remoteExec ["say3D"];
            [_veh] call _blink;
            _veh setPos ([getPos _obj, 300, -1, 5, 0, 0.5, 0] call BIS_fnc_findSafePos);
            if ([_veh] call root_anomalies_main_fnc_isAffectable) then {_veh setDamage ((damage _veh) + _damage)};
        };
    } forEach ((position _obj) nearEntities ["LandVehicle", 15]);

    uiSleep 2;
};
