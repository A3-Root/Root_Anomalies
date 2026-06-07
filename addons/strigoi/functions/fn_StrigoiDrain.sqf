#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Drains stamina from nearby units (raises their fatigue each tick).
 *
 * Arguments:
 * 0: Units to drain <ARRAY of OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_units"];

{_x setFatigue ((getFatigue _x) + 0.1)} forEach _units;
