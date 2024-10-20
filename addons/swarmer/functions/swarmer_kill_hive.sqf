// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!isServer) exitWith {};

params ["_gren"];

while {alive _gren} do 
{
	_ck_hiv = (position _gren) nearEntities ["CAManBase", 7];
	if (count _ck_hiv >0) then 
	{
		{
			if (!isNil{_x getVariable "isHive"}) then 
			{
				uiSleep 1;
				_x setDamage 1; 
				[[_x],"\z\root_anomalies\addons\swarmer\functions\swarmer_dead_SFX.sqf"] remoteExec ["execVM"];
			};
		} forEach _ck_hiv;
	};
	uiSleep 2;
}