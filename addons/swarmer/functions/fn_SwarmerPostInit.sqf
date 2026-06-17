#include "\z\root_anomalies\addons\swarmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Client post-init: watches the player's fired projectiles and triggers
 *              the Swarmer kill when the configured pesticide is thrown.
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
    waitUntil {uiSleep 1; !isNil {missionNamespace getVariable "ROOT_ANOMALIES_SWARMER_PESTICIDE"}};
    player addEventHandler ["Fired", {
        params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
        private _pesticide = missionNamespace getVariable ["ROOT_ANOMALIES_SWARMER_PESTICIDE", ""];
        if ((_pesticide != "") && {typeOf _projectile == _pesticide}) then {
            [_projectile, false] remoteExec [QFUNC(SwarmerKill), 2];
        };
    }];

    // ACE advanced throwing bypasses the "Fired" EH; it fires this CBA event instead.
    // The handler simply never triggers when ACE is absent, so it is always safe to add.
    ["ace_throwableThrown", {
        params ["_unit", "_throwable"];
        private _pesticide = missionNamespace getVariable ["ROOT_ANOMALIES_SWARMER_PESTICIDE", ""];
        if ((_pesticide != "") && {typeOf _throwable == _pesticide}) then {
            [_throwable, false] remoteExec [QFUNC(SwarmerKill), 2];
        };
    }] call CBA_fnc_addEventHandler;
};
