
 
private ["_spawn_obj_class", "_object_anom_core", "_gigi", "_spawn_obj", "_spawn_obj_classname"];

_spawn_obj_class = _this select 0;
_object_anom_core = _this select 1;

_object_anom_core setVariable ["activeaza", false, true];

while {!isNull _object_anom_core} do {
	while {!(_object_anom_core getVariable "activeaza")} do {{if (_x distance getPos _object_anom_core < 1100) then {_object_anom_core setVariable ["activeaza", true, true]}} forEach allPlayers; uiSleep 10};
	_object_anom_core setVariable ["activeaza", false, true];
	_spawn_obj_classname = selectRandom _spawn_obj_class;
	if (getNumber (configFile >> "CfgVehicles" >> _spawn_obj_classname >> "scope") > 0) then {
		if (_spawn_obj_classname isKindOf "MAN") then {
			_grp_side = selectRandom [east, west, civilian, independent];
			_grp = createGroup _grp_side;
			_bounce_obj_temp = createVehicle ["Land_CanOpener_F", getPosATL _object_anom_core, [], 0, "CAN_COLLIDE"];
			[_bounce_obj_temp] remoteExec ["hideObject", -2];
			_tipat = selectRandom ["strigat_1", "strigat_2", "strigat_3", "strigat_4", "strigat_5", "strigat_6", "strigat_7", "strigat_8", "strigat_9", "strigat_91", "strigat_92"];
			_telep_in = selectRandom ["telep_01", "telep_02", "telep_03", "telep_04", "telep_05"];
			[_object_anom_core , [_telep_in, 300]] remoteExec ["say3D"];
			_gigi = _grp createUnit [_spawn_obj_classname, getPosATL _object_anom_core, [], 0, "CAN_COLLIDE"];
			[_gigi, "NoVoice"] remoteExec ["setSpeaker", 0];	_gigi setBehaviour "AWARE";	_gigi enableFatigue false;	_gigi setUnitPos "UP"; _gigi setSkill ["commanding", 1];
			_gigi setVariable ["teleported_in", 1, true];
			_bounce_obj_temp setDir (random 360);
			_gigi attachTo [_bounce_obj_temp, [0, 0, 1]];
			_bounce_obj_temp setVelocity [selectRandom [-4, 4], selectRandom [-4, 4], 2];
			[_bounce_obj_temp, ["tremor", 300]] remoteExec ["say3D"];
			uiSleep 0.8;
			[_gigi, [_tipat, 100]] remoteExec ["say3D", 0];
			detach _gigi;
			deleteVehicle _bounce_obj_temp;
			uiSleep 0.5;
			_gigi setPosATL [getPosATL _gigi select 0, getPosATL _gigi select 1, 0.0001];
			_anim = selectRandom ["ApanPknlMrunSnonWnonDb", "ApanPknlMrunSnonWnonDf", "ApanPercMrunSnonWnonDf", "ApanPercMsprSnonWnonDfr"];
			[_gigi, _anim] remoteExec ["switchMove"];
			_run_poz = [getPosATL _object_anom_core, 100 + random 500, random 360] call BIS_fnc_relPos;
			uiSleep 3;
			if (alive _gigi) then {[_gigi, ""] remoteExec ["switchMove"]};
			_gigi setDamage (damage _gigi + (random 0.15));
			_gigi doMove _run_poz;
			[_gigi] spawn {
				_unit_fresh = _this select 0;
				uiSleep 120;
				_unit_fresh setVariable ["teleported_in", nil, true];
			};
			uiSleep 10 + random spawn_delay_smugg;
		} else {
			_bounce_obj_temp = createVehicle ["Land_CanOpener_F", getPosATL _object_anom_core, [], 0, "CAN_COLLIDE"];
			[_bounce_obj_temp] remoteExec ["hideObject", -2];
			_telep_in = selectRandom ["telep_01", "telep_02", "telep_03", "telep_04", "telep_05"];
			[_object_anom_core , [_telep_in, 300]] remoteExec ["say3D", 0];	
			_spawn_obj = createVehicle [_spawn_obj_classname, [getPosATL _object_anom_core select 0, getPosATL _object_anom_core select 1, 1], [], 0, "NONE"];
			_spawn_obj attachTo [_bounce_obj_temp, [0, 0, 0]];
			_bounce_obj_temp setVelocity [selectRandom [-20, 20], selectRandom [-20, 20], 10];
			_impact = selectRandom ["bodyfall_wood_3", "bodyfall_wood_1", "bodyfall_wood_2", "bodyfall_metal_3"];
			[_bounce_obj_temp, ["tremor", 300]] remoteExec ["say3D"];
			waitUntil {(getPosATL _spawn_obj select 2) < 0.3};
			detach _spawn_obj;
			[_spawn_obj, [_impact, 100]] remoteExec ["say3D", 0];
			_spawn_obj setPosATL [getPosATL _spawn_obj select 0, getPosATL _spawn_obj select 1, 0.0001];
			uiSleep 0.1;
			deleteVehicle _bounce_obj_temp;
			uiSleep 10 + random spawn_delay_smugg;
			if ((_spawn_obj distance _object_anom_core < 10) and (local _spawn_obj)) then {deleteVehicle _spawn_obj};
		};
	};
};