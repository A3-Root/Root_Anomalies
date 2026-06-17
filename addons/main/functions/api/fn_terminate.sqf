#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Permanently terminates an anomaly instance and all its effects, regardless of
 *              its lifecycle model. Sets a terminate flag every driver loop honours, removes
 *              its per-frame handlers, drops it from the registry, fires the KILLED event and
 *              deletes the entity plus any extra parts (heart, source/core, etc.). This is the
 *              supported way to remove blocking-loop anomalies such as the Smuggler and Steamer
 *              that have no health model and cannot simply be deleted.
 *
 * Arguments:
 * 0: Anomaly instance <OBJECT>
 *
 * Return Value:
 * Terminated <BOOL>
 *
 * Example:
 * [_anomaly] call root_anomalies_fnc_terminate;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]]];

if (isNull _obj) exitWith {false};

if (!isServer) exitWith {
    [_obj] remoteExec [QAPI(terminate), 2];
    true
};

_obj setVariable [QGVAR(terminate), true, true];
_obj setVariable [QGVAR(captured), true, true];
_obj setVariable [QGVAR(targets), [], true];

private _pfh = _obj getVariable [QGVAR(pfh), -1];
if (_pfh >= 0) then {_pfh call CBA_fnc_removePerFrameHandler};

private _sedPfh = _obj getVariable [QGVAR(sedationPfh), -1];
if (_sedPfh >= 0) then {_sedPfh call CBA_fnc_removePerFrameHandler};

if (!isNil QGVAR(instances)) then {GVAR(instances) = GVAR(instances) - [_obj]};

[ROOT_ANOMALIES_EVENT_KILLED, [_obj]] call CBA_fnc_globalEvent;

// Give blocking-loop drivers a beat to notice the flag and stop before we delete.
[{
    params ["_obj"];
    {
        if (!isNull _x) then {deleteVehicle _x};
    } forEach (_obj getVariable [QGVAR(extraDelete), []]);
    if (!isNull _obj) then {
        if (_obj isKindOf "CAManBase") then {_obj setDamage 1};
        deleteVehicle _obj;
    };
}, [_obj], 1.5] call CBA_fnc_waitAndExecute;

LOG_DEBUG_1("terminate: instance %1 terminated",_obj);

true
