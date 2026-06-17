#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Shared backend for the Reconfigure modules. Applies a config override to the
 *              anomaly under the given position (within 6m) or, if none, to every anomaly
 *              within the radius. Drivers read their config live, so changes apply at once.
 *
 * Arguments:
 * 0: Centre position (ATL) <ARRAY>
 * 1: Radius (m) <NUMBER>
 * 2: Config override <HASHMAP>
 *
 * Return Value:
 * Count reconfigured <NUMBER>
 *
 * Public: No
 */

if (!isServer) exitWith {0};

params [["_pos", [0, 0, 0], [[]], 3], ["_radius", 100, [0]], ["_override", createHashMap, [createHashMap]]];

private _all = [] call API(getInstances);
if (_all isEqualTo []) exitWith {
    LOG_DEBUG("doConfigure: no live instances");
    0
};

// Radius 0 = "dropped directly on one anomaly"; otherwise reconfigure every anomaly in range.
private _reach = [_radius, 6] select (_radius <= 0);
private _targets = _all select {(getPosATL _x) distance _pos <= _reach};

{[_x, _override] call API(configure)} forEach _targets;

LOG_DEBUG_1("doConfigure: reconfigured %1 instance(s)",count _targets);

count _targets
