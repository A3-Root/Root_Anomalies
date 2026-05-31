#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Sets the per-instance sedation throwable classnames. A smoke/throwable of
 *              any of these classes landing within the anomaly's radius opens a sedation
 *              window during which it can be captured. Per-instance, so different copies
 *              (or different anomaly types) can require different smokes.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Sedation classnames (ammo or magazine classes) <ARRAY of STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp, ["ROOT_SmokeShell_Sedative","SmokeShellBlue"]] call root_anomalies_fnc_setSedationClasses;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]], ["_classes", [], [[]]]];

if (isNull _obj) exitWith {};
[_obj, "sedationClassnames", _classes] call API(setCfg);
