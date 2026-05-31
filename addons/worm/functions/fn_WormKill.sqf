#include "\z\root_anomalies\addons\worm\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server handler that kills Worms when the diffuser lands nearby (or
 *              immediately when force-killed).
 *
 * Arguments:
 * 0: Diffuser projectile <OBJECT>
 * 1: Force-kill all worms <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params ["_diffuser", ["_forceKill", false, [false]]];

private _killWorms = {
    params ["_candidates"];
    {
        if (!isNil {_x getVariable QGVAR(isWorm)}) then {uiSleep 4; deleteVehicle _x};
        if (typeOf _x == "land_CanOpener_F") then {deleteVehicle _x};
    } forEach _candidates;
};

if (_forceKill) then {
    [8 allObjects 1] call _killWorms;
} else {
    while {alive _diffuser} do {
        private _near = nearestObjects [position _diffuser, [], 15];
        if (_near isNotEqualTo []) then {[_near] call _killWorms};
        uiSleep 2;
    };
};
