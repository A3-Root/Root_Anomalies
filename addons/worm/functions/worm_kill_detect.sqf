
 
params ["_wormkill"];

if (typeOf _wormkill == wormkiller) then 
{
	[_wormkill, "\z\root_anomalies\addons\worm\functions\worm_kill_confirm.sqf"] remoteExec ["execVM"];
};