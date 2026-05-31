#include "\z\root_anomalies\addons\scp096\script_component.hpp"
/*
 * Author: Root
 * Description: Server handler recording whether a client currently looks at a given
 *              SCP-096, keyed by the viewer's network id. Called via remoteExec from each
 *              client's watcher. The main driver accumulates per-viewer view time.
 *
 * Arguments:
 * 0: SCP-096 object <OBJECT>
 * 1: Viewer network id <STRING>
 * 2: Looking <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params ["_obj", "_netId", "_looking"];

if (isNull _obj) exitWith {};

private _observers = _obj getVariable [QGVAR(observers), createHashMap];
_observers set [_netId, _looking];
_obj setVariable [QGVAR(observers), _observers];
