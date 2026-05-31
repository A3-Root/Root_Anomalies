#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Converts a CSV side string (e.g. "EAST,INDEPENDENT") into an array of
 *              SIDE values for the hostile-sides filter. Empty/unknown -> []. Accepts
 *              WEST/BLUFOR, EAST/OPFOR, INDEPENDENT/GUER, CIVILIAN/CIV (case-insensitive).
 *
 * Arguments:
 * 0: CSV string <STRING>
 *
 * Return Value:
 * Array of sides <ARRAY of SIDE>
 *
 * Public: No
 */

params [["_csv", "", [""]]];

private _map = createHashMapFromArray [
    ["WEST", west], ["BLUFOR", west],
    ["EAST", east], ["OPFOR", east],
    ["INDEPENDENT", independent], ["GUER", independent], ["GUERRILLA", independent],
    ["CIVILIAN", civilian], ["CIV", civilian]
];

private _result = [];
{
    private _key = toUpper _x;
    if (_key in _map) then {
        private _s = _map get _key;
        if (!(_s in _result)) then { _result pushBack _s; };
    };
} forEach ([_csv] call FUNC(parseClassList));

_result
