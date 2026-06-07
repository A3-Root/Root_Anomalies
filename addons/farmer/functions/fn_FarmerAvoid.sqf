#include "\z\root_anomalies\addons\farmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Makes a nearby AI unit scatter away from the Farmer (panic behaviour).
 *
 * Arguments:
 * 0: Farmer object <OBJECT>
 * 1: Unit to scatter <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_farmer", "_chased"];

if (isPlayer _chased) exitWith {};
private _relPos = _chased getPos [25, round ((_farmer getDir _chased) + (random 33) * (selectRandom [1, -1]))];
_chased doMove _relPos;
_chased setSkill ["commanding", 1];
