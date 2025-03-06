
 
SWARMER_avoid_hive = { params ["_hiver", "_chased"]; if (isPlayer _chased) exitWith {}; _relPos = _chased getPos [50, (_hiver getDir _chased) + (random 33) * (selectRandom [1, -1])]; _chased doMove _relPos; _chased setSkill ["commanding", 1]; };
SWARMER_find_target = { params ["_hiver", "_teritoriu", "_swarmerobject"]; private "_neartargets"; _neartargets = (getPosATL _swarmerobject) nearEntities ["CAManBase", _teritoriu]; _neartargets - [_hiver]; };
SWARMER_movePos = { params ["_swarmer_agent", "_tgt_hiv"]; private ["_swarmer_agent", "_tgt_hiv"]; _swarmer_agent setDir ([_swarmer_agent, _tgt_hiv] call BIS_fnc_dirTo); _swarmer_agent moveTo AGLToASL (_tgt_hiv modelToWorld [0, 7, 0]); };
SWARMER_adjustPos = { params ["_swarmer_agent", "_tgt_hiv"]; private ["_swarmer_agent", "_tgt_hiv"]; _swarmer_agent setDir ([_swarmer_agent, _tgt_hiv] call BIS_fnc_dirTo); _swarmer_agent moveTo AGLToASL (_tgt_hiv modelToWorld [0, 0, 0]); };

if (!isServer) exitWith {};

params ["_swarmer_hiveobj", "_radius", "_hiv_ki", "_dmg_un"];
private ["_tgt_hiv"];

uiSleep 2;

insecticid = _hiv_ki; publicVariable "insecticid";

if (!isNil {_swarmer_hiveobj getVariable "activate"}) exitWith {};
_swarmer_hiveobj setVariable ["activate", true, true];

_swarmer_agent = createAgent ["C_Soldier_VR_F", position _swarmer_hiveobj, [], 0, "NONE"]; _swarmer_agent hideObjectGlobal true;
_swarmer_agent setVariable ["BIS_fnc_animalBehaviour_disable", true]; _swarmer_agent setSpeaker "NoVoice"; _swarmer_agent disableConversation true;
_swarmer_agent setBehaviour "CARELESS"; _swarmer_agent allowDamage false; _swarmer_agent enableFatigue false; _swarmer_agent setSkill ["courage", 1];
_swarmer_agent setUnitPos "UP"; _swarmer_agent disableAI "ALL"; {_swarmer_agent enableAI _x} forEach ["MOVE", "ANIM", "TEAMSWITCH", "PATH"]; _swarmer_agent setAnimSpeedCoef 1.1;
_swarmer_agent setVariable ["isHive", false, true];
[_swarmer_agent] remoteExec ["Root_fnc_SwarmerVoice", [0, -2] select isDedicated];
[_swarmer_agent] remoteExec ["Root_fnc_SwarmerSfx", [0, -2] select isDedicated];
swarmer_public = _swarmer_agent; publicVariable "swarmer_public";
atak_swarmer = false; publicVariable "atak_swarmer";

while {alive _swarmer_agent} do {
	while {!(_swarmer_agent getVariable "isHive")} do {{if (_x distance getPos _swarmer_agent < 1000) then {_swarmer_agent setVariable ["isHive", true, true]}} forEach allPlayers; uiSleep 10};
	_swarmer_agent setVariable ["tgt", nil, true];
	_list_unit_range_hiv = [];
	_list_unit_range_hiv = [_swarmer_agent, _radius, _swarmer_hiveobj] call SWARMER_find_target;
	_list_unit_range_hiv = _list_unit_range_hiv select {typeOf _x != "VirtualCurator_F" };
	if (count _list_unit_range_hiv > 0) then {
		_tgt_hiv = selectRandom _list_unit_range_hiv;
		_swarmer_agent setVariable ["tgt", _tgt_hiv, true];
		{[_swarmer_agent, _x] spawn SWARMER_avoid_hive} forEach _list_unit_range_hiv;
		_swarmer_agent disableCollisionWith _tgt_hiv;
		while {(alive _tgt_hiv) && (_tgt_hiv distance _swarmer_hiveobj <= _radius)} do {
			if (_tgt_hiv distance _swarmer_agent > 10) then {_swarmer_agent moveTo AGLToASL (_tgt_hiv modelToWorld [0, 7, 0])};
			uiSleep 4;
			if ((_tgt_hiv distance _swarmer_agent <= 10) and (alive _swarmer_agent)) then {	
				atak_swarmer = true; publicVariable "atak_swarmer";
				_swarmer_agent moveTo AGLToASL (_tgt_hiv modelToWorld [0, 0, 0]);
				_swarmer_agent moveTo AGLToASL (_tgt_hiv modelToWorld [0, 0, 0]);
				if (alive _swarmer_agent) then {
					[_tgt_hiv, _swarmer_agent] remoteExec ["Root_fnc_SwarmerEating", [0, -2] select isDedicated];
					_amountOfDamage = _dmg_un;
					_type_of_damage = selectRandom ["bullet", "explosive", "grenade", "punch", "ropeburn", "shell", "stab", "burn"];
					_bodyPart = selectRandom ["head", "body", "hand_l", "hand_r", "leg_l", "leg_r"];
					if (!(isNil "ace_medical_fnc_addDamageToUnit")) then {
						[_tgt_hiv, _amountOfDamage, _bodyPart, _type_of_damage] remoteExec ["ace_medical_fnc_addDamageToUnit", _tgt_hiv];	
					} else {
						_tgt_hiv setDamage ((damage _tgt_hiv) + _amountOfDamage);
					};
				};
				{[_swarmer_agent, _x] spawn SWARMER_avoid_hive} forEach _list_unit_range_hiv;
				uiSleep 2;
				atak_swarmer = false; publicVariable "atak_swarmer";
				_balta_sange = createVehicle [selectRandom["BloodPool_01_Large_New_F", "BloodSplatter_01_Large_New_F"], [0, 0, 0], [], 0, "CAN_COLLIDE"]; _balta_sange setDir (round (random 360)); _balta_sange setPosATL [getPosATL _tgt_hiv select 0, getPosATL _tgt_hiv select 1, 0]; _balta_sange setVectorUp surfaceNormal getPosATL _balta_sange;
				_swarmer_agent setPos (position _balta_sange);
				_swarmer_agent stop true;
				[_balta_sange, ["roi_atk_01", 300]] remoteExec ["say3D"];
				uiSleep 2;
				_swarmer_agent stop false;
				{[_swarmer_agent, _x] spawn SWARMER_avoid_hive} forEach _list_unit_range_hiv;
			};
		};
		if (!alive _tgt_hiv) then {
			[_swarmer_agent, _tgt_hiv] spawn SWARMER_adjustPos;
			uiSleep 2;
			_swarmer_agent stop true;
			[_tgt_hiv, _swarmer_agent] remoteExec ["Root_fnc_SwarmerEating", [0, -2] select isDedicated];
			_tgt_hiv hideObjectGlobal true;
			_oase = createVehicle ["Land_HumanSkeleton_F", getPosATL _tgt_hiv, [], 0, "CAN_COLLIDE"]; _oase setDir (round (random 360));
			_swarmer_agent setVariable ["tgt", nil, true];
			atak_swarmer = false; publicVariable "atak_swarmer";
			uiSleep 12;
			_swarmer_agent stop false;
		};
	} else {_swarmer_agent setVariable ["isHive", false, true]; atak_swarmer = false; publicVariable "atak_swarmer"; uiSleep 5};
};
uiSleep 10; deleteVehicle _swarmer_agent;


