#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Makes a nearby AI unit scatter away from the Flamer (panic behaviour).
 *
 * Arguments:
 * 0: Flamer object <OBJECT>
 * 1: Unit to scatter <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_flamer", "_chased"];

if (isPlayer _chased) exitWith {};
private _rel = _chased getPos [30, (_flamer getDir _chased) + (random 33) * (selectRandom [1, -1])];
_chased doMove _rel;
_chased setSkill ["commanding", 1];
