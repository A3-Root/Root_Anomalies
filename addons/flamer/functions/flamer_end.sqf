
 

params ["_flamer", "_damage_on_death"];
waitUntil {uiSleep 1; !alive _flamer};
[_flamer] remoteExec ["Root_fnc_FlamerEndSfx", [0, -2] select isDedicated];
_burn_grnd_last = "Crater" createVehicle [getPosATL _flamer select 0, getPosATL _flamer select 1, 0];
_burn_grnd_last say3D ["close_bomb", 300];
_obj_veg = nearestTerrainObjects [position _flamer, ["TREE", "SMALL TREE", "BUSH", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "FOREST"], 20, false];
_obj_man = _flamer nearEntities [["CAManBase", "LandVehicle", "Helicopter"], 20];
_obj_build = nearestObjects [position _flamer, ["BUILDING", "HOUSE", "CHURCH", "CHAPEL", "FUELSTATION", "HOSPITAL", "RUIN", "BUNKER", "Land_fs_roof_F", "Land_TTowerBig_2_F", "Land_TTowerBig_1_F", "Lamps_base_F", "PowerLines_base_F", "PowerLines_Small_base_F", "Land_LampStreet_small_F", "CAR", "TANK", "PLANE", "HELICOPTER", "Motorcycle", "Air", "Ship"], 20, false];
{_x setDamage [_damage_on_death, false]} forEach (_obj_build - [_burn_grnd_last]);
{_x setDamage [_damage_on_death, false]} forEach _obj_veg;
{_x setDamage _damage_on_death} forEach _obj_man;