#include "\z\root_anomalies\addons\screamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Makes units and vehicles flee away from the Screamer (panic behaviour).
 *
 * Arguments:
 * 0: Screamer origin object <OBJECT>
 * 1: Territory radius <NUMBER>
 * 2: Entity types to scatter <ARRAY of STRING>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_origin", "_territoryRadius", "_targets"];

{
    private _u = _x;
    if ((_u isKindOf "LandVehicle") || {_u isKindOf "Air"} || {_u isKindOf "CAManBase"}) then {
        if (_u != _origin) then {
            private _relDir = [_u, getPos _origin] call BIS_fnc_dirTo;
            private _spread = selectRandom [30, -30];
            private _opDir = if (_relDir < 180) then {_relDir + 180 + _spread} else {_relDir - 180 + _spread};
            private _fleePos = [getPosATL _u, 30 + random 10, _opDir] call BIS_fnc_relPos;
            _u doMove _fleePos;
            _u setSkill ["commanding", 1];
        };
    };
} forEach (_origin nearEntities [_targets, _territoryRadius]);
