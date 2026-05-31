#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Client-side player teleport sequence: blinks the player to 1-5 random
 *              safe positions with sound/screen FX, then applies damage and a scream.
 *
 * Arguments:
 * 0: Unit being teleported <OBJECT>
 * 1: Anomaly object <OBJECT>
 * 2: Seizure-safe <BOOL>
 * 3: Teleport damage fraction <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_unit", "_obj", ["_noseize", false, [false]], ["_damage", 0.1, [0]]];

private _hop = {
    params ["_unit", "_pos", "_noseize"];
    uiSleep 2;
    waitUntil {isNil {player getVariable QGVAR(tele)}};
    player setVariable [QGVAR(tele), true];
    if !(_noseize) then {[] spawn Root_fnc_SmugglerVidEffect};
    ["zoomin"] remoteExec ["playSound", _unit];
    [selectRandom ["halu_1", "halu_2", "halu_3", "halu_4", "halu_5", "halu_6", "halu_7", "halu_8", "halu_9", "halu_91", "halu_92", "halu_93", "halu_94", "halu_95", "halu_96", "halu_97", "halu_98", "halu_99", "halu_991", "halu_992", "halu_993", "halu_994", "halu_995", "halu_996", "halu_997", "halu_998", "halu_999", "halu_9999"]] remoteExec ["playSound", _unit];
    uiSleep 0.5;
    _unit setPos [_pos select 0, _pos select 1, 2];
    uiSleep (3 + random 6);
    player setVariable [QGVAR(tele), nil];
};

uiSleep 2;

if (_unit != player) exitWith {};
if (typeOf _unit == "VirtualCurator_F") exitWith {};

private _count = floor (random 6);
if (_count < 1) then {_count = 1};

for "_i" from 1 to _count do {
    [_unit, ([getPos _obj, 300, -1, 5, 0, -1, 0] call BIS_fnc_findSafePos), _noseize] call _hop;
};

uiSleep 0.3;
[_unit, _damage, "body", selectRandom ["backblast", "bullet", "explosive", "grenade"]] call Root_fnc_applyDamage;

waitUntil {isNil {player getVariable QGVAR(tele)}};
[_unit, [selectRandom ["strigat_1", "strigat_2", "strigat_3", "strigat_4", "strigat_5", "strigat_6", "strigat_7", "strigat_8", "strigat_9", "strigat_91", "strigat_92"], 300]] remoteExec ["say3D"];
