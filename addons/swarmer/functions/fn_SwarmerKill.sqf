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

if (_forceKill) then {
    [8 allObjects 1] call FUNC(SwarmerKillNearby);
    uiSleep 2;
} else {
    while {alive _gren} do {
        private _near = (position _gren) nearEntities ["CAManBase", 15];
        if (_near isNotEqualTo []) then {[_near] call FUNC(SwarmerKillNearby)};
        uiSleep 2;
    };
};

if (!isNull _gren) then {
    {deleteVehicle _x; uiSleep 1} forEach (nearestObjects [_gren, ["BloodPool_01_Large_New_F", "BloodSplatter_01_Large_New_F"], 150]);
};
