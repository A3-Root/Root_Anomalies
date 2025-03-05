_list_units_in_range = [];

_object_burp_damage = _this select 0;
_burper_radius = _this select 1;
_vehicle_allowed = _this select 2;
_anti_burp = _this select 3;

if (isNil "_anti_burp") then {
	_anti_burp = "ANTIBURP-NOT-CONFIGURED";
};

if (!isNil "obj_prot_burper") then {
	while {alive _object_burp_damage} do {
		if (_vehicle_allowed) then {
			_list_units_in_range = (position _object_burp_damage) nearEntities [["Man", "LandVehicle"], _burper_radius];
		} else {
			_list_units_in_range = (position _object_burp_damage) nearEntities ["Man", _burper_radius];
		};

		if (count _list_units_in_range > 0) then {
			{
				if ((typeOf _x == "VirtualCurator_F") or ([_x, obj_prot_burper] call BIS_fnc_hasItem)) then {
				} else {
					_tipat = ["strigat_1", "strigat_2", "strigat_3", "strigat_4", "strigat_5", "strigat_6", "strigat_7", "strigat_8", "strigat_9", "strigat_91", "strigat_92"] call BIS_fnc_selectRandom;
					[_x, [_tipat, 100]] remoteExec ["say3D", 0];
					uiSleep 0.5 + (random 0.5);
					_x setDamage 1;
					_x hideObjectGlobal true;
					if !(_x isKindOf "LandVehicle") then {deleteVehicle _x;};
					_oase = createVehicle ["Land_HumanSkeleton_F", [getPosATL _x select 0, getPosATL _x select 1, 1.5], [], 0, "CAN_COLLIDE"];
					[[_oase], "\z\root_anomalies\addons\burper\functions\burper_splash_damage.sqf"] remoteExec ["execVM", 0];
					_balta_sange = createVehicle ["BloodSplatter_01_Medium_New_F", [getPosATL _x select 0, getPosATL _x select 1, 0], [], 0, "CAN_COLLIDE"];
					_oase setDir random 360;
					_oase setVectorUp [0, -1, 1];
					[_object_burp_damage, ["blood_splash", 100]] remoteExec ["say3D", 0];
					uiSleep 0.3;
					[_balta_sange, ["bones_drop", 100]] remoteExec ["say3D", 0];
				};
			} forEach _list_units_in_range;
		};
		uiSleep 1;
	};
} else {
	while {alive _object_burp_damage} do {
		if (_vehicle_allowed) then {
			_list_units_in_range = (position _object_burp_damage) nearEntities [["Man", "LandVehicle"], _burper_radius];
			} else {
				_list_units_in_range = (position _object_burp_damage) nearEntities ["Man", _burper_radius];
		};
		if (count _list_units_in_range > 0) then {
			{
				if ((typeOf _x != "VirtualCurator_F") or (typeOf _x != _anti_burp)) then {
					_tipat = ["strigat_1", "strigat_2", "strigat_3", "strigat_4", "strigat_5", "strigat_6", "strigat_7", "strigat_8", "strigat_9", "strigat_91", "strigat_92"] call BIS_fnc_selectRandom;
					[_x, [_tipat, 100]] remoteExec ["say3D", 0];
					uiSleep 0.5 + (random 0.5);
					_x setDamage 1;
					_x hideObjectGlobal true;
					if !(_x isKindOf "LandVehicle") then {deleteVehicle _x;};
					_oase = createVehicle ["Land_HumanSkeleton_F", [getPosATL _x select 0, getPosATL _x select 1, 1.5], [], 0, "CAN_COLLIDE"];
					[[_oase], "\z\root_anomalies\addons\burper\functions\burper_splash_damage.sqf"] remoteExec ["execVM", 0];
					_balta_sange = createVehicle ["BloodSplatter_01_Medium_New_F", [getPosATL _x select 0, getPosATL _x select 1, 0], [], 0, "CAN_COLLIDE"];
					_oase setVectorUp [0, -1, 1];
					[_object_burp_damage, ["blood_splash", 100]] remoteExec ["say3D", 0];
					uiSleep 0.3;
					[_balta_sange, ["bones_drop", 100]] remoteExec ["say3D", 0];
				};
			} forEach _list_units_in_range;
		};
		uiSleep 1;
	};
};