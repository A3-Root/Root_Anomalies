
 

if (!isServer) exitWith {};



STRIGOI_find_target = {
	private ["_neartargets", "_teritoriu"];
	_strigoi = _this select 0;
	_teritoriu = _this select 1;
	_neartargets = (ASLToAGL getPosATL _strigoi) nearEntities ["CAManBase", _teritoriu];
	_neartargets - [_strigoi];
};

STRIGOI_strig_drain = {
	private ["_list_unit_range_casp"];
	_list_unit_range_casp = _this select 0;
	{_x setFatigue ((getFatigue _x) + 0.1)} forEach _list_unit_range_casp;
};

STRIGOI_avoid_casp = {
	_strig = _this select 0;
	_chased = _this select 1;
	if (isPlayer _chased) exitWith {};
	_relPos = _chased getPos [10, (_strig getDir _chased) + (random 33) * (selectRandom [1, -1])];
	_chased doMove _relPos;
	_chased setSkill ["commanding", 1];
};

STRIGOI_attk_strig = {
	params ["_strigoi", "_tgt_casp", "_damage_strig", "_noseize"];
	[[_strigoi, _tgt_casp, _noseize], "\z\root_anomalies\addons\strigoi\functions\strigoi_atk_viz.sqf"] remoteExec ["execVM", [0, -2] select isDedicated];
	if ((isPlayer _tgt_casp) && (typeOf _tgt_casp != "VirtualCurator_F")) then {
		[[_damage_strig, _noseize], "\z\root_anomalies\addons\strigoi\functions\strigoi_tgt_attk.sqf"] remoteExec ["execVM", _tgt_casp]
	} else {
		if ((_tgt_casp isKindOf "Man") && (_tgt_casp != _strigoi)) then {
			_bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
			_dmgType = selectRandom ["backblast", "bullet", "explosive", "grenade"];
			if (typeOf _tgt_casp != "VirtualCurator_F") then {
				if (!(isNil "ace_medical_fnc_addDamageToUnit")) then {
					[_tgt_casp, _damage_strig, _bodyPart, _dmgType] remoteExec ["ace_medical_fnc_addDamageToUnit", _tgt_casp];	
				} else {
					_x setDamage ((damage _tgt_casp) + _damage_strig);
				};
			};
		} else {
			_tgt_casp setDamage ((damage _tgt_casp) + _damage_strig);
		};
		
	};
	uiSleep 1;
};

STRIGOI_hide_strig = {
	_this setVariable ["vizibil", false, true];
	[_this getVariable "_cap_casper", ["03_tip_casp", 1000]] remoteExec ["say3D"];
	_this enableSimulationGlobal false; _this hideObjectGlobal true;
};

STRIGOI_show_strig = {
	private ["_strigoi", "_poz_orig_sc", "_pos_strig", "_teritoriu"];
	_strigoi = _this select 0;
	_poz_orig_sc = _this select 1;
	_teritoriu = _this select 2;
	_pos_strig = [_poz_orig_sc, 1, _teritoriu / 10, 3, 0, 20, 0] call BIS_fnc_findSafePos;
	_strigoi setPos _pos_strig;
	_strigoi setVariable ["vizibil", true, true];
	[[_strigoi], "\z\root_anomalies\addons\strigoi\functions\strigoi_sfx.sqf"] remoteExec ["execVM", 0];
	_strigoi enableSimulationGlobal true; _strigoi hideObjectGlobal false; {_strigoi reveal _x} forEach (_strigoi nearEntities [["CAManBase"], 100]);
	[_strigoi getVariable "_cap_casper", ["03_tip_casp", 1000]] remoteExec ["say3D"];
};

STRIGOI_salt_1 = {
	params ["_strigoi", "_poz_tgt", "_umbla_casper", "_obj_de_agatat", "_cap_casper", "_pot_poz"];
	private "_unghi_fugarit";
	_umbla_casper setPos (_obj_de_agatat getPos [2, _obj_de_agatat getRelDir _poz_tgt]);
	_salt_sunet = ["01_salt", "02_salt", "03_salt"] call BIS_fnc_selectRandom;
	[_cap_casper, [_salt_sunet, 200]] remoteExec ["say3D"];
	_strigoi setVelocityTransformation [getPosATL _strigoi, getPosATL _umbla_casper, velocity _strigoi, velocity _umbla_casper, [0, 0, 0], [0, 0, 0], [0, 0, 1], [0, 0, 2], 0.3];
	_strigoi attachTo [_umbla_casper, [0, 0, (getPos _obj_de_agatat select 2) + _pot_poz / 4]];
	_strigoi setDir (_strigoi getRelDir _poz_tgt);
	_tipat_casp = selectRandom ["01_tip_casp", "NoSound", "02_tip_casp", "03_tip_casp", "NoSound", "04_tip_casp", "05_tip_casp", "06_tip_casp", "07_tip_casp", "NoSound"];
	[_cap_casper, [_tipat_casp, 500]] remoteExec ["say3D"];
};

STRIGOI_salt_2 = {
	params ["_strigoi", "_tgt_casp", "_umbla_casper", "_obj_de_agatat", "_cap_casper"];
	private ["_jump_dir"];
	_jump_dir = (getPosATL _strigoi vectorFromTo getPosATL _tgt_casp) vectorMultiply 10;
	_salt_sunet = selectRandom ["01_salt", "02_salt", "03_salt"];
	_strigoi attachTo [_umbla_casper, [0, 0, ((boundingCenter _obj_de_agatat) select 2) * 2]];
	[_cap_casper, [_salt_sunet, 200]] remoteExec ["say3D"];
	detach _strigoi;
	_strigoi setVelocity [_jump_dir select 0, _jump_dir select 1, 3];
};

STRIGOI_jump_ground = {
	params ["_strigoi", "_tgt_casp", "_cap_casper"];
	private ["_jump_dir"];
	_jump_dir = (getPosATL _strigoi vectorFromTo getPosATL _tgt_casp) vectorMultiply 15;
	_salt_sunet = selectRandom ["01_salt", "02_salt", "03_salt"];
	[_cap_casper, [_salt_sunet, 200]] remoteExec ["say3D"];
	_strigoi setVelocity [_jump_dir select 0, _jump_dir select 1, round (5 + random 15)];
};

params ["_poz_orig_sc", "_teritoriu", "_vizible_day", "_damage_strig", "_hp_strigoi", "_noseize", "_isaipanic"];
private ["_hp_incr", "_hp_curr_strig", "_pos_strig", "_anomalie_dedus", "_gasit", "_obj_de_agatat", "_pot_poz", "_press_implicit_x", "_press_implicit_y", "_fct_mult", "_vert_vit", "_inaltime_salt", "_distanta_salt", "_dur_zbor", "_umbla_casper", "_strigoi", "_tgt_casp"];

uiSleep 2;

_ck_pl = false;
while {!_ck_pl} do {{if (_x distance getMarkerPos _poz_orig_sc < 1000) then {_ck_pl = true}} forEach allPlayers; uiSleep 10};

_strigoi = createAgent ["C_Soldier_VR_F", getMarkerPos _poz_orig_sc, [], 0, "NONE"];
_strigoi setVariable ["BIS_fnc_animalBehaviour_disable", true];
_strigoi setSpeaker "NoVoice"; _strigoi disableConversation true;
_strigoi addRating -10000; _strigoi setBehaviour "CARELESS";
_strigoi enableFatigue false; _strigoi setSkill ["courage", 1];
_strigoi setUnitPos "UP"; _strigoi disableAI "ALL"; _strigoi setMass 7000;
{_strigoi enableAI _x} forEach ["MOVE", "ANIM", "TEAMSWITCH", "PATH"];



_hp_curr_strig = 1 / _hp_strigoi;
_strigoi setVariable ["al_dam_total", 0];
_strigoi setVariable ["al_dam_incr", _hp_curr_strig];
_strigoi removeAllEventHandlers "Hit";

_strigoi addEventHandler ["Hit", {
    _unit = _this select 0;
    _curr_dam = (_unit getVariable "al_dam_total") + (_unit getVariable "al_dam_incr"); _unit setVariable ["al_dam_total", _curr_dam]; if ((_unit getVariable "al_dam_total") > 1) then {
        _unit setDamage 1
    };
    [[_unit], "\z\root_anomalies\addons\strigoi\functions\strigoi_splash_hit.sqf"] remoteExec ["execVM"]
}];

_strigoi removeAllEventHandlers "HandleDamage";

_strigoi addEventHandler ["HandleDamage", {
    0
}];

_strigoi addEventHandler ["Killed", {
    (_this select 0) hideObjectGlobal true;
    (_this select 1) addRating 2000
}];




_strigoi setAnimSpeedCoef 1.1;

_umbla_casper = "Land_HelipadEmpty_F" createVehicle [getPosATL _strigoi select 0, getPosATL _strigoi select 1, 20];
_cap_casper = "Land_HelipadEmpty_F" createVehicle [0, 0, 0];
_cap_casper attachTo [_strigoi, [0, 0, 0.2], "neck"];
_strigoi setVariable ["_cap_casper", _cap_casper, true];
for "_i" from 0 to 5 do {_strigoi setObjectMaterialGlobal [_i, "A3\Structures_F\Data\Windows\window_set.rvmat"]; uiSleep 0.1;};
uiSleep 0.3;
for "_i" from 0 to 5 do {_strigoi setObjectTextureGlobal [_i, "#(ai,512,512,1)perlinNoise(256,256,0,0.3)"]; uiSleep 0.1;};
_strigoi call STRIGOI_hide_strig;
[[_strigoi], "\z\root_anomalies\addons\strigoi\functions\strigoi_fatigue_p.sqf"] remoteExec ["execVM", [0, -2] select isDedicated, true];

_list_unit_range_casp = [];

_isEntityHidden = false;

while {alive _strigoi} do {
	while {count _list_unit_range_casp isEqualTo 0} do {_list_unit_range_casp = [_strigoi, _teritoriu] call STRIGOI_find_target; uiSleep 5};
	_tgt_casp = selectRandom ( _list_unit_range_casp select {(typeOf _x != "VirtualCurator_F") && (lifeState _x != "INCAPACITATED") } );
	[_strigoi, getMarkerPos _poz_orig_sc, _teritoriu] call STRIGOI_show_strig;
	_isEntityHidden = false;
	while {(!isNil "_tgt_casp") && {(alive _strigoi) && ((_strigoi distance getMarkerPos _poz_orig_sc) < _teritoriu)}} do {
		[_list_unit_range_casp] call STRIGOI_strig_drain;
		_strigoi moveTo AGLToASL (_tgt_casp getRelPos[10, 180]);
		if (_isaipanic) then {[_strigoi, _tgt_casp] call STRIGOI_avoid_casp;};
		uiSleep 1;
		if (_strigoi distance _tgt_casp < 40) then {
			_atk_sun = selectRandom ["01_atk_bg", "02_atk", "03_atk", "04_atk"];
			[_strigoi, [_atk_sun, 400]] remoteExec ["say3D"];
			[_strigoi, _tgt_casp, _damage_strig, _noseize] call STRIGOI_attk_strig;
			uiSleep 1;
		};
		if (selectRandom [true, false]) then {
			if (selectRandom [true, false]) then {
				_copaci = nearestTerrainObjects [_tgt_casp, ["TREE"], 20];
				if (count _copaci != 0) then {
					uiSleep 1;
					_obj_de_agatat = "";
					{
						_unghi_fugarit = _strigoi getRelDir _tgt_casp;
						_unghi_ancora = _strigoi getRelDir _x;
						_toleranta = abs(_unghi_fugarit - _unghi_ancora);
						_pot_poz = (boundingCenter _x) select 2;
						if ((_pot_poz > 2) && {(_toleranta < 60) && (_strigoi distance _x < 20)}) exitWith {
							_obj_de_agatat = _x;
							[_strigoi, _tgt_casp, _umbla_casper, _obj_de_agatat, _cap_casper, _pot_poz] call STRIGOI_salt_1;
							uiSleep 1;
							[_strigoi, _tgt_casp, _umbla_casper, _obj_de_agatat, _cap_casper] call STRIGOI_salt_2;
						};
					} forEach _copaci;
				}
			} else {[_strigoi, _tgt_casp, _cap_casper] call STRIGOI_jump_ground};
		};
		
		if ((!alive _tgt_casp) || (_tgt_casp distance getMarkerPos _poz_orig_sc > _teritoriu)) then {
			_list_unit_range_casp = [_strigoi, _teritoriu] call STRIGOI_find_target;
			if (count _list_unit_range_casp != 0) then {_tgt_casp = selectRandom ( _list_unit_range_casp select {(typeOf _x != "VirtualCurator_F") && (lifeState _x != "INCAPACITATED") })} else {_tgt_casp = nil};
		};
		uiSleep 1;
	};
	if !(_isEntityHidden) then {
		_strigoi call STRIGOI_hide_strig;
		_isEntityHidden = true;
	};
	_tgt_casp = nil;
	_list_unit_range_casp = [];
	_strigoi moveTo getMarkerPos _poz_orig_sc;
	uiSleep 5;
};

deleteVehicle _umbla_casper; detach _cap_casper; deleteVehicle _cap_casper; uiSleep 5; deleteVehicle _strigoi;