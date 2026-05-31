#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Internal engine for capturing or killing an anomaly. Drivers idle while
 *              the captured flag is set, so capture simply neutralises the entity and
 *              raises the captured event; a kill additionally stops the PFH and destroys
 *              the entity. Server-authoritative.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Captured? (true = captured/recoverable, false = killed) <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_obj", objNull, [objNull]], ["_captured", true, [false]]];

if (isNull _obj) exitWith {};
if (!isServer) exitWith { [_obj, _captured] remoteExec [QFUNC(doCapture), 2]; };
if (_obj getVariable [QGVAR(captured), false]) exitWith {};

_obj setVariable [QGVAR(captured), true, true];
private _id = (_obj getVariable [QGVAR(config), createHashMap]) getOrDefault ["id", "?"];

if (_obj isKindOf "CAManBase") then {
    _obj setVariable [QGVAR(targets), [], true];
    _obj forceSpeed 0;
    _obj setUnitPos "DOWN";
};

if (_captured) exitWith {
    [ROOT_ANOMALIES_EVENT_CAPTURED, [_obj]] call CBA_fnc_globalEvent;
    LOG_DEBUG_1("doCapture: %1 captured",_id);
};

// Killed: stop behaviour PFH and destroy.
private _pfh = _obj getVariable [QGVAR(pfh), -1];
if (_pfh >= 0) then {
    _pfh call CBA_fnc_removePerFrameHandler;
    _obj setVariable [QGVAR(pfh), -1, true];
};
[ROOT_ANOMALIES_EVENT_KILLED, [_obj]] call CBA_fnc_globalEvent;
LOG_DEBUG_1("doCapture: %1 killed",_id);
_obj setDamage 1;
