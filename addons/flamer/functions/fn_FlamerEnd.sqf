#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server watcher that triggers the Flamer's death explosion and applies
 *              area damage when the Flamer is killed.
 *
 * Arguments:
 * 0: Flamer object <OBJECT>
 * 1: Death damage fraction <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params ["_flamer", ["_deathDamage", 1, [0]]];

waitUntil {uiSleep 1; !alive _flamer};

[_flamer] remoteExec [QFUNC(FlamerEndSfx), [0, -2] select isDedicated];

private _crater = "Crater" createVehicle [getPosATL _flamer select 0, getPosATL _flamer select 1, 0];
_crater say3D ["close_bomb", 300];

private _veg = nearestTerrainObjects [position _flamer, ["TREE", "SMALL TREE", "BUSH", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "FOREST"], 20, false];
private _men = _flamer nearEntities [["CAManBase", "LandVehicle", "Helicopter"], 20];
private _builds = nearestObjects [position _flamer, ["BUILDING", "HOUSE", "CHURCH", "CHAPEL", "FUELSTATION", "HOSPITAL", "RUIN", "BUNKER", "Land_fs_roof_F", "Land_TTowerBig_2_F", "Land_TTowerBig_1_F", "Lamps_base_F", "PowerLines_base_F", "PowerLines_Small_base_F", "Land_LampStreet_small_F", "CAR", "TANK", "PLANE", "HELICOPTER", "Motorcycle", "Air", "Ship"], 20, false];

{_x setDamage [_deathDamage, false]} forEach (_builds - [_crater]);
{_x setDamage [_deathDamage, false]} forEach _veg;
{[_x, _deathDamage, "body", "burn"] call EFUNC(main,applyDamage)} forEach _men;
