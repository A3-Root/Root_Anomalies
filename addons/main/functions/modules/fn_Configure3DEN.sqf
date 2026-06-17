#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN front-end for the Reconfigure module. At mission start, applies the given
 *              targeting/damage/capture overrides to anomalies within its radius (or the one
 *              it sits on). Mainly a Zeus tool; in 3DEN it fires once at init.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 * 1: Synced units <ARRAY>
 * 2: Activated <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_logic", "_units", "_activated"];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};

private _radius = _logic getVariable ["ROOT_CFG_RADIUS", 100];
private _override = createHashMapFromArray [
    ["hostileSides", [_logic getVariable ["ROOT_SIDES", ""]] call FUNC(parseSides)],
    ["activationRange", _logic getVariable ["ROOT_ACTIVATION", ROOT_ANOMALIES_DEFAULT_ACTIVATION]],
    ["damage", _logic getVariable ["ROOT_CFG_DAMAGE", 0.4]],
    ["captureEnabled", _logic getVariable ["ROOT_CAPTURE", true]]
];

[getPosATL _logic, _radius, _override] call FUNC(doConfigure);
