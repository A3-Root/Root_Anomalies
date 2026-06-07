#include "\z\root_anomalies\addons\steamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Makes a nearby AI unit scatter away from the Steamer (panic behaviour).
 *
 * Arguments:
 * 0: Unit to scatter <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_chased"];

if (isPlayer _chased) exitWith {};
private _fleePos = _chased getPos [10 + round (random 30), round (random 360)];
_chased doMove _fleePos;
_chased setSkill ["commanding", 1];
