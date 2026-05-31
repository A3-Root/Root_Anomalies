#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Parses a comma-separated classname string into a clean array.
 *              Trims whitespace, strips quotes, drops empty entries. Tolerant of
 *              common user formatting mistakes.
 *
 * Arguments:
 * 0: CSV string <STRING>
 *
 * Return Value:
 * Cleaned classnames <ARRAY of STRING>
 *
 * Example:
 * ["Car, Tank ,"" Man"] call root_anomalies_main_fnc_parseClassList;
 *
 * Public: No
 */

params [["_csv", "", [""]]];

private _result = (_csv splitString ",") apply {
    private _cleaned = [_x] call CBA_fnc_trim;
    _cleaned = _cleaned splitString """'" joinString "";
    [_cleaned] call CBA_fnc_trim
};

_result select {_x != ""}
