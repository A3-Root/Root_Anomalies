#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Registers a bait (object or position) that lures anomalies. While active,
 *              an idle anomaly within range moves toward the nearest bait instead of
 *              patrolling. Drivers read the bait registry (root_anomalies_main_baits).
 *
 * Arguments:
 * 0: Bait target (object or position) <OBJECT|ARRAY>
 * 1: Lure radius (m) <NUMBER> (default 300)
 * 2: Duration (s, 0 = permanent) <NUMBER> (default 0)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_crate, 400, 120] call root_anomalies_fnc_addBait;
 *
 * Public: Yes
 */

params [["_target", objNull, [objNull, []]], ["_radius", 300, [0]], ["_duration", 0, [0]]];

if (!isServer) exitWith { [_target, _radius, _duration] remoteExec [QAPI(addBait), 2]; };

if (isNil QGVAR(baits)) then { GVAR(baits) = []; };
private _expire = [0, time + _duration] select (_duration > 0);
GVAR(baits) pushBack [_target, _radius, _expire];

LOG_DEBUG_2("addBait: registered (radius %1, expire %2)",_radius,_expire);
