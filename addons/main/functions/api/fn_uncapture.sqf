#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Releases a captured anomaly, resetting its damage pool and letting its
 *              driver resume. Server-routed.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp] call root_anomalies_fnc_uncapture;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]]];

if (isNull _obj) exitWith {};

if (!isServer) exitWith { [_obj] remoteExec [QAPI(uncapture), 2]; };

_obj setVariable [QGVAR(captured), false, true];
_obj setVariable [QGVAR(absorbed), 0, true];
_obj setVariable [QGVAR(sedated), false, true];
if (_obj isKindOf "CAManBase") then { _obj setUnitPos "UP"; };

private _id = (_obj getVariable [QGVAR(config), createHashMap]) getOrDefault ["id", "?"];
LOG_DEBUG_1("uncapture: %1 released",_id);
