#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Blocking sedation gate for the legacy creature loops. Drivers call it at
 *              the top of each loop pass and before every attack, leap, travel or burst.
 *              While the anomaly is sedated it is pulled out of hiding, frozen in place in
 *              a slumped pose and kept there, so players can walk up and capture it. When
 *              the sedative wears off it stands back up and its attacks stay on cooldown
 *              for a short while. Returns immediately when the anomaly is not sedated.
 *              Must run scheduled on the server.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 *
 * Return Value:
 * True if the anomaly was held <BOOL>
 *
 * Example:
 * [_farmer] call root_anomalies_main_fnc_sedationHold;
 *
 * Public: No
 */

params [["_obj", objNull, [objNull]]];

if (!isServer || {!canSuspend}) exitWith {false};
if (isNull _obj || {!alive _obj}) exitWith {false};
if !(_obj getVariable [QGVAR(sedated), false]) exitWith {false};

private _cfg = _obj getVariable [QGVAR(config), createHashMap];
private _id = _cfg getOrDefault ["id", typeOf _obj];
private _isMan = _obj isKindOf "CAManBase";
private _wasHidden = isObjectHidden _obj;
private _wasSimulated = simulationEnabled _obj;
private _origin = getPosATL _obj;

// Hidden anomalies (steamer) materialise where the sedative landed.
private _smokePos = _obj getVariable [QGVAR(sedationPos), []];
private _moved = (_cfg getOrDefault ["sedationMoveToSmoke", false]) && {_smokePos isNotEqualTo []};
if (_moved) then {
    _obj setPosATL [_smokePos select 0, _smokePos select 1, 0];
};

_obj hideObjectGlobal false;
_obj enableSimulationGlobal true;
_obj setVariable [QGVAR(held), true, true];

if (_isMan) then {
    _obj disableAI "MOVE";
    _obj disableAI "PATH";
    _obj doMove (getPosATL _obj);
    _obj forceSpeed 0;
    [_obj, "AinjPpneMstpSnonWnonDnon"] remoteExec ["switchMove", 0];
} else {
    _obj setVelocity [0, 0, 0];
};

[ROOT_ANOMALIES_EVENT_SEDATED, [_obj, true]] call CBA_fnc_globalEvent;
LOG_DEBUG_2("sedationHold: %1 sedated at %2",_id,mapGridPosition _obj);

while {
    alive _obj
    && {_obj getVariable [QGVAR(sedated), false]}
    && {!(_obj getVariable [QGVAR(captured), false])}
    && {!(_obj getVariable [QGVAR(terminate), false])}
} do {
    if (!_isMan) then {_obj setVelocity [0, 0, 0]};
    uiSleep 0.5;
};

if (isNull _obj) exitWith {true};

private _cooldown = _cfg getOrDefault ["sedationCooldown", ROOT_ANOMALIES_DEFAULT_SEDATION_COOLDOWN];
_obj setVariable [QGVAR(cooldownUntil), time + _cooldown, true];
_obj setVariable [QGVAR(held), false, true];

// Captured or terminated anomalies are cleaned up by their own exit path.
if (!alive _obj || {_obj getVariable [QGVAR(captured), false]} || {_obj getVariable [QGVAR(terminate), false]}) exitWith {true};

if (_isMan) then {
    _obj enableAI "MOVE";
    _obj enableAI "PATH";
    _obj forceSpeed -1;
    [_obj, ""] remoteExec ["switchMove", 0];
};

if (_moved) then {_obj setPosATL _origin};
if (_wasHidden) then {_obj hideObjectGlobal true};
if (!_wasSimulated) then {_obj enableSimulationGlobal false};

[ROOT_ANOMALIES_EVENT_SEDATED, [_obj, false]] call CBA_fnc_globalEvent;
LOG_DEBUG_2("sedationHold: %1 woke up, attacks on cooldown for %2s",_id,_cooldown);

// Stay docile through the cooldown so players can back off or finish the job.
private _until = time + _cooldown;
waitUntil {
    uiSleep 0.5;
    time >= _until || {!alive _obj} || {_obj getVariable [QGVAR(sedated), false]} || {_obj getVariable [QGVAR(captured), false]} || {_obj getVariable [QGVAR(terminate), false]}
};

true
