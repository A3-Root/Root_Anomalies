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
 * 7: Seizure-safe <BOOL>
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
    ["_noseize", false, [false]]
];

private _pos = getMarkerPos _marker;
private _sursa = createVehicle ["Land_HelipadEmpty_F", [_pos select 0, _pos select 1, 2], [], 0, "CAN_COLLIDE"];
private _core = createVehicle ["Land_HelipadEmpty_F", [_pos select 0, _pos select 1, 2], [], 0, "CAN_COLLIDE"];
_core attachTo [_sursa, [0, 0, 0]];

_sursa setVariable [QGVAR(protector), _protector, true];
_sursa setVariable [QGVAR(detector), _detector, true];

if (_detector != "") then {
    [_sursa] spawn root_anomalies_smuggler_fnc_SmugglerAIAvoid;
} else {
    [_sursa] spawn root_anomalies_smuggler_fnc_SmugglerAIVisible;
};

[_sursa, _core] remoteExec ["root_anomalies_smuggler_fnc_SmugglerSfx", [0, -2] select isDedicated, true];
[_sursa, _core, _damage, _noseize] remoteExec ["root_anomalies_smuggler_fnc_SmugglerTeleport", [0, -2] select isDedicated, true];

LOG_DEBUG_1("SmugglerMain spawned at %1",_pos);

if (_spawnList isNotEqualTo []) then {
    if (_spawnDelay <= 0) then {_spawnDelay = 10};
    [_spawnList, _core, _spawnDelay] spawn root_anomalies_smuggler_fnc_SmugglerSpawn;
};

if (_roaming) then {
    while {!isNull _sursa} do {
        private _cur = getPosATL _sursa;
        private _new = [_cur, 0.01, 0.3, 1, 0, -1, 0] call BIS_fnc_findSafePos;
        _sursa setPos [_new select 0, _new select 1, _cur select 2];
        uiSleep (3 + random 30);
    };
};
