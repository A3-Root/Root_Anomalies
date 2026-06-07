#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: One Smuggler teleport hop: plays distortion/sound FX then blinks the local
 *              player to a target position.
 *
 * Arguments:
 * 0: Unit being teleported <OBJECT>
 * 1: Destination position <ARRAY>
 * 2: Seizure-safe <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_unit", "_pos", "_seizureSafe"];

uiSleep 2;
waitUntil {isNil {player getVariable QGVAR(tele)}};
player setVariable [QGVAR(tele), true];
if !(_seizureSafe) then {[] spawn FUNC(SmugglerVidEffect)};
["zoomin"] remoteExec ["playSound", _unit];
[selectRandom ["halu_1", "halu_2", "halu_3", "halu_4", "halu_5", "halu_6", "halu_7", "halu_8", "halu_9", "halu_91", "halu_92", "halu_93", "halu_94", "halu_95", "halu_96", "halu_97", "halu_98", "halu_99", "halu_991", "halu_992", "halu_993", "halu_994", "halu_995", "halu_996", "halu_997", "halu_998", "halu_999", "halu_9999"]] remoteExec ["playSound", _unit];
uiSleep 0.5;
_unit setPos [_pos select 0, _pos select 1, 2];
uiSleep (3 + random 6);
player setVariable [QGVAR(tele), nil];
