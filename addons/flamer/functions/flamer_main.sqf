
 
if (!isServer) exitWith {};

FLAMER_find_target = {
	params ["_flamer", "_teritoriu"];
	private ["_neartargets", "_teritoriu"];
	_neartargets = (ASLToAGL getPosATL _flamer) nearEntities [["CAManBase", "LandVehicle"], _teritoriu];
	_neartargets - [_flamer]
};

FLAMER_avoid_flamer = {
	params ["_flamer", "_chased"];
	private ["_flamer", "_chased"];
	if (isPlayer _chased) exitWith {};
	_relPos = _chased getPos [30, (_flamer getDir _chased) + (random 33) * (selectRandom [1, -1])];
	_chased doMove _relPos;
	_chased setSkill ["commanding", 1];
};

FLAMER_attk_flamer = {
	params ["_flamer", "_tgt_casp", "_damage_flamer"];
	private ["_flamer", "_tgt_casp", "_damage_flamer", "_isacemedical", "_vehicle", "_vichitpoints", "_damage", "_time"];
	_isacemedical = false;
	if !(isClass (configFile >> "CfgPatches" >> "ace_medical_engine")) then {
		diag_log "******ACE Medical Engine not detected. Using vanilla medical system.";
		_isacemedical = false;
	} else {
		_isacemedical = true;
	};
	_shoot_dir = (getPosATL _flamer vectorFromTo getPosATL _tgt_casp) vectorMultiply 15;
	[_flamer getVariable "_cap_flamer", ["foc_initial", 500]] remoteExec ["say3D"];
	[[_flamer, _shoot_dir], "\z\root_anomalies\addons\flamer\functions\flamer_plasma_SFX.sqf"] remoteExec ["execVM"];
	uiSleep 0.5;
	_tip = selectRandom ["04", "burned", "02", "03"];
	_nearflamer = (ASLToAGL getPosATL _flamer) nearEntities [["CAManBase", "LandVehicle", "Helicopter"], 20];
	{
		_bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.47, 0.69, 0.59, 0.55, 0.61, 0.58];
		if ((typeOf _x != "VirtualCurator_F") && (_x isKindOf "Man") && (_x != _flamer)) then {
			if (_isacemedical) then {
				[_x, _damage_flamer, _bodyPart, "burn"] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];
			} else {
				_x setDamage ((damage _x) + _damage_flamer);
			};
			_tip = selectRandom ["04", "burned", "02", "03"];
			[_x, [_tip, 200]] remoteExec ["say3D"];
		} else {
			if ((_x isKindOf "LandVehicle") or (_x isKindOf "Air")) then {
				_vehicle = _x;
				_damage = random(_damage_flamer);
				_vichitpoints = getAllHitPointsDamage _vehicle; _vichitpoints select 0;
				{
					_damage = random(_damage_flamer);
					_vehicle setHitPointDamage [_x, (_vehicle getHitPointDamage _x) + _damage];
				} forEach _vichitpoints;
			};
		};
	} forEach (_nearflamer - [_flamer]);
	_nearvik = nearestObjects [position _flamer, ["CAR", "TANK", "PLANE", "HELICOPTER", "Motorcycle", "Air"], 7, false]; 
	{_x setDamage (damage _x + ( _damage_flamer * 5 ))} forEach _nearvik;
	uiSleep 4;
	_flamer setVariable ["atk", false];
};

FLAMER_hide_flamer = {
	_this setVariable ["vizibil", false, true];
	[_this getVariable "_cap_flamer", ["foc_initial", 1000]] remoteExec ["say3D"];
	_this enableSimulationGlobal false; _this hideObjectGlobal true;
};

FLAMER_show_flamer = {
	params ["_flamer", "_poz_orig_sc", "_teritoriu", "_damage_flamer"];
	private ["_flamer", "_poz_orig_sc", "_pos_strig", "_teritoriu", "_damage_flamer"];
	_pos_strig = [_poz_orig_sc, 1, _teritoriu / 10, 3, 0, 20, 0] call BIS_fnc_findSafePos;
	_flamer setPos _pos_strig;
	_flamer setVariable ["vizibil", true, true];
	[[_flamer, _damage_flamer, _poz_orig_sc], "\z\root_anomalies\addons\flamer\functions\flamer_sfx.sqf"] remoteExec ["execVM", 0];
	_flamer enableSimulationGlobal true; _flamer hideObjectGlobal false; {_flamer reveal _x} forEach (_flamer nearEntities [["CAManBase", "LandVehicle", "Helicopter"], 100]);
	[_flamer getVariable "_cap_flamer", ["foc_initial", 1000]] remoteExec ["say3D"];
};

FLAMER_jump_flamer = {
	params ["_flamer", "_tgt_casp", "_cap_flamer", "_damage_flamer"];
	private ["_jump_dir", "_blast_dust", "_flama", "_li_fire", "_bbb", "_isacemedical", "_vehicle", "_vichitpoints", "_damage", "_time"];
	_isacemedical = false;
	if !(isClass (configFile >> "CfgPatches" >> "ace_medical_engine")) then {
		diag_log "******ACE Medical Engine not detected. Using vanilla medical system.";
		_isacemedical = false;
	} else {
		_isacemedical = true;
	};
	_jump_dir = (getPosATL _flamer vectorFromTo getPosATL _tgt_casp) vectorMultiply round (10 + random 10);
	_salt_sunet= selectRandom ["01_blast", "02_blast", "03_blast"];
	_obj_veg = nearestTerrainObjects [position _flamer, ["TREE", "SMALL TREE", "BUSH", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "FOREST"], 20, false];
	_nearvik = nearestObjects [position _flamer, ["CAR", "TANK", "PLANE", "HELICOPTER", "Motorcycle", "Air"], 20, false];
	[_cap_flamer, [_salt_sunet, 200]] remoteExec ["say3D"];
	_nearflamer = (ASLToAGL getPosATL _flamer) nearEntities [["CAManBase", "LandVehicle"], 20];
	{
		_bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.47, 0.69, 0.59, 0.55, 0.61, 0.58];
		
		if ((typeOf _x != "VirtualCurator_F") && (_x isKindOf "Man") && (_x != _flamer)) then {
			if (_isacemedical) then {
				[_x, _damage_flamer, _bodyPart, "burn"] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];
			} else {
				_x setDamage ((damage _x) + _damage_flamer);
			};
			_tip = selectRandom ["04", "burned", "02", "03"];
			[_x, [_tip, 200]] remoteExec ["say3D"];
		} else {
			if ((_x isKindOf "LandVehicle") or (_x isKindOf "Air")) then {
				_vehicle = _x;
				_damage = random(_damage_flamer);
				_vichitpoints = getAllHitPointsDamage _vehicle; _vichitpoints select 0;
				{
					_damage = random(_damage_flamer);
					_vehicle setHitPointDamage [_x, (_vehicle getHitPointDamage _x) + _damage];
				} forEach _vichitpoints;
			};
		};
	} forEach (_nearflamer - [_flamer]);
	_flamer setVelocity [_jump_dir select 0, _jump_dir select 1, round (10 + random 15)];
	{_x setDamage [1, false]; _x hideObjectGlobal true} forEach _obj_veg;
	{_x setDamage (damage _x + 0.10)} forEach _nearvik;
};

params ["_poz_orig_sc", "_teritoriu", "_damage_flamer", "_recharge_delay", "_hp_flamer", "_damage_on_death", "_isaipanic", "_activation_range"];
private ["_isacemedical", "_vehicle", "_vichitpoints", "_damage", "_time"];

uiSleep 2;

if !(isClass (configFile >> "CfgPatches" >> "ace_medical_engine")) then {
    diag_log "******ACE Medical Engine not detected. Using vanilla medical system.";
	_isacemedical = false;
} else {
	_isacemedical = true;
};

_ck_pl = false;
_flamer = createAgent ["O_Soldier_VR_F", getMarkerPos _poz_orig_sc, [], 0, "NONE"]; _flamer setVariable ["BIS_fnc_animalBehaviour_disable", true]; _flamer setSpeaker "NoVoice"; _flamer disableConversation true; _flamer addRating -10000; _flamer setBehaviour "CARELESS"; _flamer enableFatigue false; _flamer setSkill ["courage", 1]; _flamer setUnitPos "UP"; _flamer disableAI "ALL"; _flamer setMass 7000; {_flamer enableAI _x} forEach ["MOVE", "ANIM", "TEAMSWITCH", "PATH"];


_hp_curr_flamer = 1 / _hp_flamer;
_flamer setVariable ["flamer_dmg_total", 0];
_flamer setVariable ["flamer_dmg_increase", _hp_curr_flamer];
_flamer removeAllEventHandlers "Hit";

_flamer addEventHandler ["Hit", {
    _unit= _this select 0;
    _flamer_curr_dmg = (_unit getVariable "flamer_dmg_total") + (_unit getVariable "flamer_dmg_increase");
	_unit setVariable ["flamer_dmg_total", _flamer_curr_dmg];
	if ((_unit getVariable "flamer_dmg_total") > 1) then {
        _unit setDamage 1
    };
    [[_unit], "\z\root_anomalies\addons\flamer\functions\flamer_splash_hit.sqf"] remoteExec ["execVM"]
}];

_flamer removeAllEventHandlers "HandleDamage";

_flamer addEventHandler ["HandleDamage", {0}];

_flamer addEventHandler ["Killed", {
    (_this select 0) hideObjectGlobal true;
    (_this select 1) addRating 2000
}];

_flamer setAnimSpeedCoef 1.2;
_cap_flamer = "Land_HelipadEmpty_F" createVehicle [0, 0, 0]; _cap_flamer attachTo [_flamer, [0, 0, 0.2], "neck"]; _flamer setVariable ["_cap_flamer", _cap_flamer, true];

for "_i" from 0 to 5 do {
    _flamer setObjectMaterialGlobal [_i, "\a3\data_f\default.rvmat"];
	uiSleep 0.1;
};
for "_i" from 0 to 5 do {
    _flamer setObjectTextureGlobal [_i, "\z\root_anomalies\addons\flamer\images\03_flesh.jpg"];
	uiSleep 0.1;
};
_flamer setVariable ["atk", false];
_flamer call FLAMER_hide_flamer;
_list_unit_range_flamer = [];
[_flamer, _damage_on_death] execVM "\z\root_anomalies\addons\flamer\functions\flamer_end.sqf";





while {!_ck_pl} do {{if (_x distance getMarkerPos _poz_orig_sc < _activation_range) then {_ck_pl = true}} forEach allPlayers; uiSleep 5;};



while {alive _flamer} do {
	while {count _list_unit_range_flamer isEqualTo 0} do {_list_unit_range_flamer = [_flamer, _teritoriu] call FLAMER_find_target; uiSleep 5;};
	_list_unit_range_flamer - [_flamer];
	_tgt_flamer = selectRandom (_list_unit_range_flamer select {typeOf _x != "VirtualCurator_F" });
	[_flamer, getMarkerPos _poz_orig_sc, _teritoriu, _damage_flamer] call FLAMER_show_flamer;
	while {(!isNil "_tgt_flamer") && {(alive _flamer) && ((_flamer distance getMarkerPos _poz_orig_sc) < _teritoriu)}} do {
		uiSleep _recharge_delay;
		_nearflamer = (ASLToAGL getPosATL _flamer) nearEntities [["CAManBase", "LandVehicle", "Helicopter"], 20];
		{		
			_bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.47, 0.69, 0.59, 0.55, 0.61, 0.58];
			if ((typeOf _x != "VirtualCurator_F") && (_x isKindOf "Man") && (_x != _flamer)) then {
				if (_isacemedical) then {
					[_x, _damage_flamer, _bodyPart, "burn"] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];
				} else {
					_x setDamage ((damage _x) + 0.03);
				};
				_tip = selectRandom ["04", "burned", "02", "03"];
				[_x, [_tip, 200]] remoteExec ["say3D"];
			} else {
				if ((_x isKindOf "LandVehicle") or (_x isKindOf "Air")) then {
					_vehicle = _x;
					_damage = random(0.3);
					_vichitpoints = getAllHitPointsDamage _vehicle; _vichitpoints select 0;
					{
						_damage = random(0.3);
						_vehicle setHitPointDamage [_x, (_vehicle getHitPointDamage _x) + _damage];
					} forEach _vichitpoints;
				};
			};
		} forEach (_nearflamer - [_flamer]);
		if (selectRandom [true, false, true, true, false]) then {
			_flamer moveTo AGLToASL (_tgt_flamer getRelPos[10, 180]);
			if (_isaipanic) then {[_flamer, _tgt_flamer] call FLAMER_avoid_flamer;};
		} else {
			_nearflamer = (ASLToAGL getPosATL _flamer) nearEntities [["CAManBase", "LandVehicle", "Helicopter"], 20];
			{
				_bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.47, 0.69, 0.59, 0.55, 0.61, 0.58];
				
				if ((typeOf _x != "VirtualCurator_F") && (_x isKindOf "Man") && (_x != _flamer)) then {
					if (_isacemedical) then {
						[_x, _damage_flamer, _bodyPart, "burn"] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];
					} else {
						_x setDamage ((damage _x) + 0.03);
					};
					_tip = selectRandom ["04", "burned", "02", "03"];
					[_x, [_tip, 200]] remoteExec ["say3D"];
				} else {
					if ((_x isKindOf "LandVehicle") or (_x isKindOf "Air")) then {
						_vehicle = _x;
						_damage = random(0.3);
						_vichitpoints = getAllHitPointsDamage _vehicle; _vichitpoints select 0;
						{
							_damage = random(0.3);
							_vehicle setHitPointDamage [_x, (_vehicle getHitPointDamage _x) + _damage];
						} forEach _vichitpoints;
					};
				};
			} forEach (_nearflamer - [_flamer]); [[_flamer], "\z\root_anomalies\addons\flamer\functions\flamer_jump_SFX.sqf"] remoteExec ["execVM"]; [_flamer, _tgt_flamer, _cap_flamer, _damage_flamer] spawn FLAMER_jump_flamer};
		uiSleep _recharge_delay;
		_nearflamer = (ASLToAGL getPosATL _flamer) nearEntities [["CAManBase", "LandVehicle", "Helicopter"], 20];
		{
			_bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.47, 0.69, 0.59, 0.55, 0.61, 0.58];
			
			if ((typeOf _x != "VirtualCurator_F") && (_x isKindOf "Man") && (_x != _flamer)) then {
				if (_isacemedical) then {
					[_x, _damage_flamer, _bodyPart, "burn"] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];
				} else {
					_x setDamage ((damage _x) + 0.03);
				};
				_tip = selectRandom ["04", "burned", "02", "03"];
				[_x, [_tip, 200]] remoteExec ["say3D"];
			} else
			{
				if ((_x isKindOf "LandVehicle") or (_x isKindOf "Air")) then {
					_vehicle = _x;
					_damage = random(0.3);
					_vichitpoints = getAllHitPointsDamage _vehicle; _vichitpoints select 0;
					{
						_damage = random(0.3);
						_vehicle setHitPointDamage [_x, (_vehicle getHitPointDamage _x) + _damage];
					} forEach _vichitpoints;
				};
			};
		} forEach (_nearflamer - [_flamer]);
		if ((_flamer distance _tgt_flamer < 15) && !(_flamer getVariable "atk")) then 
		{_flamer setVariable ["atk", true]; [_flamer, _tgt_flamer, _damage_flamer] spawn FLAMER_attk_flamer; uiSleep 0.5; [[_tgt_flamer], "\z\root_anomalies\addons\flamer\functions\flamer_atk_SFX.sqf"] remoteExec ["execVM"]};
		uiSleep _recharge_delay;
		_nearflamer = (ASLToAGL getPosATL _flamer) nearEntities [["CAManBase", "LandVehicle", "Helicopter"], 20];
		{
			_bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.47, 0.69, 0.59, 0.55, 0.61, 0.58];
			
			if ((typeOf _x != "VirtualCurator_F") && (_x isKindOf "Man") && (_x != _flamer)) then {
				if (_isacemedical) then {
					[_x, _damage_flamer, _bodyPart, "burn"] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];
				} else {
					_x setDamage ((damage _x) + 0.03);
				};
				_tip = selectRandom ["04", "burned", "02", "03"];
				[_x, [_tip, 200]] remoteExec ["say3D"];
			} else {
				if ((_x isKindOf "LandVehicle") or (_x isKindOf "Air")) then {
					_vehicle = _x;
					_damage = random(0.3);
					_vichitpoints = getAllHitPointsDamage _vehicle; _vichitpoints select 0;
					{
						_damage = random(0.3);
						_vehicle setHitPointDamage [_x, (_vehicle getHitPointDamage _x) + _damage];
					} forEach _vichitpoints;
				};
			};
		} forEach (_nearflamer - [_flamer]);
		if ((!alive _tgt_flamer) || (_tgt_flamer distance getMarkerPos _poz_orig_sc > _teritoriu)) then {_list_unit_range_flamer = [_flamer, _teritoriu] call FLAMER_find_target; if !(count _list_unit_range_flamer isEqualTo 0) then {_tgt_flamer = selectRandom _list_unit_range_flamer} else {_tgt_flamer = nil}};
		uiSleep _recharge_delay;
		_nearflamer = (ASLToAGL getPosATL _flamer) nearEntities [["CAManBase", "LandVehicle", "Helicopter"], 20];
		{
			_bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.47, 0.69, 0.59, 0.55, 0.61, 0.58];
			
			if ((typeOf _x != "VirtualCurator_F") && (_x isKindOf "Man") && (_x != _flamer)) then {
				if (_isacemedical) then {
					[_x, _damage_flamer, _bodyPart, "burn"] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];
				} else {
					_x setDamage ((damage _x) + 0.03);
				};
				_tip = selectRandom ["04", "burned", "02", "03"];
				[_x, [_tip, 200]] remoteExec ["say3D"];
			} else {
				if ((_x isKindOf "LandVehicle") or (_x isKindOf "Air")) then {
					_vehicle = _x;
					_damage = random(0.3);
					_vichitpoints = getAllHitPointsDamage _vehicle; _vichitpoints select 0;
					{
						_damage = random(0.3);
						_vehicle setHitPointDamage [_x, (_vehicle getHitPointDamage _x) + _damage];
					} forEach _vichitpoints;
				};
			};
		} forEach (_nearflamer - [_flamer]);
	};
	_flamer call FLAMER_hide_flamer;
	_tgt_flamer = nil;
	_list_unit_range_flamer = [];
	uiSleep _recharge_delay + 2;
};
detach _cap_flamer; deleteVehicle _cap_flamer; uiSleep 5; deleteVehicle _flamer;