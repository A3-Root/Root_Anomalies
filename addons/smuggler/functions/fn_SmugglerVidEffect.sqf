#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local screen distortion effect during a Smuggler teleport.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

enableCamShake true;
addCamShake [3 + random 7, 3, 13 + random 33];
playSound "puls";

if (SEIZURE_SAFE) exitWith {};

cutText ["", "WHITE OUT", 1];
titleCut ["", "WHITE IN", 1];

switch (selectRandom ["blur", "colorinv", "chrom", "colorcor"]) do {
    case "blur": {
        "dynamicBlur" ppEffectEnable true;
        "dynamicBlur" ppEffectAdjust [40];
        "dynamicBlur" ppEffectCommit 0;
        "dynamicBlur" ppEffectAdjust [0.0];
        "dynamicBlur" ppEffectCommit 3;
        uiSleep 3;
        "dynamicBlur" ppEffectEnable false;
    };
    case "colorinv": {["ColorInversion", 2500, [0, 1, 0]] spawn FUNC(SmugglerPpRun)};
    case "chrom": {["ChromAberration", 200, [0.93, 0.86, true]] spawn FUNC(SmugglerPpRun)};
    default {["ColorCorrections", 1500, [1, 1, 0, [0, 0, 0, 0], [1.8, 1.8, 0.3, -5], [0.2, 0.59, 0.11, -1.83]]] spawn FUNC(SmugglerPpRun)};
};
