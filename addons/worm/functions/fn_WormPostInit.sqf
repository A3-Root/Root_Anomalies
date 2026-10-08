#include "\z\root_anomalies\addons\worm\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Post-init on every machine: reports thrown diffusers and diversion
 *              devices to the server, whoever throws them (players, AI, headless clients,
 *              vanilla or ACE advanced throwing).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Public: No
 */

// Runs on every machine (server, headless clients, players): whoever owns the
// thrower reports the throw.
[] spawn {
    waitUntil {uiSleep 1; !isNil {missionNamespace getVariable "ROOT_ANOMALIES_WORM_DIFFUSER"}};
    // Class EH covers respawned players, AI and headless clients alike; only the
    // machine that owns the thrower reports, so the server hears it once.
    ["CAManBase", "Fired", {
        params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
        if (local _unit) then {[_projectile] call FUNC(WormThrown)};
    }, true, [], true] call CBA_fnc_addClassEventHandler;

    // ACE advanced throwing bypasses the "Fired" EH; it fires this CBA event instead.
    // Always safe to add - the event simply never fires when ACE is absent.
    ["ace_throwableThrown", {
        params ["_unit", "_throwable"];
        [_throwable] call FUNC(WormThrown);
    }] call CBA_fnc_addEventHandler;
};
