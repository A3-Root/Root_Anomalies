#include "\z\root_anomalies\addons\swarmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Post-init on every machine: triggers the Swarmer kill when the configured
 *              pesticide is thrown, whoever throws it (players, AI, headless clients,
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
    waitUntil {uiSleep 1; !isNil {missionNamespace getVariable "ROOT_ANOMALIES_SWARMER_PESTICIDE"}};
    // Class EH covers respawned players, AI and headless clients alike; only the
    // machine that owns the thrower reports, so the server hears it once.
    ["CAManBase", "Fired", {
        params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
        private _pesticide = missionNamespace getVariable ["ROOT_ANOMALIES_SWARMER_PESTICIDE", ""];
        if (local _unit && _pesticide != "" && {typeOf _projectile == _pesticide}) then {
            [_projectile, false] remoteExec [QFUNC(SwarmerKill), 2];
        };
    }, true, [], true] call CBA_fnc_addClassEventHandler;

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
