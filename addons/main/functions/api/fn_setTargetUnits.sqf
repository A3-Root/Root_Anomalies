#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Sets an explicit list of units the anomaly may hunt/affect. A unit in this
 *              list is affectable even if its side is not in the hostile-sides filter
 *              (explicit include overrides side). Empty list = no unit constraint.
 *              Honoured via root_anomalies_fnc_isAffectable. Excludes always win.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Units <ARRAY of OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp, [player1, player2]] call root_anomalies_fnc_setTargetUnits;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]], ["_units", [], [[]]]];

if (isNull _obj) exitWith {};
[_obj, "targetUnits", _units] call API(setCfg);
