if (!isServer) exitWith {};

private ["_markern", "_nm", "_object_anom_burp", "_markerstr"];

params ["_marker_anom_burp", "_mobile_anomaly", "_device_detector", "_damage_protect", "_anti_burper_device", "_burper_radius", "_vehicle_allowed", "_killrange", "_isaipanic"];

_object_anom_burp = "Land_HelipadEmpty_F" createVehicle [getMarkerPos _marker_anom_burp select 0, getMarkerPos _marker_anom_burp select 1, 2];
_balta_sang = createVehicle ["BloodSplatter_01_Medium_New_F", [getMarkerPos _marker_anom_burp select 0, getMarkerPos _marker_anom_burp select 1, 0], [], random 8, "CAN_COLLIDE"];
_balta_sang setDir (random 360);

if (_anti_burper_device	!= "") then {
	anti_burper = _anti_burper_device; publicVariable "anti_burper";
	[_object_anom_burp, _anti_burper_device, _killrange] spawn Root_fnc_BurperRemove;
};

if (_device_detector != "") then {
	detection_smugg = true; publicVariable "detection_smugg";
	detectiv_tool = _device_detector; publicVariable "detectiv_tool";
	if (_isaipanic) then {
		[_object_anom_burp] spawn Root_fnc_BurperAI;
	};
} else {
	detection_smugg = false; publicVariable "detection_smugg";
	if (_isaipanic) then {
		[_object_anom_burp] spawn Root_fnc_BurperViz;
	};
};

if (_damage_protect != "") then {obj_prot_burper = _damage_protect; publicVariable "obj_prot_burper"};

[_object_anom_burp, _burper_radius, _vehicle_allowed, _anti_burper_device] spawn Root_fnc_BurperTrap;
[_object_anom_burp] remoteExec ["Root_fnc_BurperSfx", [0, -2] select isDedicated, true];

if (_mobile_anomaly) then {
	while {alive _object_anom_burp} do 
	{
		_poz_ini_burp = getPosATL _object_anom_burp;
		_new_poz = [_poz_ini_burp, 0.1, 1, 1, 0, -1, 0] call BIS_fnc_findSafePos;
		_object_anom_burp setPos [_new_poz select 0, _new_poz select 1, _poz_ini_burp select 2];
		uiSleep 60 + random 60;
	};
};