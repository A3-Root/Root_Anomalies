
 /*
 To manually kill via script, run this as LocalExec:
 ["", true] remoteExec ["Root_fnc_SwarmerKill", 2];
 */

if (!isServer) exitWith {};

params ["_gren", "_forceKill"];


if (_forceKill) then {
	_allObjects = 8 allObjects 1;
	{
		if (!isNil{_x getVariable "isHive"}) then {
			uiSleep 5;
			_x setDamage 1;
			[_x] remoteExec ["Root_fnc_SwarmerDead", [0, -2] select isDedicated];
		};
	} forEach _allObjects;
	uiSleep 2;
} else {
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
};

_cleanup = nearestObjects [_gren, ["BloodPool_01_Large_NewF", "BloodSplatter_01_Large_New_F"], 150];
{
	deleteVehicle _x;
	uiSleep 1;
} forEach _cleanup;
