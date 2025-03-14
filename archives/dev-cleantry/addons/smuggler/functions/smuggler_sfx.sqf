
 

SMUGGLER_sfx_primary = {
	private ["_obj_princ_effect", "_bule_smugg", "_fct_lit", "_dust_smug", "_sursa_princ_center", "_brit_burp", "_b_col_burp", "_g_col_burp", "_r_col_burp", "_sp_dist_smug", "_spot_lit"];
	_obj_princ_effect 	= _this select 0;
	_sursa_princ_center	= _this select 1;

	[_sursa_princ_center] spawn 
	{_obj_princ_voice = _this select 0;	while {player distance _obj_princ_voice < 1000} do {_obj_princ_voice say3D ["smugg_03", 500]; uiSleep 13}};
	
	_basic_param = [[0, [0, 0, 0]], [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0]];
	_center_smug = "#particlesource" createVehicleLocal (getPosATL _sursa_princ_center);
	_center_smug setParticleCircle _basic_param select 0;
	_center_smug setParticleRandom _basic_param select 1;
	_center_smug setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d", 8, 0, 40, 1], "", "Billboard", 1, 3, [0, 0, 0], [0, 0, 0], 7, 10, 7.9, 0, [1, 1, 1], [[0, 0, 0, 0], [0, 0, 0, 0.8], [0, 0, 0, 0]], [1], 0, 0, "", "", _sursa_princ_center];
	_center_smug setDropInterval 1;	

	_invelis = "#particlesource" createVehicleLocal (getPosATL _obj_princ_effect);
	_invelis setParticleCircle _basic_param select 0;
	_invelis setParticleRandom _basic_param select 1;
	_invelis setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d", 8, 0, 40, 1], "", "Billboard", 1, 3, [0, 0, 0], [0, 0, 0], 17, 10, 7.9, 0, [3, 3, 3], [[1, 1, 1, 0], [1, 1, 1, 0.3], [1, 1, 1, 0]], [1], 0, 0, "", "", _obj_princ_effect];
	_invelis setDropInterval 1;	

	_bule_smugg = "#particlesource" createVehicleLocal (getPosATL _obj_princ_effect);
	_bule_smugg setParticleCircle _basic_param select 0;
	_bule_smugg setParticleRandom [0.1, [1, 1, 1], [0, 0, 0], 0, 0.1, [0, 0, 0, 0.1], 1, 0];
	_bule_smugg setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 2, [0, 0, 0], [0, 0, 0], 17, 10, 7.9, 0, [2, 0.5, 2], [[0, 0, 0, 0.5], [0, 0, 0, 1], [0, 0, 0, 0]], [1], 1, 0, "", "", _obj_princ_effect];
	_bule_smugg setDropInterval 0.01;

	_sp_dist_smug = "#particlesource" createVehicleLocal (getPosATL _sursa_princ_center);
	_sp_dist_smug setParticleCircle _basic_param select 0;
	_sp_dist_smug setParticleRandom _basic_param select 1;
	_sp_dist_smug setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 3, [0, 0, 0], [0, 0, 0], 7, 10, 7.9, 0, [3, 0.1, 3], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [1], 0, 0, "", "", _sursa_princ_center];
	_sp_dist_smug setDropInterval 0.5;	

	_dust_smug = "#particlesource" createVehicleLocal (getPosATL _obj_princ_effect);
	_dust_smug setParticleCircle _basic_param select 0;
	_dust_smug setParticleRandom _basic_param select 1;
	_dust_smug setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 1, [0, 0, 0], [0, 0, 0], 15, 10, 7.9, 0.001, [15, 5, 0.1], [[1, 1, 1, 0], [1, 1, 1, 0.05], [0, 0, 0, 0.01]], [0.08], 1, 0, "", "", _obj_princ_effect];
	_dust_smug setDropInterval 2;
	
	_spot_lit = "#lightpoint" createVehicle (getPosATL _sursa_princ_center);
	_spot_lit lightAttachObject [_sursa_princ_center, [random 1, random 1, 1]];
	_spot_lit setLightUseFlare false;
	_spot_lit setLightFlareSize 1;
	_spot_lit setLightFlareMaxDistance 1500;
	_spot_lit setLightAttenuation [0, 0, 50, 1000, 1, 50];
	_spot_lit setLightDayLight true;	

	while {(player distance _obj_sursa_smugg < 1000) && player_chk_det} do {
		_fct_lit = selectRandom [1, -1];
		uiSleep 0.5 + random 1;
		_spot_lit lightAttachObject [_sursa_princ_center, [0.5 + random _fct_lit, 0.5 + random _fct_lit, 1]];
		_r_col_burp = random 1;
		_g_col_burp = random 1;
		_b_col_burp = random 1;
		_spot_lit setLightColor [_r_col_burp, _g_col_burp, _b_col_burp];
		_spot_lit setLightAmbient [_g_col_burp, _r_col_burp, _b_col_burp];
		
		_on_fly_brit = round (10 + random 30);
		_ini_brit = 0;
		while {_ini_brit < _on_fly_brit} do {
			_spot_lit setLightBrightness _ini_brit;
			_ini_brit = _ini_brit + 1;
			uiSleep 0.1;
		};
		while {_ini_brit > 0} do {
			_spot_lit setLightBrightness _ini_brit;
			_ini_brit = _ini_brit - 1;
			uiSleep 0.1;
		};
		uiSleep 0.5 + random 1;	
	};
	detach _spot_lit; deleteVehicle _spot_lit; deleteVehicle _bule_smugg; deleteVehicle _dust_smug; deleteVehicle _sp_dist_smug; deleteVehicle _center_smug; deleteVehicle _invelis;
};

SMUGGLER_sfx_secondary = {
	private ["_obj_sec_effect", "_suck_frunze", "_suck_dust", "_obj_sec_center", "_rafala_smug"];
	_obj_sec_effect = _this select 0;
	_obj_sec_center = _this select 1;
	
	player setVariable ["loop_dust", true];

	while {player getVariable "loop_dust"} do {
		_rafala_smug = selectRandom ["rafala_smug_01", "rafala_smug_02", "rafala_smug_03"];
		_obj_sec_center say3D [_rafala_smug, 500];

		_suck_frunze = "#particlesource" createVehicleLocal (getPosATL _obj_sec_effect);
		_suck_frunze setParticleCircle [5, [0, 0, 0]];
		_suck_frunze setParticleRandom [0.1, [6, 6, 0], [-7, -7, 0.5], 0.25, 0.5, [0, 0, 0, 1], 1, 0.5];
		_suck_frunze setParticleParams [["\A3\data_f\ParticleEffects\Hit_Leaves\Leaves_Green.p3d", 1, 0, 1], "", "SpaceObject", 1, 10, [0, 0, 0], [0, 0, 2], 1, 12, 7.9, 1, [3, 3, 3], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [1], 1, 0.5, "", "", _obj_sec_effect, random 360, true, 0.3];
		_suck_frunze setDropInterval 0.01;

		_suck_dust = "#particlesource" createVehicleLocal (getPosATL _obj_sec_effect);
		_suck_dust setParticleCircle [6, [-3, -3, 0]];
		_suck_dust setParticleRandom [0.5, [2, 2, 0], [-7, -7, 0], 3, 0.5, [0, 0, 0, 1], 1, 0.5];
		_suck_dust setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 2, [0, 0, 0], [0, 0, 0.1], 0, 10, 7.9, 0, [3, 5, 10], [[0.3, 0.27, 0.15, 0], [0.3, 0.27, 0.15, 0.05], [0.3, 0.27, 0.15, 0]], [0.08], 1, 0, "", "", _obj_sec_effect];
		_suck_dust setDropInterval 0.01;
		uiSleep 1;
		deleteVehicle _suck_frunze;
		deleteVehicle _suck_dust;
		uiSleep round (7 + random 7);
	};
};

SMUGGLER_detector_check = {
	if ([_this, detect_smug] call BIS_fnc_hasItem) then {
		_hasItemOrNot = true;
		true;
	} else {
		_hasItemOrNot = false;
		false
	}
};

if (!hasInterface) exitWith {};

_obj_sursa_smugg = _this select 0;
_sursa_core		 = _this select 1;

waitUntil {!isNil{_sursa_core getVariable "activeaza"}};

if (detect_smug != "") then {
	while {!isNull _obj_sursa_smugg} do {
		waitUntil {uiSleep 5; player distance _obj_sursa_smugg < 1000};
		_sursa_core setVariable ["activeaza", true, true];
		[_obj_sursa_smugg, _sursa_core] spawn SMUGGLER_sfx_secondary;
		waitUntil {player call SMUGGLER_detector_check};
		player_chk_det = true;
		[] spawn {waitUntil{uiSleep 1; !(player call SMUGGLER_detector_check)}; player_chk_det = false};
		[_obj_sursa_smugg, _sursa_core] call SMUGGLER_sfx_primary;
		player setVariable ["loop_dust", false];
		uiSleep 10;
	};
} else {
		player_chk_det = true;
		while {!isNull _obj_sursa_smugg} do {
			waitUntil {uiSleep 5; player distance _obj_sursa_smugg < 1000};
			_sursa_core setVariable ["activeaza", true, true];
			[_obj_sursa_smugg, _sursa_core] spawn SMUGGLER_sfx_secondary;
			[_obj_sursa_smugg, _sursa_core] call SMUGGLER_sfx_primary;
			player setVariable ["loop_dust", false];
			uiSleep 10;
		};
	};