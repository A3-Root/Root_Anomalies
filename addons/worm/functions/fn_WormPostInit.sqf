#include "\z\root_anomalies\addons\worm\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Client post-init: triggers the Worm kill when the configured diffuser
 *              is thrown by the player.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

[] spawn {
    waitUntil {uiSleep 1; !isNil {missionNamespace getVariable "ROOT_ANOMALIES_WORM_DIFFUSER"}};
    player addEventHandler ["Fired", {
        params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
        [_projectile] call FUNC(WormThrown);
    }];

    // ACE advanced throwing bypasses the "Fired" EH; it fires this CBA event instead.
    // Always safe to add - the event simply never fires when ACE is absent.
    ["ace_throwableThrown", {
        params ["_unit", "_throwable"];
        [_throwable] call FUNC(WormThrown);
    }] call CBA_fnc_addEventHandler;
};
