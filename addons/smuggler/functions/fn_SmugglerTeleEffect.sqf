#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Client-side player teleport sequence: blinks the player to 1-5 random
 *              safe positions with sound/screen FX, then applies damage and a scream.
 *
 * Arguments:
 * 0: Unit being teleported <OBJECT>
 * 1: Anomaly object <OBJECT>
 * 2: Teleport damage fraction <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_unit", "_obj", ["_damage", 0.1, [0]]];

uiSleep 2;

if (_unit != player) exitWith {};
if (typeOf _unit == "VirtualCurator_F") exitWith {};

private _tpRange = (_obj getVariable [QGVAR(config), createHashMap]) getOrDefault ["tpRange", 300];
private _count = floor (random 6);
if (_count < 1) then {_count = 1};

for "_i" from 1 to _count do {
    [_unit, ([getPos _obj, _tpRange, -1, 5, 0, -1, 0] call BIS_fnc_findSafePos)] call FUNC(SmugglerHop);
};

uiSleep 0.3;
[_unit, _damage, "body", selectRandom ["backblast", "bullet", "explosive", "grenade"]] call EFUNC(main,applyDamage);

waitUntil {isNil {player getVariable QGVAR(tele)}};
[_unit, [selectRandom ["strigat_1", "strigat_2", "strigat_3", "strigat_4", "strigat_5", "strigat_6", "strigat_7", "strigat_8", "strigat_9", "strigat_91", "strigat_92"], 300]] remoteExec ["say3D"];
