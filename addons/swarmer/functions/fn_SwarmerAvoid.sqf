#include "\z\root_anomalies\addons\swarmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Makes a nearby AI unit scatter away from the Swarmer hive (panic behaviour).
 *
 * Arguments:
 * 0: Hive/agent object <OBJECT>
 * 1: Unit to scatter <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_hive", "_chased"];

if (isPlayer _chased) exitWith {};
private _fleePos = _chased getPos [50, (_hive getDir _chased) + (random 33) * (selectRandom [1, -1])];
_chased doMove _fleePos;
_chased setSkill ["commanding", 1];
