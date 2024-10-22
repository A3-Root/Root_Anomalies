
 

if (!isServer) exitWith {};

params ["_gren"];

while {alive _gren} do {
	_ck_hiv = (position _gren) nearEntities ["CAManBase", 7];
	if (count _ck_hiv > 0) then {
		{
			if (!isNil{_x getVariable "isHive"}) then {
				uiSleep 1;
				_x setDamage 1;
				[[_x], "\z\root_anomalies\addons\swarmer\functions\swarmer_dead_SFX.sqf"] remoteExec ["execVM"];
			};
		} forEach _ck_hiv;
	};
	uiSleep 2;
}

_cleanup = nearestObjects [_gren, ["BloodPool_01_Large_NewF", "BloodSplatter_01_Large_New_F"], 150];
private "_lastbloodpos";
{
	_lastbloodpos = getPosATL _x;
	deleteVehicle _x;
	uiSleep 1;
} forEach _cleanup;
_bloodpool = createVehicle [selectRandom["BloodPool_01_Large_New_F", "BloodSplatter_01_Large_New_F"], [0, 0, 0], [], 0, "CAN_COLLIDE"];
_bloodpool setPosATL _lastbloodpos;