#include "\z\root_anomalies\addons\scp173\script_component.hpp"
/*
 * Author: Root
 * Description: Server handler - records whether a given client is currently observing
 *              SCP-173. Called via remoteExec from each client's watcher.
 *
 * Arguments:
 * 0: SCP-173 object <OBJECT>
 * 1: Reporting client owner id <NUMBER>
 * 2: Observing <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params ["_obj", "_owner", "_seeing"];

if (isNull _obj) exitWith {};

private _observers = _obj getVariable [QGVAR(observers), createHashMap];
_observers set [str _owner, _seeing];
_obj setVariable [QGVAR(observers), _observers];
