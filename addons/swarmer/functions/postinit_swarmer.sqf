
 

[] spawn {
	waitUntil {!isNil "insecticid"};
    player addEventHandler ["Fired", {
		params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
		if (typeOf _projectile == insecticid) then {
			[_projectile, "\z\root_anomalies\addons\swarmer\functions\swarmer_kill_hive.sqf"] remoteExec ["execVM"];
		};
	}];
};

