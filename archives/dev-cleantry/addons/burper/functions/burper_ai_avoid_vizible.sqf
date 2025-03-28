private ["_avoid_poz", "_op_dir", "_reldir"];

_obj_teleporter = _this select 0;

while {alive _obj_teleporter} do {
	_list_ai_in_range = (position _obj_teleporter) nearEntities ["Man", 50];
	if (count _list_ai_in_range > 0) then {
		{
			if (local _x) then {
				_reldir = [_x, getPos _obj_teleporter] call BIS_fnc_dirTo;
				_fct = selectRandom [30, -30];
				if (_reldir < 180) then {_op_dir = _reldir + 180 + _fct} else {_op_dir = _reldir - 180 + _fct};
				_avoid_poz = [getPosATL _x, 100 + random 500, _op_dir] call BIS_fnc_relPos;
				_x doMove _avoid_poz;
				_x setSkill ["commanding", 1];
			};
		} forEach _list_ai_in_range;
	};
	uiSleep 10;
};
