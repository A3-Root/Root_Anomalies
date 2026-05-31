#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Returns all live anomaly instances, optionally filtered by type. Dead /
 *              deleted instances are pruned. Server-authoritative.
 *
 * Arguments:
 * 0: Type id filter, e.g. "scp173" ("" = all) <STRING> (optional)
 *
 * Return Value:
 * Array of anomaly objects <ARRAY>
 *
 * Example:
 * ["scp173"] call root_anomalies_fnc_getInstances;
 *
 * Public: Yes
 */

params [["_type", "", [""]]];

private _all = (GVAR(instances) select { !isNull _x }) select { alive _x };
GVAR(instances) = _all;

if (_type isEqualTo "") exitWith { _all };

private _key = toLower _type;
_all select { (_x getVariable [QGVAR(config), createHashMap]) getOrDefault ["type", ""] == _key }
