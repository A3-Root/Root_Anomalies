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
        private _diffuser = missionNamespace getVariable ["ROOT_ANOMALIES_WORM_DIFFUSER", ""];
        if ((_diffuser != "") && {typeOf _projectile == _diffuser}) then {
            [_projectile, false] remoteExec [QFUNC(WormKill), 2];
        };
    }];
};
