
 

if (!isServer) exitWith {};

params ["_gren"];

while {alive _gren} do {
	_ck_hiv = (position _gren) nearEntities ["CAManBase", 15];
	if (count _ck_hiv > 0) then {
		{
			if (!isNil{_x getVariable "isHive"}) then {
				uiSleep 5;
				_x setDamage 1;
				[_x] remoteExec ["Root_fnc_SwarmerDead", [0, -2] select isDedicated];
			};
		} forEach _ck_hiv;
	};
	uiSleep 2;
};

_cleanup = nearestObjects [_gren, ["BloodPool_01_Large_NewF", "BloodSplatter_01_Large_New_F"], 150];
{
	deleteVehicle _x;
	uiSleep 1;
} forEach _cleanup;
