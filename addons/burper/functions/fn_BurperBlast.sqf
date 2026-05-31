#include "\z\root_anomalies\addons\burper\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local screen/blur FX when the Burper is destroyed by its killswitch.
 *
 * Arguments:
 * 0: Anomaly object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_obj"];

if (player distance _obj < 300) then {
    cutText ["", "WHITE OUT", 1];
    uiSleep 0.1;
    titleCut ["", "WHITE IN", 1];
    "dynamicBlur" ppEffectEnable true;
    "dynamicBlur" ppEffectAdjust [40];
    "dynamicBlur" ppEffectCommit 0;
    "dynamicBlur" ppEffectAdjust [0.0];
    "dynamicBlur" ppEffectCommit 3;
    uiSleep 3;
    "dynamicBlur" ppEffectEnable false;
};
