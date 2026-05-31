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

while {alive _twins} do {
    private _units = (position _twins) nearEntities [["CAManBase", "LandVehicle"], _aiRange];
    private _runPos = [getPosATL _twins, 1000, random 360] call BIS_fnc_relPos;
    {
        if (typeOf _x != "VirtualCurator_F") then {
            [_x, 0.1, "body", "stab"] call root_anomalies_main_fnc_applyDamage;
            _x doMove _runPos;
            _x setSkill ["commanding", 1];
            uiSleep 0.1;
        };
    } forEach _units;
    uiSleep 30;
};
