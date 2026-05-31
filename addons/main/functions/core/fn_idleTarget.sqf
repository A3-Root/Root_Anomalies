#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Returns the position an idle anomaly (no prey in range) should drift toward:
 *              the nearest active, in-range bait, otherwise the next patrol waypoint,
 *              otherwise []. Shared by all anomaly drivers. Prunes expired baits.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 *
 * Return Value:
 * Target position, or [] if none <ARRAY>
 *
 * Public: No
 */

params [["_obj", objNull, [objNull]]];

if (isNull _obj) exitWith {[]};

// Active baits (global registry), pruned of expired entries.
if (isNil QGVAR(baits)) then { GVAR(baits) = []; };
GVAR(baits) = GVAR(baits) select { (_x select 2) == 0 || {time < (_x select 2)} };

private _objPos = getPosATL _obj;
private _best = [];
private _bestDist = 1e11;
{
    _x params ["_target", "_radius"];
    private _pos = _target;
    if (_target isEqualType objNull) then { _pos = getPosATL _target; };
    if (_pos isNotEqualTo []) then {
        private _d = _objPos distance _pos;
        if (_d <= _radius && {_d < _bestDist}) then { _bestDist = _d; _best = _pos; };
    };
} forEach GVAR(baits);

if (_best isNotEqualTo []) exitWith {_best};

// Patrol waypoints from config.
private _cfg = _obj getVariable [QGVAR(config), createHashMap];
private _wps = _cfg getOrDefault ["waypoints", []];
if (_wps isEqualTo []) exitWith {[]};

private _idx = _cfg getOrDefault ["waypointIdx", 0];
private _wp = _wps select (_idx mod (count _wps));
// Advance to the next waypoint once close.
if ((_objPos distance _wp) < 5) then {
    _cfg set ["waypointIdx", _idx + 1];
};
_wp
