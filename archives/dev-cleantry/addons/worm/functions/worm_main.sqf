


WORM_avoid = {
    private ["_danger_close", "_op_dir", "_chased_units", "_fct", "_reldir", "_avoid_poz"];
    _danger_close = _this select 0;
    _chased_units = _this select 1;
    {
        _reldir = [_x, getPos _danger_close] call BIS_fnc_dirto;
        _fct = [30, -30] call BIS_fnc_selectRandom;
        if (_reldir < 180) then {
            _op_dir = _reldir + 180 + _fct
        } else {
            _op_dir = _reldir - 180 + _fct
        };
        _avoid_poz = [getPosATL _x, 20 + random 50, _op_dir] call BIS_fnc_relPos;
        _x doMove _avoid_poz;
        _x setSkill ["commanding", 1];
    } forEach _chased_units;
};

WORM_vehicle_dmg = {
    params ["_unit", "_worm_dmg"];
    private ["_vehicle", "_damage", "_vichitpoints", "_worm_dmg"];
    _vehicle = _unit;
	_damage = random(_worm_dmg);
	_vichitpoints = getAllHitPointsDamage _vehicle; _vichitpoints = _vichitpoints select 0;
	{
		_damage = random(_worm_dmg);
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

if (!isServer) exitWith {};

params ["_poz_worm", "_damage_worm", "_territory", "_isaipanic", "_wormdiffuser"];
private ["_press_implicit_x", "_press_implicit_y", "_isacemedical"];

_isacemedical = false;

if !(isClass (configFile >> "CfgPatches" >> "ace_medical_engine")) then {
	_isacemedical = false;
} else {
	_isacemedical = true;
};

uiSleep 2;

_cap	= createVehicle ["land_CanOpener_F", getMarkerPos _poz_worm, [], 0, "CAN_COLLIDE"];
_coada	= createVehicle ["land_CanOpener_F", getMarkerPos _poz_worm, [], 0, "CAN_COLLIDE"];
_coada_01= createVehicle ["land_CanOpener_F", getMarkerPos _poz_worm, [], 0, "CAN_COLLIDE"];

_cap setVariable ["isWorm", true, true];

wormkiller = _wormdiffuser; publicVariable "wormkiller";

_coada attachTo [_cap, [0, -1, 1]];
_coada_01 attachTo [_coada, [0, -1, 1]];
[_coada, true] remoteExec ["hideObject", 0, true];
[_coada_01, true] remoteExec ["hideObject", 0, true];

_hide_me = true;
while {_hide_me} do {
    uiSleep 2;
    _list_ai_in_range_worm = (getMarkerPos _poz_worm) nearEntities [["CAManBase", "LandVehicle"], _territory];
    if (count _list_ai_in_range_worm > 0) then {
        _hide_me = false;
        _tgt_worm = _list_ai_in_range_worm call BIS_fnc_selectRandom;
        _dir_move = [getPos _cap, _tgt_worm] call BIS_fnc_dirto;
        _dir_move = _dir_move + 45;
        if (_dir_move <= 90) then {
            _press_implicit_x = linearConversion [0, 90, _dir_move, 0, 1, true];
            _press_implicit_y = 1 - _press_implicit_x;
        };
        
        if ((_dir_move > 90) && (_dir_move < 180)) then {
            _dir_move = _dir_move - 90;
            _press_implicit_x = linearConversion [0, 90, _dir_move, 1, 0, true];
            _press_implicit_y = _press_implicit_x - 1;
        };
        
        if ((_dir_move > 180) && (_dir_move < 270)) then {
            _dir_move = _dir_move - 180;
            _press_implicit_x = linearConversion [0, 90, _dir_move, 0, -1, true];
            _press_implicit_y = (-1 * _press_implicit_x) - 1;
        };
        
        if ((_dir_move > 270) && (_dir_move < 360)) then {
            _dir_move = _dir_move - 270;
            _press_implicit_x = linearConversion [0, 90, _dir_move, -1, 0, true];
            _press_implicit_y = 1 + _press_implicit_x;
        };
        [_cap, _coada, _coada_01] remoteExec ["Root_fnc_WormEffect", [0, -2] select isDedicated, true];
        [_cap, _coada] remoteExec ["Root_fnc_WormAttack", [0, -2] select isDedicated];
        _cap setPosATL [getPosATL _cap select 0, getPosATL _cap select 1, 2];
        _cap setVelocity [_press_implicit_x * 5, _press_implicit_y * 5, 20 + random 10];
        uiSleep 1;
        [_coada, ["strigat", 1000]] remoteExec ["say3D"];
    };
};
uiSleep 1;
resetCamShake;
waitUntil {
    (getPosATL _cap select 2) < 1
};
[_cap, ["bump", 500]] remoteExec ["say3D"];
addCamShake [1, 4, 23];
[_cap, _coada] remoteExec ["Root_fnc_WormAttack", [0, -2] select isDedicated];
[_cap] remoteExec ["Root_fnc_WormBump", [0, -2] select isDedicated];
uiSleep 1;

while {!isNull _cap} do {
    _tgt_worm = [];
    _list_ai_in_range_worm = (getMarkerPos _poz_worm) nearEntities [["CAManBase", "LandVehicle"], _territory];
    _list_ai_in_range_worm select {(typeOf _x != "VirtualCurator_F") };
    _tgt_worm = selectRandom _list_ai_in_range_worm;
    if (count _list_ai_in_range_worm > 0) then {
        if ((_tgt_worm distance _cap < 15) && !(surfaceIsWater getPos _tgt_worm)) then {
            if (_isaipanic) then {[_cap, _list_ai_in_range_worm] call WORM_avoid;};
            _dir_move = [getPos _cap, _tgt_worm] call BIS_fnc_dirto;
            if (_dir_move <= 90) then {
                _press_implicit_x = linearConversion [0, 90, _dir_move, 0, 1, true];
                _press_implicit_y = 1 - _press_implicit_x;
            };
            
            if ((_dir_move > 90) && (_dir_move < 180)) then {
                _dir_move = _dir_move - 90;
                _press_implicit_x = linearConversion [0, 90, _dir_move, 1, 0, true];
                _press_implicit_y = _press_implicit_x - 1;
            };
            
            if ((_dir_move > 180) && (_dir_move < 270)) then {
                _dir_move = _dir_move - 180;
                _press_implicit_x = linearConversion [0, 90, _dir_move, 0, -1, true];
                _press_implicit_y = (-1 * _press_implicit_x) - 1;
            };
            
            if ((_dir_move > 270) && (_dir_move < 360)) then {
                _dir_move = _dir_move - 270;
                _press_implicit_x = linearConversion [0, 90, _dir_move, -1, 0, true];
                _press_implicit_y = 1 + _press_implicit_x;
            };
            _worm_salt = ["salt_08", "salt_05"] call BIS_fnc_selectRandom;
            _cap setVelocity [_press_implicit_x * 5, _press_implicit_y * 5, 15 + random 10];
            [_coada, [_worm_salt, 500]] remoteExec ["say3D"];
            uiSleep 0.5;
            waitUntil {
                (getPosATL _cap select 2) < 1
            };
            [_cap, _coada] remoteExec ["Root_fnc_WormAttack", [0, -2] select isDedicated];
            _nearobj_wrom = nearestObjects [getPosATL _cap, [], 25];
            {
                if ((_x != _cap) && (_x != _coada) && (_x != _coada_01) && !(surfaceIsWater getPos _x)) then {
                    if ((_x isKindOf "LandVehicle") || (_x isKindOf "Air")) then {
                        _x setVelocityModelSpace [_press_implicit_x * 5, _press_implicit_y * 5, 15 + random 10];
                        [_x, _damage_worm] call WORM_vehicle_dmg;
                    } else {
                        if ((typeOf _x != "VirtualCurator_F") && (_x isKindOf "CAManBase")) then {
                            _x setVelocityModelSpace [_press_implicit_x * 5, _press_implicit_y * 5, 15 + random 10];
                            if(_isacemedical) then {
                                _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
                                _dmgType = selectRandom ["backblast", "bullet", "explosive", "grenade", "falling"];
                                [_x, _damage_worm, _bodyPart, _dmgtype] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];
                                _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
                                _dmgType = selectRandom ["backblast", "bullet", "explosive", "grenade", "falling"];
                                [_x, _damage_worm, _bodyPart, _dmgtype] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];
                                _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
                                _dmgType = selectRandom ["backblast", "bullet", "explosive", "grenade", "falling"];
                                [_x, _damage_worm, _bodyPart, _dmgtype] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];
                                _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
                                _dmgType = selectRandom ["backblast", "bullet", "explosive", "grenade", "falling"];
                                [_x, _damage_worm, _bodyPart, _dmgtype] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];
                                _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
                                _dmgType = selectRandom ["backblast", "bullet", "explosive", "grenade", "falling"];
                                [_x, _damage_worm, _bodyPart, _dmgtype] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];
                            } else {
                                _x setDamage ((damage _x) + _damage_worm);
                            };
                        };
                    };
                };
            } forEach _nearobj_wrom;
            uiSleep 1;
            if (_isaipanic) then {[_cap, _list_ai_in_range_worm] call WORM_avoid;};
            if (((getPosATL _cap select 2) < 0) || ((getPosATL _cap select 2) > 2)) then {
                _cap setPos ([getPos _cap, 0.5, 50, 10, 0, 1, 0] call BIS_fnc_findSafePos)
            };
            uiSleep 8;
            _cap setPosATL [getPosATL _cap select 0, getPosATL _cap select 1, 2];
        };     
        if ((!isNull _tgt_worm) && (_tgt_worm distance _cap > 15) && !(surfaceIsWater getPos _tgt_worm)) then {
            _sunet_deplas = ["move_01", "move_02", "move_03", "move_04", "move_05", "move_06", "move_07", "move_08", "move_09", "move_10", "move_11", "move_12", "move_13", "move_14", "move_15"] call BIS_fnc_selectRandom;
            if (_isaipanic) then {[_cap, _list_ai_in_range_worm] call WORM_avoid;};
            _fct_move = 8 + random 8;
            _fct = [10 + random - 35, 10 + random 45] call BIS_fnc_selectRandom;
            _dir_move = [getPos _cap, _tgt_worm] call BIS_fnc_dirto;
            _dir_move = _dir_move + _fct;
            if (_dir_move <= 90) then {
                _press_implicit_x = linearConversion [0, 90, _dir_move, 0, 1, true];
                _press_implicit_y = 1 - _press_implicit_x;
            };
            
            if ((_dir_move > 90) && (_dir_move < 180)) then {
                _dir_move = _dir_move - 90;
                _press_implicit_x = linearConversion [0, 90, _dir_move, 1, 0, true];
                _press_implicit_y = _press_implicit_x - 1;
            };
            
            if ((_dir_move > 180) && (_dir_move < 270)) then {
                _dir_move = _dir_move - 180;
                _press_implicit_x = linearConversion [0, 90, _dir_move, 0, -1, true];
                _press_implicit_y = (-1 * _press_implicit_x) - 1;
            };
            
            if ((_dir_move > 270) && (_dir_move < 360)) then {
                _dir_move = _dir_move - 270;
                _press_implicit_x = linearConversion [0, 90, _dir_move, -1, 0, true];
                _press_implicit_y = 1 + _press_implicit_x;
            };
            [_coada, [_sunet_deplas, 500]] remoteExec ["say3D"];
            _cap setVelocity [_press_implicit_x * _fct_move, _press_implicit_y * _fct_move, 5 + random 5];
            uiSleep 2;
            _cap setPosATL [getPosATL _cap select 0, getPosATL _cap select 1, 2];
        };
    } else {
        uiSleep 3;
    };
};