
 

if (!isServer) exitWith {};

_electr_viz		= _this select 0;
_AI_dam_range	= _this select 1;
	
while {alive _electr_viz} do 
{
	_AI_units = [];
	_AI_units = (position _electr_viz) nearEntities [["CAManBase", "LandVehicle"], _AI_dam_range];	
	_pos_run = [getPosATL _electr_viz, 1000, random 360] call BIS_fnc_relPos;
	
	if (count _AI_units > 0) then {
		{
		if (typeOf _x != "VirtualCurator_F") then {
		_damage_ai = damage _x;
		_damage_ai = _damage_ai + 0.1;
		_x setDamage _damage_ai;
		_x doMove _pos_run;
		_x setSkill ["commanding", 1];
		uiSleep 0.1;};
		} forEach _AI_units;
	};
	
	uiSleep 30;
};