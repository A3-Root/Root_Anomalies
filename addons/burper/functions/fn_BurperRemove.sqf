#include "\z\root_anomalies\addons\burper\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Killswitch loop - if the killswitch device lingers within range, the
 *              Burper is neutralized and destroyed.
 *
 * Arguments:
 * 0: Anomaly object <OBJECT>
 * 1: Killswitch device classname <STRING>
 * 2: Killswitch range <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params ["_obj", ["_killDevice", "", [""]], ["_killRange", 20, [0]]];

if (_killDevice == "") exitWith {};

private _taskTime = 0;
private _devices = [];

while {(alive _obj) && (_taskTime < 7)} do {
    _devices = nearestObjects [position _obj, [_killDevice], _killRange, false];
    if (_devices isNotEqualTo []) then {
        _taskTime = _taskTime + 1;
        [_obj] remoteExec ["Root_fnc_BurperDisable", [0, -2] select isDedicated];
    } else {
        _taskTime = 0;
    };
    uiSleep 5;
};

if (!alive _obj) exitWith {};

[_obj] remoteExec ["Root_fnc_BurperBlast", [0, -2] select isDedicated];
["charge_b"] remoteExec ["playSound", [0, -2] select isDedicated];
_obj setVariable [QGVAR(active), false, true];
uiSleep 1;
deleteVehicle _obj;
{_x setDamage 1} forEach _devices;
uiSleep 1.5;
["puls_bass"] remoteExec ["playSound", [0, -2] select isDedicated];
