#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Shared backend for the Terminate modules. If a live anomaly sits right under
 *              the given position (within 6m, i.e. the module was dropped on it) only that
 *              one is terminated; otherwise every anomaly within the radius is terminated.
 *
 * Arguments:
 * 0: Centre position (ATL) <ARRAY>
 * 1: Radius (m) <NUMBER>
 *
 * Return Value:
 * Count terminated <NUMBER>
 *
 * Public: No
 */

if (!isServer) exitWith {0};

params [["_pos", [0, 0, 0], [[]], 3], ["_radius", 100, [0]]];

private _all = [] call API(getInstances);
if (_all isEqualTo []) exitWith {
    LOG_DEBUG("doTerminate: no live instances");
    0
};

// Radius 0 = "dropped directly on one anomaly" -> only the one within 6m. Otherwise
// terminate every anomaly within the radius (a nearby anomaly must never be skipped just
// because some other anomaly happens to sit within the 6m drop-on threshold).
private _reach = [_radius, 6] select (_radius <= 0);
private _targets = _all select {(getPosATL _x) distance _pos <= _reach};

{[_x] call API(terminate)} forEach _targets;

LOG_DEBUG_1("doTerminate: terminated %1 instance(s)",count _targets);

count _targets
