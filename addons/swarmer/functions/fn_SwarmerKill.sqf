#include "\z\root_anomalies\addons\swarmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server handler that kills Swarmer hives when pesticide lands nearby
 *              (or immediately when force-killed).
 *
 * Arguments:
 * 0: Pesticide projectile <OBJECT>
 * 1: Force-kill all hives <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params ["_gren", ["_forceKill", false, [false]]];

private _killHives = {
    params ["_candidates"];
    {
        if (!isNil {_x getVariable QGVAR(isHive)}) then {
            uiSleep 5;
            _x setDamage 1;
            [_x] remoteExec ["root_anomalies_swarmer_fnc_SwarmerDead", [0, -2] select isDedicated];
        };
    } forEach _candidates;
};

if (_forceKill) then {
    [8 allObjects 1] call _killHives;
    uiSleep 2;
} else {
    while {alive _gren} do {
        private _near = (position _gren) nearEntities ["CAManBase", 15];
        if (_near isNotEqualTo []) then {[_near] call _killHives};
        uiSleep 2;
    };
};

if (!isNull _gren) then {
    {deleteVehicle _x; uiSleep 1} forEach (nearestObjects [_gren, ["BloodPool_01_Large_New_F", "BloodSplatter_01_Large_New_F"], 150]);
};
