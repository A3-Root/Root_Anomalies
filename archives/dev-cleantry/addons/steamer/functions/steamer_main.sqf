
 

STEAMER_find_target = {
	params ["_steamer_dud", "_teritoriu"]; private "_neartargets";	_neartargets = (ASLToAGL getPosATL _steamer_dud) nearEntities ["CAManBase", _teritoriu];	_neartargets - [_steamer_dud];
};

STEAMER_avoid_steam = {
	params ["_chased"]; if (isPlayer _chased) exitWith {}; _relPos = _chased getPos [10 + round (random 30), round (random 360)]; _chased doMove _relPos; _chased setSkill ["commanding", 1];
};

STEAMER_travel_path = {
	private ["_rag", "_jump_dir", "_ground", "_burst"];
	params ["_steamer_dud", "_tgt_steamer"];
	if (!hasInterface) exitWith {};
	_rag = "Land_PenBlack_F" createVehicle [getPosATL _steamer_dud select 0, getPosATL _steamer_dud select 1, 3000];
	_jump_dir = (getPosATL _steamer_dud vectorFromTo getPosATL _tgt_steamer) vectorMultiply 20;
	_rag setVelocity [_jump_dir select 0, _jump_dir select 1, 5];
	[_rag] remoteExec ["Root_fnc_SteamerTravel"];
	uiSleep 1;
	deleteVehicle _rag;
};



if (!isServer) exitWith {};
params ["_orig_poz", "_teritoriu", "_damage_steamer", "_recharge", "_dmg_on_death", "_travelpath"];
private ["_damage", "_vehicle", "_vichitpoints"];

_ck_pl = false;
while {!_ck_pl} do {{if (_x distance getMarkerPos _orig_poz < 1000) then {_ck_pl = true}} forEach allPlayers; uiSleep 5};
_steamer_dud = createAgent ["O_Soldier_VR_F", getMarkerPos _orig_poz, [], 0, "NONE"]; _steamer_dud hideObjectGlobal true; _steamer_dud enableSimulationGlobal false;
[_steamer_dud] remoteExec ["Root_fnc_SteamerVoice", 0, true];
_list_unit_range_steamer = [];
while {alive _steamer_dud} do {
	while {count _list_unit_range_steamer isEqualTo 0} do {_list_unit_range_steamer = [_steamer_dud, _teritoriu] call STEAMER_find_target; uiSleep 5};
	_list_unit_range_steamer - [_steamer_dud];
	_tgt_steamer = selectRandom ( _list_unit_range_steamer select {typeOf _x != "VirtualCurator_F" });
	uiSleep 0.5;
	while {(!isNil "_tgt_steamer") && (alive _steamer_dud)} do {
		if (_travelpath) then {[_steamer_dud, _tgt_steamer] call STEAMER_travel_path;};
		_burst_poz = (ASLToAGL getPosATL _tgt_steamer);
		_blow_units = _burst_poz nearEntities [["CAManBase", "LandVehicle", "Air"], 10];
		_crater_bool = selectRandom [false, true, false, false];
		[getPosATL _tgt_steamer, _crater_bool] remoteExec ["Root_fnc_SteamerBurst"];
		{
			_bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
			_dmgType = selectRandom ["backblast", "bullet", "explosive", "grenade"];
			if (_x isKindOf "CAManBase") then {
				if (!(isNil "ace_medical_fnc_addDamageToUnit")) then {
					[_x, _damage_steamer, _bodyPart, _dmgType] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];	
				} else {
					_x setDamage ((damage _x) + _damage_steamer);
				};
			};
			if ((_x isKindOf "LandVehicle") || (_x isKindOf "Air")) then {
				_x setVelocity [25, 25, 25];
				_vehicle = _x;
				_damage = random[0, _damage_steamer, 1];
				_vichitpoints = getAllHitPointsDamage _vehicle; _vichitpoints = _vichitpoints select 0;
				{
					_damage = random[0, _damage_steamer, 1];
					_vehicle setHitPointDamage [_x, (_vehicle getHitPointDamage _x) + _damage];
				} forEach _vichitpoints;
				_vehicle setHitPointDamage ["HitLight", 1];
				_vehicle setHitPointDamage ["#light_l", 1];
				_vehicle setHitPointDamage ["#light_r", 1];
				_vehicle setHitPointDamage ["#light_l_flare", 1];
				_vehicle setHitPointDamage ["#light_r_flare", 1];
				_vehicle setHitPointDamage ["#light_1_hitpoint", 1];
				_vehicle setHitPointDamage ["light_1_hitpoint", 1];
				_vehicle setHitPointDamage ["#light_2_hitpoint", 1];
				_vehicle setHitPointDamage ["light_2_hitpoint", 1];
				_vehicle setHitPointDamage ["light_l", 1];
				_vehicle setHitPointDamage ["light_r", 1];
				_vehicle setHitPointDamage ["light_l2", 1];
				_vehicle setHitPointDamage ["HitBatteries", 1];
				_vehicle setHitPointDamage ["light_r2", 1];
			};
			if (isPlayer _x) then {[_burst_poz, _x] remoteExec ["Root_fnc_SteamerRagdoll", _x]} else {[_burst_poz, _x] spawn Root_fnc_SteamerRagdoll;};
		} forEach (_blow_units - [_steamer_dud]);
		{[_x] call STEAMER_avoid_steam} forEach _list_unit_range_steamer;
		uiSleep (4 + round (random _recharge));
		_list_unit_range_steamer = [_steamer_dud, _teritoriu] call STEAMER_find_target;
		if (count _list_unit_range_steamer > 0) then {_tgt_steamer = selectRandom _list_unit_range_steamer} else {_tgt_steamer = nil};
	};
	_tgt_steamer = nil;
	_list_unit_range_steamer = [];
};
waitUntil {!alive _steamer_dud};
[getPosATL _steamer_dud] remoteExec ["Root_fnc_SteamerEnd", [0, -2] select isDedicated];
_obj_veg = nearestTerrainObjects [position _steamer_dud, ["TREE", "SMALL TREE", "BUSH", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "FOREST"], 20, false];
{_x setDamage [_dmg_on_death, true]} forEach _obj_veg;
_obj_build = nearestObjects [position _steamer_dud, ["BUILDING", "HOUSE", "CHURCH", "CHAPEL", "FUELSTATION", "HOSPITAL", "RUIN", "BUNKER", "Land_fs_roof_F", "Land_TTowerBig_2_F", "Land_TTowerBig_1_F", "Lamps_base_F", "PowerLines_base_F", "PowerLines_Small_base_F", "Land_LampStreet_small_F", "CAR", "TANK", "PLANE", "HELICOPTER", "Motorcycle", "Air", "Ship"], 20, false];
{_x setDamage [_dmg_on_death, false]} forEach _obj_build;
_obj_man = _steamer_dud nearEntities ["CAManBase", 20];
{
	_bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
	_dmgType = selectRandom ["backblast", "bullet", "explosive", "grenade"];
	if (typeOf _x != "VirtualCurator_F") then {	
		if (!(isNil "ace_medical_fnc_addDamageToUnit")) then {
			[_x, _dmg_on_death, _bodyPart, _dmgType] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];	
		} else {
			_x setDamage ((damage _x) + _dmg_on_death);
		};
	};
} forEach _obj_man;
_vik_list = nearestObjects [position _steamer_dud, ["CAR", "TANK", "PLANE", "HELICOPTER", "Motorcycle", "Air", "Ship"], 20, false];
{_x setDamage ((damage _x) + random[0, _dmg_on_death, 1])} forEach _vik_list;
uiSleep 10;
deleteVehicle _steamer_dud;