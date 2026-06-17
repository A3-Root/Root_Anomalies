#include "\z\root_anomalies\addons\twins\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server loop that periodically damages and scatters AI within range of
 *              the Twins.
 *
 * Arguments:
 * 0: Twins object <OBJECT>
 * 1: AI damage range <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params ["_twins", ["_aiRange", 75, [0]]];

while {alive _twins && {!(_twins getVariable [EGVAR(main,terminate), false])}} do {
    private _units = (position _twins) nearEntities [["CAManBase", "LandVehicle"], _aiRange];
    private _runPos = [getPosATL _twins, 1000, random 360] call BIS_fnc_relPos;
    private _dmg = (_twins getVariable [QGVAR(config), createHashMap]) getOrDefault ["damage", 0];
    {
        if ((typeOf _x != "VirtualCurator_F") && {[_x, _twins] call EFUNC(main,isAffectable)}) then {
            // Damage is opt-in: 0 (default) = scatter/disorient only.
            if (_dmg > 0) then {[_x, _dmg, "body", "stab", _twins] call EFUNC(main,applyDamage)};
            _x doMove _runPos;
            _x setSkill ["commanding", 1];
            uiSleep 0.1;
        };
    } forEach _units;
    uiSleep 30;
};
