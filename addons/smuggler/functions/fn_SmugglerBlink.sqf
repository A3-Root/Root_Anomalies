#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Briefly flickers a unit/vehicle in and out of view (Smuggler teleport tell).
 *
 * Arguments:
 * 0: Object to flicker <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_unit"];

for "_i" from 1 to 3 do {
    _unit hideObjectGlobal true;
    uiSleep 0.2;
    _unit hideObjectGlobal false;
    uiSleep 0.2;
};
