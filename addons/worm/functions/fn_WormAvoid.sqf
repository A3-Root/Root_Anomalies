#include "\z\root_anomalies\addons\worm\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Makes nearby AI units flee away from the worm's position (panic behaviour).
 *
 * Arguments:
 * 0: Worm origin object <OBJECT>
 * 1: Units to scatter <ARRAY of OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_origin", "_units"];

{
    private _relDir = [_x, getPos _origin] call BIS_fnc_dirTo;
    private _spread = selectRandom [30, -30];
    private _opDir = if (_relDir < 180) then {_relDir + 180 + _spread} else {_relDir - 180 + _spread};
    _x doMove ([getPosATL _x, 20 + random 50, _opDir] call BIS_fnc_relPos);
    _x setSkill ["commanding", 1];
} forEach _units;
