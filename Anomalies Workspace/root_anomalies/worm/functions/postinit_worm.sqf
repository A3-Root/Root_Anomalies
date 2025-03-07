
 

[] spawn {
	waitUntil {!isNil "wormkiller"};
    player addEventHandler ["Fired", {
		params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
		if (typeOf _projectile == wormkiller) then {
			[_projectile, false] remoteExec ["Root_fnc_WormKill", 2];
		};
	}];
};

