#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Drains the local player's stamina while near the Strigoi.
 *
 * Arguments:
 * 0: Strigoi object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_strigoi"];

while {alive _strigoi} do {
    waitUntil {uiSleep 5; player distance _strigoi < 200};
    player setFatigue ((getFatigue player) + 0.2);
    uiSleep 0.5;
};
