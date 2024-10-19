private _hasZen = isClass (configFile >> "CfgPatches" >> "zen_custom_modules");
if !(_hasZen) exitWith
{
	diag_log "******CBA and/or ZEN not detected. They are required for this mod.";
};

//only load for zeus
if (!hasInterface) exitWith {};

["Root's Anomalies", "Burper Anomaly", {
	params ["_posASL", "_attachedObject"];
	[_posASL, _attachedObject] execVM "z\root_anomalies\addons\main\functions\fn_burper.sqf";
	/*

	if (isNil "BURPER_markerIndex") then { BURPER_markerIndex = 0 };

	_burperMarkerName = format ["BURPER_%1", BURPER_markerIndex];
	BURPER_markerIndex = BURPER_markerIndex + 1;
	_burpermarker = createMarker [_burperMarkerName, _posASL];

	private _radiuspos = ASLToATL _posASL;
	private _devicepos = ASLToATL _posASL;

	


	["Burper Anomaly Settings", [
		["SLIDER:RADIUS", ["Burper Territory", "Radius in meters of the Burper's effective range for destruction."], [5, 2000, 10, 0, _radiuspos, [7, 120, 32, 1]]],
		["TOOLBOX:YESNO", ["Enable Vehicle Damage", "If true, all land vehicles wil also be affected by the Burper."], true],
		["TOOLBOX:YESNO", ["Enable Roaming Burper", "If true, the Burper to teleport to random position over time."], false],
		["TOOLBOX:YESNO", ["Enable Detection Device", "If true, the Burper will be invisible and can only be detected with a detection device configured below."], true],
		["TOOLBOX:YESNO", ["Enable Burper Protection", "If true, the Burper will not attack anyone wearing the protection device configured below."], true],
		["TOOLBOX:YESNO", ["Enable Killswitch", "If true, the Burper can and will be destroyed if the configured object is within 10m of its position."], true],
		["TOOLBOX:YESNO", ["Enable AI Panic", "If true, the AI can and will run away to a safe distance from Burper when its visible."], true],
		["SLIDER:RADIUS", ["Killswitch Range", "Radius in meters the Killswitch from Burper to trigger. Ensure its atleast 5m more than Burper Territory if using vehicle."], [10, 4000, 20, 0, _devicepos, [7, 120, 32, 1]]],
		["EDIT", ["Detection Device", "Classname of the Detection Device. Can be the same item as Protection Device."], ["MineDetector"]],
		["EDIT", ["Protection Device", "Classname of the Protection Device. Can be the same item as Detection Device."], ["B_Kitbag_mcamo"]],
		["EDIT", ["Killswitch Device", "Classname of the Killswitch Device. (Default: CSAT Typhoon Device)"], ["O_Truck_03_device_F"]]
		], {
			params ["_results", "_burperMarkerName"];
			_results params ["_burper_territory", "_isvehicle", "_isroaming", "_isdetectable", "_isprotectable", "_iskillable", "_isaipanic", "_killswitch_range", "_detectdevice", "_protectdevice", "_killdevice"];

			if !(_isdetectable) then {_detectdevice = ""};
			if !(_isprotectable) then {_protectdevice = ""};
			if !(_iskillable) then {_killdevice = "NO-KILL-DEVICE-CONFIGURED"; _killswitch_range = 1};
			if (_killswitch_range < _burper_territory) then {
				if (_killdevice isKindOf "LandVehicle") then {
					if ((_killswitch_range + _burper_territory) > (2 * _burper_territory)) then { _killswitch_range = 1.5 * _burper_territory; };
				} else {
					_killswitch_range = _killswitch_range + 5;
				};
			};

			["Burper Anomaly Configured and Created!"] call zen_common_fnc_showMessage;

			[[_burperMarkerName, _isroaming, _detectdevice, _protectdevice, _killdevice, _burper_territory, _isvehicle, _killswitch_range, _isaipanic], "..\scripts\Burper\burper_main.sqf"] remoteExec ["BIS_fnc_execVM", 2];
		}, {
			["Aborted"] call zen_common_fnc_showMessage;
			playSound "FD_Start_F";
		}, _burperMarkerName] call zen_dialog_fnc_create;
		*/
}, "\a3\modules_f\data\portraitmodule_ca.paa"] call zen_custom_modules_fnc_register;




/*

["Root's Anomalies", "Farmer Anomaly", {

    params ["_posASL", "_attachedObject"];

    private _pos = ASLToATL _posASL;

    if (isNil "FARMER_markerindex") then {
        FARMER_markerindex = 0
    };

    _farmerMarkerName = format ["FARMER_%1", FARMER_markerindex];
    FARMER_markerindex = FARMER_markerindex + 1;

    _farmerMarker = createMarker [_farmerMarkerName, _pos];

    

    ["Farmer Anomaly Settings", [
        ["SLIDER", ["Farmer Health", "Amount of damage the Farmer takes before being killed."], [10, 5000, 400, 0]],
        ["TOOLBOX:YESNO", ["Override Minimum Territory", "If true, the minimum territory radius of the Farmer will be overriden from 75m."], false],
        ["SLIDER:RADIUS", ["Farmer Territory", "Radius in meters of the Farmer's territory."], [10, 1000, 75, 0, _pos, [7, 120, 32, 1]]],
        ["TOOLBOX:YESNO", ["AI Panic", "If true, the AI will forcefully run away from Farmer during its attack."], false],
        ["SLIDER:PERCENT", ["Farmer Damage", "Percentage amount of damage the Farmer does to his target."], [0.01, 1, 0.6, 2]],
        ["SLIDER", ["Farmer Recharge Delay", "Delay in seconds between Farmer's attacks."], [3, 60, 5, 0]]
    ], {
        params ["_results", "_farmerMarkerName"];
        _results params ["_farmer_hp", "_territory_override", "_farmer_territory", "_isaipanic", "_farmer_damage", "_farmer_recharge"];
        
        if !(_territory_override) then {
            if (_farmer_territory < 75) then {
                _farmer_territory = 75;
            };
        };

        ["Farmer Anomaly Configured and Created!"] call zen_common_fnc_showMessage;

        [[_farmerMarkerName, _farmer_territory, _farmer_damage, _farmer_recharge, round _farmer_hp, _isaipanic], "..\scripts\Farmer\farmer_main.sqf"] remoteExec ["BIS_fnc_execVM", 2];
    },{
        ["Aborted"] call zen_common_fnc_showMessage;
        playSound "FD_Start_F";
    }, _farmerMarkerName] call zen_dialog_fnc_create;
}, "\a3\modules_f\data\portraitmodule_ca.paa"] call zen_custom_modules_fnc_register;









["Root's Anomalies", "Flamer Anomaly", {
	params ["_posASL", "_attachedObject"];

	private _pos = ASLToATL _posASL;

	if (isNil "FLAMER_markerindex") then {
		FLAMER_markerindex = 0
	};

	_flamerMarkerName = format ["FLAMER_%1", FLAMER_markerindex];
	FLAMER_markerindex = FLAMER_markerindex + 1;

	_flamerMarker = createMarker [_flamerMarkerName, _pos];

	

	["Flamer Anomaly Settings", [
		["SLIDER", ["Flamer Health", "Amount of damage the Flamer takes before being killed."], [10, 5000, 400, 0]], 
		["TOOLBOX:YESNO", ["Override Minimum Territory", "If true, the minimum territory radius of the Flamer will be overriden from 75m."], false],
		["SLIDER:RADIUS", ["Flamer Territory", "Radius in meters of the Flamer's territory."], [1, 1000, 75, 0, _pos, [7, 120, 32, 1]]], 
		["SLIDER:PERCENT", ["Flamer Damage", "Percentage amount of damage the Flamer does to its target. Recommended to start from low and gradually increase to your preferred range."], [0.01, 1, 0.4, 2]], 
		["TOOLBOX:YESNO", ["AI Panic", "If true, the AI will forcefully run away from Flamer during its attack."], false],
		["SLIDER", ["Flamer Recharge Delay", "Delay in seconds between Flamer's attacks. Recommended to keep lower values."], [1, 60, 1, 0]], 
		["SLIDER:PERCENT", ["Flamer Damage on Death", "Percentage amount of damage the Flamer does to the surrounding when it dies."], [0.01, 1, 1, 2]]
		], {
			params ["_results", "_flamerMarkerName"];
			_results params ["_flamer_hp", "_territory_override", "_flamer_territory", "_flamer_damage", "_isaipanic", "_flamer_recharge", "_damage_on_death"];

			if !(_territory_override) then {
				if (_flamer_territory < 75) then {
					_flamer_territory = 75;
				};
			};
			
			["Flamer Anomaly Configured and Created!"] call zen_common_fnc_showMessage;
			
			[[_flamerMarkerName, _flamer_territory, _flamer_damage, _flamer_recharge, round _flamer_hp, _damage_on_death, _isaipanic], "..\scripts\Flamer\flamer_main.sqf"] remoteExec ["BIS_fnc_execVM", 0];
		}, {
			["Aborted"] call zen_common_fnc_showMessage;
			playSound "FD_Start_F";
	}, _flamerMarkerName] call zen_dialog_fnc_create;

}, "\a3\modules_f\data\portraitmodule_ca.paa"] call zen_custom_modules_fnc_register;








["Root's Anomalies", "Screamer Anomaly", {

	params ["_posASL", "_attachedObject"];

	if (isNil "SCREAMER_markerIndex") then { SCREAMER_markerIndex = 0 };
	_screamermarkerName = format ["SCREAMER_%1", SCREAMER_markerIndex];
	SCREAMER_markerIndex = SCREAMER_markerIndex + 1;
	_screamermarker = createMarker [_screamermarkerName, _posASL];

	private _radiuspos = ASLToATL _posASL;

	

	["Screamer Anomaly Settings", [
		["SIDES", ["Screamer Side", "Specifies the side the Screamer will spawn as. If multiple selected, only the first side is chosen as spawn. Defaults to CIVILIAN. Only required when 'AI Engage' is active."], []],
		["SIDES", ["Screamer Targets", "Specifies the side(s) the Screamer will consider hostile. If none are selected, it will attack everyone and everything."], []],
		["EDIT", ["Screamer Model", "Classname of the object used as the Anomaly."], ["Land_AncientStatue_01_F"]],
		["SLIDER", ["Screamer Health", "Percentage amount of health the Screamer has."], [10, 5000, 400, 0]],
		["SLIDER:RADIUS", ["Screamer Territory", "Radius in meters of the Screamer's territory."], [20, 500, 100, 0, _radiuspos, [7, 120, 32, 1]]], 
		["SLIDER:RADIUS", ["Screamer Effect Radius", "Radius in meters of the Screamer's attack."], [10, 490, 50, 0, _radiuspos, [7, 120, 32, 1]]], 
		["TOOLBOX:YESNO", ["Affect Vehicles", "If true, the Screamer will also affect vehicles in its scream path."], true],
		["TOOLBOX:YESNO", ["AI Engage [EXPERIMENTAL]", "If true, the Screamer will be engaged by AI. [NOTE - If the Screamer Model is a static model, a bright visible VR soldier would additionally be created for this purpose.]"], false],
		["TOOLBOX:YESNO", ["AI Panic", "If true, the AI will forcefully run away from Screamer location during its attack."], false],
		["SLIDER:PERCENT", ["Screamer Damage (Close)", "Percentage amount of damage the Screamer does to hostiles at close range."], [0.01, 1, 0.4, 2]],
		["SLIDER:PERCENT", ["Screamer Damage (Medium)", "Percentage amount of damage the Screamer does to hostiles at mid range."], [0.01, 1, 0.2, 2]],
		["SLIDER:PERCENT", ["Screamer Damage (Far)", "Percentage amount of damage the Screamer does to hostiles at far ranges."], [0.01, 1, 0.1, 2]]
		], {
			params ["_results", "_screamermarkerName"];
			_results params ["_screamer_spawn_side", "_screamer_hostiles", "_screamer_model", "_screamer_health", "_screamer_territory", "_screamer_atk_radius", "_isvicdmg", "_isaidmg", "_isaipanic", "_screamer_damage_close", "_screamer_damage_medium", "_screamer_damage_far"];

			if (_screamer_hostiles isEqualTo []) then {
				_screamer_hostiles = ["WEST", "EAST", "RESISTANCE", "CIVILIAN"];
			};

			if (_isaidmg) then {
				if (_screamer_spawn_side isEqualTo []) then {
					_screamer_spawn_side = east;
				} else {
					_screamer_spawn_side = _screamer_spawn_side select 0;
				};
			} else {
				_screamer_spawn_side = east;
			};
			
			if (_screamer_atk_radius > (_screamer_territory / 2)) then {
				_screamer_atk_radius = (_screamer_territory / 2);
			};

			if (_screamer_territory < (_screamer_atk_radius * 2)) then {
				_screamer_territory = (_screamer_atk_radius * 2);
			};
			
			["Screamer Anomaly configured and active!"] call zen_common_fnc_showMessage;

			[[_screamermarkerName, _screamer_model, _screamer_damage_close, _screamer_damage_medium, _screamer_damage_far, _screamer_territory, _screamer_hostiles, _screamer_atk_radius, _isvicdmg, _isaidmg, _isaipanic, _screamer_spawn_side, _screamer_health], "..\scripts\screamer_main.sqf"] remoteExec ["BIS_fnc_execVM", 0];
		}, {
			["Aborted"] call zen_common_fnc_showMessage;
			playSound "FD_Start_F";
		}, _screamermarkerName] call zen_dialog_fnc_create;
}, "\a3\modules_f\data\portraitmodule_ca.paa"] call zen_custom_modules_fnc_register;














["Root's Anomalies", "Smuggler Anomaly", {

	params ["_posASL", "_attachedObject"];

	if (isNil "SMUGGLER_markerIndex") then { SMUGGLER_markerIndex = 0 };

	_smugglerMarkerName = format ["SMUGGLER_%1", SMUGGLER_markerIndex];
	SMUGGLER_markerIndex = SMUGGLER_markerIndex + 1;
	_smugglermarker = createMarker [_smugglerMarkerName, _posASL];
	

	["Smuggler Anomaly Settings", [
		["TOOLBOX:YESNO", ["Enable Roaming Smuggler", "If true, the Smuggler to teleport to random position every 30 seconds around the marker area."], false],
		["TOOLBOX:YESNO", ["Enable Detection Device", "If true, the Smuggler will be invisible and can only be detected with a detection device configured below."], true],
		["TOOLBOX:YESNO", ["Enable Teleport Protection", "If true, the Smuggler will not attack and teleport anyone wearing the protection device configured below."], true],
		["TOOLBOX:YESNO", ["Disable Object Spawning", "If true, the Smuggler will disable spawning in random objects and entites including custom AI/Vehicles/Things configured below in random."], false],
		["EDIT", ["Detection Device", "Class Names of the Detection Device. Can be the same item as Protection Device."], ["MineDetector"]],
		["EDIT", ["Protection Device", "Class Names of the Protection Device. Can be the same item as Detection Device."], ["B_Kitbag_mcamo"]],
		["EDIT:MULTI", ["Spawn Objects Allowed", "Comma (,) seperated classnames (without spaces) of the objects/entities."], ["Land_OfficeCabinet_01_F,Land_ArmChair_01_F,OfficeTable_01_old_F,B_G_Soldier_AR_F,B_GEN_Soldier_F,C_man_1,Weapon_arifle_AKM_F,Weapon_launch_RPG7_F,I_C_Soldier_Bandit_5_F,O_Soldier_GL_F", {}, 4]],
		["SLIDER", ["Spawn Objects Delay", "Addtional delay in seconds between spawning random objects. Minimum delay is set to 10 seconds. For example, if this value is set to 15, actual delay between spawning entites would be 25 seconds. (10 + 15)"], [0, 600, 10, 0]],
		["SLIDER:PERCENT", ["Smuggler Damage", "Percentage amount of damage the Smuggler does per teleportation. '0' means no damage taken when teleported."], [0, 1, 0.1, 2]],
		["TOOLBOX:YESNO", ["Disable Sensitive Lights", "If true, Bright lights will be disabled during teleportation. Highly recommended for people with sensitivity to lights."], false]
		], {
			params ["_results", "_smugglerMarkerName"];
			_results params ["_isroaming", "_isdetectable", "_isprotectable", "_isspawning", "_detectdevice", "_protectdevice", "_spawnobjects", "_spawnobjectsdelay", "_dmg_on_teleport", "_noseizure"];

			if !(_isdetectable) then {_detectdevice = ""};
			if !(_isprotectable) then {_protectdevice = ""};
			if !(_isspawning) then {_spawnobjects = "[]"} else {
				_spawnobjects = _spawnobjects splitString ",";
			};

			["Smuggler Anomaly Configured and Created!"] call zen_common_fnc_showMessage;

			[[_smugglerMarkerName, _isroaming, _detectdevice, _spawnobjects, _spawnobjectsdelay, _protectdevice, _dmg_on_teleport, _noseizure], "..\scripts\smuggler_main.sqf"] remoteExec ["BIS_fnc_execVM", 0];
		}, {
			["Aborted"] call zen_common_fnc_showMessage;
			playSound "FD_Start_F";
		}, _smugglerMarkerName] call zen_dialog_fnc_create;
}, "\a3\modules_f\data\portraitmodule_ca.paa"] call zen_custom_modules_fnc_register;















["Root's Anomalies", "Steamer Anomaly", {

	params ["_posASL", "_attachedObject"];

	private _radiuspos = ASLToATL _posASL;

	if (isNil "STEAMER_markerIndex") then { STEAMER_markerIndex = 0 };

	_steamerMarkerName = format ["STEAMER_%1",  STEAMER_markerIndex];
	STEAMER_markerIndex = STEAMER_markerIndex + 1;
	_steamermarker = createMarker [_steamerMarkerName,  _posASL];
	

	["Steamer Anomaly Settings", [
		["TOOLBOX:YESNO", ["Override Minimum Territory", "If true, the minimum territory radius of the Steamer will be overriden from 75m."], false],
		["SLIDER:RADIUS", ["Steamer Territory", "Radius in meters of the Steamer's territory."], [10, 1000, 75, 0, _radiuspos, [7, 120, 32, 1]]],
		["SLIDER:PERCENT", ["Steamer Damage", "Percentage amount of damage the Steamer does to his target."], [0.01, 1, 0.2, 2]],
		["SLIDER", ["Steamer Recharge Delay", "Delay in seconds between Steamer's attacks."], [5, 60, 10, 0]],
		["SLIDER:PERCENT", ["Steamer Damage on Death", "Percentage amount of damage the Steamer does upon death."], [0.01, 1, 0.6, 2]],
		["TOOLBOX:YESNO", ["Enable Travel Path", "If true, the Steamer's location will be easier to identify/pinpoint as it will generate a line of dug up mud towards its target."], false]
		], {
			params ["_results", "_steamerMarkerName"];
			_results params ["_territory_override", "_steamer_territory", "_steamer_damage", "_steamer_recharge", "_dmg_on_death", "_travelpath"];

			if !(_territory_override) then {
				if (_steamer_territory < 75) then {
					_steamer_territory = 75;
				};
			};
			
			["Steamer Anomaly Configured and Created!"] call zen_common_fnc_showMessage;

			[[_steamerMarkerName, _steamer_territory, _steamer_damage, _steamer_recharge, _dmg_on_death, _travelpath], "..\scripts\steamer_main.sqf"] remoteExec ["BIS_fnc_execVM", 0];
		}, {
			["Aborted"] call zen_common_fnc_showMessage;
			playSound "FD_Start_F";
		},  _steamerMarkerName] call zen_dialog_fnc_create;
}, "\a3\modules_f\data\portraitmodule_ca.paa"] call zen_custom_modules_fnc_register;














["Root's Anomalies", "Swarmer Anomaly", {

	params ["_posASL", "_attachedObject"];

	private _swarmerloc = ASLToATL _posASL;
	

	["Swarmer Anomaly Settings", [
		["EDIT", ["Swarmer Hive Object", "Classname of the object used to spawn the Swarmer."], ["Land_GarbageBags_F"]], 
		["TOOLBOX:YESNO", ["Override Minimum Territory", "If true, the minimum territory radius of the Swarmer will be overriden from 75m."], false],
		["SLIDER:RADIUS", ["Swarmer Territory", "Radius in meters of the Swarmer's territory."], [1, 1000, 75, 0, _swarmerloc, [7, 120, 32, 1]]], 
		["TOOLBOX:YESNO", ["Disable Pesticide", "If true, Pesticide will be disabled and the Swarmer cannot be killed conventionally."], false],
		["EDIT", ["Pesticide", "Classname of the THROWABLE OBJECT (Grenades, Smokes, etc.) used to kill the Swarmer."], ["SmokeShellGreen"]], 
		["SLIDER:PERCENT", ["Swarmer Damage", "Percentage amount of damage the Swarmer does to his target."], [0.01, 1, 0.6, 2]]
		], {
			params ["_results", "_swarmerloc"];
			_results params ["_swarmerobject", "_territory_override", "_swarmer_territory", "_needpesticide", "_pesticideobject", "_swarmerdamage"];
			private _swarmerhive = "Land_GarbageBags_F";

			if (getNumber (configFile >> "CfgVehicles" >> _swarmerobject >> "scope") > 0) then {
				_swarmerhive = _swarmerobject createVehicle _swarmerloc;
			} else {
				_swarmerhive = "Land_GarbageBags_F" createVehicle _swarmerloc;
			};

			if (getNumber (configFile >> "CfgVehicles" >> _pesticideobject >> "scope") > 0) then {
				_pesticideobject = _pesticideobject;
			} else {
				if !(_nopesticide) then { _pesticideobject = "SmokeShellGreen"; };
			};

			if !(_territory_override) then {
				if (_swarmer_territory < 75) then {
					_swarmer_territory = 75;
				};
			};

			["Swarmer Anomaly configured and active!"] call zen_common_fnc_showMessage;

			[[_swarmerhive, _swarmer_territory, _pesticideobject, _swarmerdamage], "..\scripts\swarmer_main.sqf"] remoteExec ["BIS_fnc_execVM", 0];
		}, {
			["Aborted"] call zen_common_fnc_showMessage;
			playSound "FD_Start_F";
		}, _swarmerloc] call zen_dialog_fnc_create;
}, "\a3\modules_f\data\portraitmodule_ca.paa"] call zen_custom_modules_fnc_register;

















["Root's Anomalies", "Strigoi Anomaly", {

	params ["_posASL", "_attachedObject"];

	private _radiuspos = ASLToATL _posASL;

	if (isNil "STRIGOI_markerIndex") then { STRIGOI_markerIndex = 0 };

	_strigoiMarkerName = format ["STRIGOI_%1", STRIGOI_markerIndex];
	STRIGOI_markerIndex = STRIGOI_markerIndex + 1;
	_strigoimarker = createMarker [_strigoiMarkerName, _posASL];
	


	["Strigoi Anomaly Settings", [
		["SLIDER", ["Strigoi Health", "Amount of damage the Strigoi takes before being killed."], [10, 5000, 400, 0]],
		["TOOLBOX:YESNO", ["Override Minimum Territory", "If true, the minimum territory radius of the Strigoi will be overriden from 75m."], false],
		["SLIDER:RADIUS", ["Strigoi Territory", "Radius in meters of the Strigoi's territory."], [10, 1000, 75, 0, _radiuspos, [7, 120, 32, 1]]],
		["SLIDER:PERCENT", ["Strigoi Damage", "Percentage amount of damage the Strigoi does to his target."], [0.01, 1, 0.6, 2]],
		["TOOLBOX:YESNO", ["AI Panic", "If true, the AI will forcefully run away from Flamer during its attack."], false],
		["TOOLBOX:YESNO", ["Night Mode Only", "If true, Strigoi will only be active/spawned during night time."], false],
		["TOOLBOX:YESNO", ["Disable Sensitive Lights", "If true, Strigoi's 'seizure' like ability will be disabled preventing bright lights from flashing. Highly recommended for people with sensitivity to lights."], false]
		], {
			params ["_results", "_strigoiMarkerName"];
			_results params ["_strigoi_hp", "_territory_override", "_strigoi_territory", "_strigoi_damage", "_isaipanic", "_isnightonly", "_noseizure"];

			if !(_territory_override) then {
				if (_strigoi_territory < 75) then {
					_strigoi_territory = 75;
				};
			};

			["Strigoi Anomaly Configured and Created!"] call zen_common_fnc_showMessage;

			[[_strigoiMarkerName, _strigoi_territory, _isnightonly, _strigoi_damage, round _strigoi_hp, _noseizure, _isaipanic], "..\scripts\strigoi_main.sqf"] remoteExec ["BIS_fnc_execVM", 0];

		}, {
			["Aborted"] call zen_common_fnc_showMessage;
			playSound "FD_Start_F";
		}, _strigoiMarkerName] call zen_dialog_fnc_create;
}, "\a3\modules_f\data\portraitmodule_ca.paa"] call zen_custom_modules_fnc_register;




















["Root's Anomalies", "Twins Anomaly", {


	params ["_posASL", "_attachedObject"];

	private _trackpos = ASLToATL _posASL;
	private _killpos = ASLToATL _posASL;
	private _objpos = ASLToATL _posASL;
	

	["Twins Anomaly Settings", [
		["EDIT", ["Twins Object", "Classname of the object used as the Twins."], ["Land_HighVoltageTower_large_F"]],
		["EDIT", ["Twins Heart", "Classname of the object used as the 'Heart' of the Twins Anomaly to kill it."], ["B_UAV_06_F"]],
		["SLIDER:RADIUS", ["Tracking Distance", "Radius in meters of the Twin's territory to track and chase entites."], [15, 1200, 100, 0, _trackpos, [7, 120, 32, 1]]],
		["TOOLBOX:YESNO", ["Enable Electric Sparks", "If true, the Twins will emit electric sparks randomly."], true],
		["SLIDER:RADIUS", ["Damage Range", "Radius in meters of the Twin's territory for it to damage and disorient entities."], [10, 1000, 75, 0, _killpos, [7, 120, 32, 1]]],
		["TOOLBOX:YESNO", ["Enable Effects on AI", "If true, all properties will be applicable to AI entities too."], true],
		["TOOLBOX:YESNO", ["Enable EMP", "If true, the Twins will emit an 'EMP' when killed."], true],
		["TOOLBOX:YESNO", ["Disable Sensitive Lights", "If true, Strigoi's 'seizure' like ability will be disabled preventing bright lights from flashing. Highly recommended for people with sensitivity to lights."], false]
		], {
			params ["_results", "_objpos"];
			_results params ["_anomaly_obj", "_heart_obj", "_tracking_dist", "_issparks", "_damage_range", "_isai", "_isemp", "_isseizure"];
			private ["_heart_obj", "_twins_obj"];

			if !(getNumber (configFile >> "CfgVehicles" >> _heart_obj >> "scope") > 0) then {
				_heart_obj = "B_UAV_06_F";
			};

			if !(getNumber (configFile >> "CfgVehicles" >> _twins_obj >> "scope") > 0) then {
				_twins_obj = "Land_HighVoltageTower_large_F";
			};

			if (_tracking_dist < _damage_range) then {
				_tracking_dist = _damage_range + 20;
			};

			["Twins Anomaly Configured and Created!"] call zen_common_fnc_showMessage;
			
			_twins_obj = _anomaly_obj createVehicle _objpos;

			[[_twins_obj, _tracking_dist, _issparks, _damage_range, _isai, _isemp, _heart_obj, _isseizure], "..\scripts\twins_main.sqf"] remoteExec ["BIS_fnc_execVM", 0];
		}, {
			["Aborted"] call zen_common_fnc_showMessage;
			playSound "FD_Start_F";
		}, _objpos] call zen_dialog_fnc_create;
}, "\a3\modules_f\data\portraitmodule_ca.paa"] call zen_custom_modules_fnc_register;


















["Root's Anomalies", "Worm Anomaly", {


	params ["_posASL", "_attachedObject"];

	if (isNil "WORM_markerIndex") then { WORM_markerIndex = 0 };
	_wormmarkerName = format ["WORM_%1", WORM_markerIndex];
	WORM_markerIndex = WORM_markerIndex + 1;
	_wormmarker = createMarker [_wormmarkerName, _posASL];

	private _radiuspos = ASLToATL _posASL;

	


	["Worm Anomaly Settings", [
		["TOOLBOX:YESNO", ["Override Minimum Territory", "If true, the minimum territory radius of the Worm will be overriden from 200m."], false],
		["SLIDER:RADIUS", ["Worm Territory", "Radius in meters of the Worm's territory."], [50, 1000, 200, 0, _radiuspos, [7, 120, 32, 1]]], 
		["TOOLBOX:YESNO", ["AI Panic", "If true, the AI will run away from the Worm and its territory during its attack."], false],
		["EDIT", ["Worm Diffuser", "Classname of the object used to kill the Worm."], ["SmokeShellGreen"]], 
		["SLIDER:PERCENT", ["Worm Damage", "Percentage amount of damage the Worm does to its target."], [0.01, 1, 0.6, 2]]
		], {
			params ["_results", "_wormmarkerName"];
			_results params ["_override_territory", "_worm_territory", "_isaipanic", "_wormdiffuser", "_worm_damage"];

			if (!(_override_territory) && (_worm_territory < 200)) then {
				_worm_territory = 200;
			};

			if (getNumber (configFile >> "CfgVehicles" >> _wormdiffuser >> "scope") > 0) then 
			{
				_wormdiffuser = _wormdiffuser;
			} else 
			{
				_wormdiffuser = "SmokeShellGreen";
			};

			["Worm Anomaly configured and active!"] call zen_common_fnc_showMessage;

			[[_wormmarkerName, _worm_damage, _worm_territory, _isaipanic, _wormdiffuser], "..\scripts\worm_main.sqf"] remoteExec ["BIS_fnc_execVM", 0];
		}, {
			["Aborted"] call zen_common_fnc_showMessage;
			playSound "FD_Start_F";
		}, _wormmarkerName] call zen_dialog_fnc_create;
}, "\a3\modules_f\data\portraitmodule_ca.paa"] call zen_custom_modules_fnc_register;




*/