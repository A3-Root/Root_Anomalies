// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!isServer) exitWith {};

params ["_wormkillerobj"];

while {alive _wormkillerobj} do 
{
	_near_worm = nearestObjects [(position _wormkillerobj), [], 10];
	if (count _near_worm >0) then 
	{
		{
			if (!isNil{_x getVariable "isWorm"}) then 
			{
				uiSleep 4; 
				deleteVehicle _x; 
			};
			if (typeOf _x == "land_CanOpener_F") then { deleteVehicle _x; };
		} forEach _near_worm;
	};
	uiSleep 2;
}