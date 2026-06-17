#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server backend that spawns and runs a Smuggler anomaly: an invisible
 *              entity that teleports nearby units/vehicles and randomly conjures objects.
 *
 * Arguments:
 * 0: Marker name <STRING>
 * 1: Roaming <BOOL>
 * 2: Detection device classname ("" disables detection) <STRING>
 * 3: Spawn classnames <ARRAY of STRING>
 * 4: Spawn delay <NUMBER>
 * 5: Protection device classname ("" disables protection) <STRING>
 * 6: Teleport damage fraction <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params [
    ["_marker", "", [""]],
    ["_roaming", false, [false]],
    ["_detector", "", [""]],
    ["_spawnList", [], [[]]],
    ["_spawnDelay", 10, [0]],
    ["_protector", "", [""]],
    ["_damage", 0.1, [0]],
    ["_config", createHashMap, [createHashMap]]
];

private _pos = getMarkerPos _marker;
private _source = createVehicle ["Land_HelipadEmpty_F", [_pos select 0, _pos select 1, 2], [], 0, "CAN_COLLIDE"];
private _core = createVehicle ["Land_HelipadEmpty_F", [_pos select 0, _pos select 1, 2], [], 0, "CAN_COLLIDE"];
_core attachTo [_source, [0, 0, 0]];

_source setVariable [QGVAR(protector), _protector, true];
_source setVariable [QGVAR(detector), _detector, true];

if (_detector != "") then {
    [_source] spawn FUNC(SmugglerAIAvoid);
} else {
    [_source] spawn FUNC(SmugglerAIVisible);
};

[_source, _core] remoteExec [QFUNC(SmugglerSfx), [0, -2] select isDedicated, true];
[_source, _core, _damage] remoteExec [QFUNC(SmugglerTeleport), [0, -2] select isDedicated, true];

_source setVariable [QGVAR(extraDelete), [_core], true];
[_source, _config] call EFUNC(main,finalizeInstance);

LOG_DEBUG_1("SmugglerMain spawned at %1",_pos);

if (_spawnList isNotEqualTo []) then {
    if (_spawnDelay <= 0) then {_spawnDelay = 10};
    [_spawnList, _core, _spawnDelay, _source] spawn FUNC(SmugglerSpawn);
};

if (_roaming) then {
    while {!isNull _source && {!(_source getVariable [EGVAR(main,terminate), false])}} do {
        private _cur = getPosATL _source;
        private _new = [_cur, 0.01, 0.3, 1, 0, -1, 0] call BIS_fnc_findSafePos;
        _source setPos [_new select 0, _new select 1, _cur select 2];
        uiSleep (3 + random 30);
    };
};
