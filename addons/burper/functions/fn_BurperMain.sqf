#include "\z\root_anomalies\addons\burper\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server backend that spawns and runs a Burper anomaly. Shared by both
 *              the Zeus (ZEN) and 3DEN front-ends.
 *
 * Arguments:
 * 0: Marker name <STRING>
 * 1: Roaming <BOOL>
 * 2: Detection device classname ("" disables detection) <STRING>
 * 3: Protection device classname ("" disables protection) <STRING>
 * 4: Killswitch device classname ("" disables killswitch) <STRING>
 * 5: Territory radius <NUMBER>
 * 6: Affect vehicles <BOOL>
 * 7: Killswitch range <NUMBER>
 * 8: AI panic <BOOL>
 *
 * Return Value:
 * Anomaly object <OBJECT>
 *
 * Public: No
 */

if (!isServer) exitWith {objNull};

params [
    ["_marker", "", [""]],
    ["_roaming", false, [false]],
    ["_detector", "", [""]],
    ["_protector", "", [""]],
    ["_killDevice", "", [""]],
    ["_radius", 10, [0]],
    ["_vehicleAllowed", true, [false]],
    ["_killRange", 20, [0]],
    ["_aiPanic", true, [false]]
];

private _pos = getMarkerPos _marker;
private _obj = "Land_HelipadEmpty_F" createVehicle [_pos select 0, _pos select 1, 2];

private _blood = createVehicle ["BloodSplatter_01_Medium_New_F", [_pos select 0, _pos select 1, 0], [], random 8, "CAN_COLLIDE"];
_blood setDir (random 360);

// Persist configuration on the anomaly object (public so all clients can read).
_obj setVariable [QGVAR(detect), _detector != "", true];
_obj setVariable [QGVAR(detector), _detector, true];
_obj setVariable [QGVAR(protector), _protector, true];
_obj setVariable [QGVAR(killDevice), _killDevice, true];
_obj setVariable [QGVAR(active), true, true];

LOG_DEBUG_2("BurperMain spawned at %1 (radius %2)",_pos,_radius);

if (_killDevice != "") then {
    [_obj, _killDevice, _killRange] spawn root_anomalies_burper_fnc_BurperRemove;
};

if (_detector != "") then {
    if (_aiPanic) then {
        [_obj] spawn root_anomalies_burper_fnc_BurperAI;
    };
} else {
    if (_aiPanic) then {
        [_obj] spawn root_anomalies_burper_fnc_BurperViz;
    };
};

[_obj, _radius, _vehicleAllowed] spawn root_anomalies_burper_fnc_BurperTrap;
[_obj] remoteExec ["root_anomalies_burper_fnc_BurperSfx", [0, -2] select isDedicated, true];

if (_roaming) then {
    [_obj] spawn {
        params ["_obj"];
        while {alive _obj} do {
            private _cur = getPosATL _obj;
            private _new = [_cur, 0.1, 1, 1, 0, -1, 0] call BIS_fnc_findSafePos;
            _obj setPosATL [_new select 0, _new select 1, _cur select 2];
            uiSleep (60 + random 60);
        };
    };
};

_obj
