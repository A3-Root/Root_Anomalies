#include "\z\root_anomalies\addons\twins\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local spin animation of the Twins' heart object.
 *
 * Arguments:
 * 0: Heart object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_heart"];

private _dir = 0;
while {alive _heart} do {
    if (_dir == 360) then {_dir = 0};
    _heart setDir _dir;
    _dir = _dir + 1;
    uiSleep 0.1;
};
