#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Sets an anomaly's incoming-damage multiplier. 0 = invulnerable, 1 = takes
 *              full damage. Low by default (tanky). Runtime-mutable.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Damage multiplier <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp, 0.5] call root_anomalies_fnc_setDamageMult;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]], ["_mult", ROOT_ANOMALIES_DEFAULT_DMGMULT, [0]]];

if (isNull _obj) exitWith {};
[_obj, "damageMult", (_mult max 0)] call API(setCfg);
