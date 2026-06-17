#include "\z\root_anomalies\addons\worm\script_component.hpp"
/*
 * Author: Root
 * Description: Server handler that makes any Worm whose territory contains a thrown
 *              forceful-target object fixate on it for its next few attacks. The thrown
 *              object is captured directly (see fn_WormThrown) so it works in vanilla and
 *              ACE, and avoids the magazine-vs-ammo classname mismatch of a class search.
 *
 * Arguments:
 * 0: Thrown forceful-target object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params [["_proj", objNull, [objNull]]];

if (isNull _proj) exitWith {};

{
    private _head = _x;
    private _cfg = _head getVariable [EGVAR(main,config), createHashMap];
    private _terr = _cfg getOrDefault ["territory", 200];
    if (_proj distance _head <= _terr) then {
        private _forceN = _cfg getOrDefault ["forceN", 3];
        _head setVariable [QGVAR(forceObj), _proj, true];
        _head setVariable [QGVAR(forceCount), _forceN max 1, true];
        LOG_DEBUG_1("WormForce: worm fixated on thrown %1",typeOf _proj);
    };
} forEach (["worm"] call API(getInstances));
