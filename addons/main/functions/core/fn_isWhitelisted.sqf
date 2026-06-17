#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Per-unit anomaly opt-out. A unit (AI or player) is ignored by an anomaly
 *              when it carries either the global whitelist variable or the per-type one,
 *              letting mission makers wave specific units safely through any/one anomaly.
 *
 * Variables checked on the unit:
 * - ROOT_ANOMALIES_WHITELIST            (true = ignored by ALL anomalies)
 * - ROOT_ANOMALIES_<TYPE>_WHITELIST     (true = ignored by that anomaly type, e.g. FARMER)
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Anomaly type id, e.g. "farmer" <STRING>
 *
 * Return Value:
 * Whitelisted (ignored) <BOOL>
 *
 * Example:
 * [_unit, "farmer"] call root_anomalies_main_fnc_isWhitelisted;
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]], ["_type", "", [""]]];

if (isNull _unit) exitWith {false};
if (_unit getVariable ["ROOT_ANOMALIES_WHITELIST", false]) exitWith {true};
if (_type isEqualTo "") exitWith {false};

_unit getVariable [format ["ROOT_ANOMALIES_%1_WHITELIST", toUpper _type], false]
