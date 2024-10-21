
 
params ["_grenade_insect"];

if (typeOf _grenade_insect == insecticid) then {
	[_grenade_insect, "\z\root_anomalies\addons\swarmer\functions\swarmer_kill_hive.sqf"] remoteExec ["execVM"];
};