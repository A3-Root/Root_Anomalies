#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Sets the per-instance "killswitch" classnames. When an item/magazine/
 *              ammo of any of these classes is used on or detonated near the anomaly,
 *              it is instantly killed/disabled. Per-instance, so copies of the same type
 *              can have different killswitches.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Killswitch classnames <ARRAY of STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp, ["DemoCharge_Remote_Ammo","ATMine_Range_Ammo"]] call root_anomalies_fnc_setKillswitch;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]], ["_classes", [], [[]]]];

if (isNull _obj) exitWith {};
[_obj, "killClassnames", _classes] call API(setCfg);
