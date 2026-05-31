#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: AI panic loop (always visible) - all nearby AI flee.
 *
 * Arguments:
 * 0: Anomaly object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params ["_obj"];

while {alive _obj} do {
    {
        private _unit = _x;
        if (local _unit) then {
            private _relDir = [_unit, getPos _obj] call BIS_fnc_dirTo;
            private _fct = selectRandom [30, -30];
            private _opDir = if (_relDir < 180) then {_relDir + 180 + _fct} else {_relDir - 180 + _fct};
            _unit doMove ([getPosATL _unit, 100 + random 500, _opDir] call BIS_fnc_relPos);
            _unit setSkill ["commanding", 1];
        };
    } forEach ((position _obj) nearEntities ["Man", 80]);
    uiSleep 10;
};
