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

if (_forceKill) then {
    [8 allObjects 1] call FUNC(WormKillNearby);
} else {
    while {alive _diffuser} do {
        private _near = nearestObjects [position _diffuser, [], 15];
        if (_near isNotEqualTo []) then {[_near] call FUNC(WormKillNearby)};
        uiSleep 2;
    };
};
