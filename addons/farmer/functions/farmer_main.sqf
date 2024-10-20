
 
if (!isServer) exitWith {};

private ["_marker_farmer", "_territory", "_damage_inflicted", "_recharge_delay", "_health_points", "_pozitie_noua", "_tgt_farmer", "_list_unit_range_farm", "_isaipanic"];


params ["_marker_farmer", "_territory", "_damage_inflicted", "_recharge_delay", "_health_points", "_isaipanic"];
_soundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimstring;
explozie = "\z\root_anomalies\addons\main\sounds\punch_7.ogg";
pietre = "\z\root_anomalies\addons\main\sounds\pietre.ogg";
travel_ground = "\z\root_anomalies\addons\main\sounds\travel_ground.ogg";
eko = "\z\root_anomalies\addons\main\sounds\eko.ogg";
publicVariable "explozie";
publicVariable "pietre";
publicVariable "travel_ground";
publicVariable "eko";
_ck_pl = false;

FARMER_find_target = {
	private "_neartargets";
	params ["_farmer", "_teritoriu"];
	_neartargets = (ASLToAGL getPosATL _farmer) nearEntities [["CAManBase", "LandVehicle"], _teritoriu];
	_neartargets - [_farmer];
};

FARMER_hide_farmer = {
	_this setAnimSpeedCoef 0.8;
	_this switchMove "AmovPknlMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon";
	_this setVariable ["vizibil", false, true];
	[_this, ["pietre", 1000]] remoteExec ["say3D"];
	[[_this], "\z\root_anomalies\addons\farmer\functions\farmer_teleport.sqf"] remoteExec ["execVM", 0];
	_this hideObjectGlobal true;
};

FARMER_show_farmer = {
	private ["_pos_farmer", "_teritoriu", "_blow_poz"];
	params ["_farmer", "_poz_orig_sc"];
	_pos_farmer = [_poz_orig_sc, 0, 10, 3, 0, 20, 0, [], _poz_orig_sc] call BIS_fnc_findSafePos;
	_farmer setPos _poz_orig_sc; _farmer setVariable ["vizibil", true, true];
	[_farmer, ["punch_7", 1000]] remoteExec ["say3D"];
	_farmer hideObjectGlobal false;
	[[_farmer], "\z\root_anomalies\addons\farmer\functions\farmer_teleport.sqf"] remoteExec ["execVM", 0];
	_farmer setAnimSpeedCoef 0.8;
	_farmer switchMove "AmovPknlMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon";
	_farmer setUnitPos "UP";
	uiSleep 1;
	playSound3D ["\z\root_anomalies\addons\main\sounds\eko.ogg", "", false, [getPos _farmer select 0, getPos _farmer select 1, 1000], 20, 5, 0];
};

FARMER_avoid_farmer = {
	params ["_strig", "_chased"];
	if (isPlayer _chased) exitWith {};
	_relPos = _chased getPos [25, round ((_strig getDir _chased) + (random 33) * (selectRandom [1, -1]))];
	_chased doMove _relPos;	_chased setSkill ["commanding", 1];
};

FARMER_attk_farmer = {
	private ["_vehicle", "_damage", "_vichitpoints"];
	params ["_farmer", "_damage_farmer"];
	_farmer setUnitPos "UP";
	[[_farmer, _damage_farmer], "\z\root_anomalies\addons\farmer\functions\farmer_shock_SFX.sqf"] remoteExec ["execVM"];

	uiSleep 1.2;
	{	
		if !(isPlayer _x) then {
			_jump_dir = (getPosATL _farmer vectorFromTo getPosATL _x) vectorMultiply 3;
			_bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
			_dmgType = selectRandom ["backblast", "bullet", "explosive", "grenade"];
			if ((typeOf _x != "VirtualCurator_F") && (_x isKindOf "CAManBase")) then {
				_x setVelocity [_jump_dir select 0, _jump_dir select 1, 9];
				if (!(isNil "ace_medical_fnc_addDamageToUnit")) then {
					[_x, _damage_farmer, _bodyPart, "falling"] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];	
				} else {
					_x setDamage ((damage _x) + _damage_farmer);
				};
			};
			if (_x isKindOf "LandVehicle") then {
				_x setVelocity [_jump_dir select 0, _jump_dir select 1, 3];
				_vehicle = _x;
				_damage = random[0, _damage_farmer, 1];
				_vichitpoints = getAllHitPointsDamage _vehicle; _vichitpoints = _vichitpoints select 0;
				{
					_damage = random[0, _damage_farmer, 1];
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
		}
	} forEach (_farmer nearEntities [["CAManBase", "LandVehicle"], 25]);
};

FARMER_travel_farmer = {
	params ["_farmer", "_tgt_farmer"];
	_farmer setUnitPos "DOWN";
	_rag = "Land_PenBlack_F" createVehicle [getPosATL _farmer select 0, getPosATL _farmer select 1, 3000];
	_jump_dir = (getPosATL _farmer vectorFromTo getPosATL _tgt_farmer) vectorMultiply 20;
	_rag setVelocity [_jump_dir select 0, _jump_dir select 1, 5];
	[[_rag], "\z\root_anomalies\addons\farmer\functions\farmer_travel_SFX.sqf"] remoteExec ["execVM"];
	uiSleep round (2 + random 2);
	_farmer setVariable ["pozitie_noua", getPos _rag];
	deleteVehicle _rag;
};


while {!_ck_pl} do {
    {
        if (_x distance getMarkerPos _marker_farmer < _territory) then {
            _ck_pl = true
        }
    } forEach allPlayers;
    uiSleep 5;
};

_farmer = createAgent ["C_Soldier_VR_F", getMarkerPos _marker_farmer, [], 0, "NONE"];
_farmer setVariable ["BIS_fnc_animalbehaviour_disable", true];
_farmer setSpeaker "NoVoice";
_farmer disableConversation true; _farmer addRating -10000; _farmer setBehaviour "CARELESS";
_farmer enableFatigue false;
_farmer setSkill ["courage", 1]; _farmer setUnitPos "UP"; _farmer disableAI "ALL"; _farmer setMass 7000;

{
    _farmer enableAI _x
} forEach ["move", "ANIM", "teamSwitch", "PATH"];

_hp_curr_farmer = 1 / _health_points;
_farmer setVariable ["al_dam_total", 0];
_farmer setVariable ["al_dam_incr", _hp_curr_farmer];
_farmer removeAllEventHandlers "Hit";

_farmer addEventHandler ["Hit", {
    _unit= _this select 0;
    _curr_dam = (_unit getVariable "al_dam_total") + (_unit getVariable "al_dam_incr"); _unit setVariable ["al_dam_total", _curr_dam]; if ((_unit getVariable "al_dam_total") > 1) then {
        _unit setDamage 1
    };
    [[_unit], "\z\root_anomalies\addons\farmer\functions\farmer_splash_hit.sqf"] remoteExec ["execVM"]
}];

_farmer removeAllEventHandlers "HandleDamage";

_farmer addEventHandler ["HandleDamage", {
    0
}];

_farmer addEventHandler ["Killed", {
    (_this select 0) hideObjectGlobal true;
    (_this select 1) addRating 2000
}];

for "_i" from 0 to 5 do {
    _farmer setObjectMaterialGlobal [_i, "\a3\data_f\default.rvmat"];
    uiSleep 0.1;
};

for "_i" from 0 to 5 do {
    _farmer setObjectTextureGlobal [_i, "#(rgb, 8, 8, 3)color(0, 0.5, 0, 0.5)"];
    uiSleep 0.1;
};

for "_i" from 0 to 5 do {
    _farmer setObjectTextureGlobal [_i, "a3\structures_f_mark\training\data\shootingmat_01_opfor_co.paa"];
    uiSleep 0.1;
};

_farmer call FARMER_hide_farmer;
_farmer enableSimulationGlobal false;

while {alive _farmer} do {
    _ck_pl = false;
    _farmer setUnitPos "UP";
    while {!_ck_pl} do {
        {
            if (_x distance getMarkerPos _marker_farmer < _territory) then {
                _ck_pl = true
            }
        } forEach allPlayers;
        uiSleep 5;
    };



    _list_unit_range_farm = [_farmer, _territory] call FARMER_find_target;




    _tgt_farmer = selectRandom (_list_unit_range_farm select {
        (typeOf _x != "VirtualCurator_F") && (lifeState _x != "INCAPACITATED")
    });
    _farmer setUnitPos "UP";
    _farmer enableSimulationGlobal true;
    _farmer setUnitPos "UP";




    [_farmer, getMarkerPos _marker_farmer] call FARMER_show_farmer;



    while {
        (!isNil "_tgt_farmer") &&{
            (alive _farmer) && ((_farmer distance getMarkerPos _marker_farmer) < _territory)
        }
    } do
    {
        _farmer setDir (_farmer getRelDir _tgt_farmer);
        if ((_farmer distance _tgt_farmer) > 20) then {
            _farmer call FARMER_hide_farmer;



            [_farmer, _tgt_farmer] call FARMER_travel_farmer;



            _pozitie_noua = _farmer getVariable "pozitie_noua";
            [_farmer, _pozitie_noua] call FARMER_show_farmer;
            if (_isaipanic) then 
            {
                {
                    [_farmer, _x] spawn FARMER_avoid_farmer
                } forEach _list_unit_range_farm;
            };
            uiSleep 1;
        };
        _farmer setUnitPos "UP";
        if ((_farmer distance _tgt_farmer) < 20) then {
            uiSleep 1;
            [_farmer, _damage_inflicted] call FARMER_attk_farmer;
            if (_isaipanic) then 
            {
                {
                    [_farmer, _x] spawn FARMER_avoid_farmer
                } forEach _list_unit_range_farm;
            };
            uiSleep _recharge_delay;
        } else {
            uiSleep 1 + random 2;
            _farmer call FARMER_hide_farmer
        };
        _farmer setUnitPos "UP";
        if ((!alive _tgt_farmer) || (_tgt_farmer distance getMarkerPos _marker_farmer > _territory)) then {
            _list_unit_range_farm = [_farmer, _territory] call FARMER_find_target;
            if !(count _list_unit_range_farm isEqualTo 0) then {
                _tgt_farmer = selectRandom (_list_unit_range_farm select {(typeOf _x != "VirtualCurator_F") && (lifeState _x != "INCAPACITATED") });
            } else {
                _tgt_farmer = nil
            };
        };
    };
    _farmer setUnitPos "UP";
    uiSleep 1;
    _farmer call FARMER_hide_farmer;
    	_farmer enableSimulationGlobal false;
    _list_unit_range_farm = [];
    _farmer setUnitPos "UP";
};

playSound3D ["\z\root_anomalies\addons\main\sounds\eko.ogg", "", false, [getPos _farmer select 0, getPos _farmer select 1, 100], 20, 5, 0];

deleteVehicle _farmer;