
/* 
To Kill it via Script: 

["", true] remoteExec ["Root_fnc_WormKill", 2];

*/

if (!isServer) exitWith {};

params ["_wormkillerobj", "_forceKill"];

if (_forceKill) then {
	_allObjects = 8 allObjects 1;
	{
		if (!isNil{_x getVariable "isWorm"}) then {
			uiSleep 4;
			deleteVehicle _x;
		};
		if (typeOf _x == "land_CanOpener_F") then {deleteVehicle _x;};
	} forEach _allObjects;
} else {
	while {alive _wormkillerobj} do {
		_near_worm = nearestObjects [(position _wormkillerobj), [], 15];
		if (count _near_worm > 0) then {
			{
				if (!isNil{_x getVariable "isWorm"}) then {
					uiSleep 4;
					deleteVehicle _x;
				};
				if (typeOf _x == "land_CanOpener_F") then {deleteVehicle _x;};
			} forEach _near_worm;
		};
		uiSleep 2;
	};
};