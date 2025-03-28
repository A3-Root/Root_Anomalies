params ["_object_anom_burp", "_anti_burper_device", "_kill_range"];

private "_device_anti_burp";

waitUntil {
	uiSleep 1;
	!isNil "anti_burper";
};

_task_time = 0;

_object_anom_burp setVariable ["burper_activ", true, true];

while {(alive _object_anom_burp) && (_task_time < 7)} do {
	_device_anti_burp = nearestObjects [position _object_anom_burp, [anti_burper], _kill_range, false];
	if (count _device_anti_burp > 0) then {
		_task_time = _task_time + 1;
		[_object_anom_burp] remoteExec ["Root_fnc_BurperDisable", [0, -2] select isDedicated];
	} else {
		_task_time = 0;
	};
	uiSleep 5;
};

[_object_anom_burp] remoteExec ["Root_fnc_BurperBlast", [0, -2] select isDedicated];
["charge_b"] remoteExec ["playSound", [0, -2] select isDedicated];
_object_anom_burp setVariable ["burper_activ", false, true];
uiSleep 1;
deleteVehicle _object_anom_burp;
{_x setDamage 1} forEach _device_anti_burp;
uiSleep 1.5;
["puls_bass"] remoteExec ["playSound", [0, -2] select isDedicated];