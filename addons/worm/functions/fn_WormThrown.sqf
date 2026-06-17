#include "\z\root_anomalies\addons\worm\script_component.hpp"
/*
 * Author: Root
 * Description: Client handler for a thrown projectile (vanilla "Fired" or ACE
 *              "ace_throwableThrown"). If it matches the worm's diffuser it triggers a
 *              kill; if it matches the configured forceful-target class it hijacks the
 *              worm's aim. Routing the actual projectile object makes this work for both
 *              vanilla and ACE throwing regardless of the magazine/ammo classname split.
 *
 * Arguments:
 * 0: Thrown projectile <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_proj", objNull, [objNull]]];

if (isNull _proj) exitWith {};

private _type = typeOf _proj;

private _diffuser = missionNamespace getVariable ["ROOT_ANOMALIES_WORM_DIFFUSER", ""];
if ((_diffuser != "") && {_type == _diffuser}) exitWith {
    [_proj, false] remoteExec [QFUNC(WormKill), 2];
};

private _force = missionNamespace getVariable ["ROOT_ANOMALIES_WORM_FORCETGT", ""];
if ((_force != "") && {_type == _force}) then {
    [_proj] remoteExec [QFUNC(WormForce), 2];
};
