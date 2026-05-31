#include "\z\root_anomalies\addons\steamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local looping idle voice for the (invisible) Steamer.
 *
 * Arguments:
 * 0: Steamer object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_steamer"];

while {alive _steamer} do {
    _steamer say3D ["boil_mic", 300];
    _steamer say3D [selectRandom ["steamer_01", "steamer_02"], 100];
    uiSleep 10;
};
