#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Registers a trap area. When any anomaly enters it, the trap forces a
 *              sedation window (enabling capture) and, optionally, auto-captures it.
 *              Runs a lightweight server PFH over live instances.
 *
 * Arguments:
 * 0: Trap centre (object or position) <OBJECT|ARRAY>
 * 1: Trap radius (m) <NUMBER> (default 8)
 * 2: Auto-capture on entry? <BOOL> (default false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [getMarkerPos "trap1", 10, true] call root_anomalies_fnc_addTrap;
 *
 * Public: Yes
 */

params [["_centre", objNull, [objNull, []]], ["_radius", 8, [0]], ["_auto", false, [false]]];

if (!isServer) exitWith { [_centre, _radius, _auto] remoteExec [QAPI(addTrap), 2]; };

[{
    params ["_args", "_handle"];
    _args params ["_centre", "_radius", "_auto"];

    private _pos = _centre;
    if (_centre isEqualType objNull) then {
        if (isNull _centre) exitWith { _handle call CBA_fnc_removePerFrameHandler; };
        _pos = getPosATL _centre;
    };
    if (_pos isEqualTo []) exitWith { _handle call CBA_fnc_removePerFrameHandler; };

    {
        if ((_x distance _pos) <= _radius && {!(_x getVariable [QGVAR(captured), false])}) then {
            _x setVariable [QGVAR(sedated), true, true];
            _x setVariable [QGVAR(sedatedUntil), time + 20, true];
            if (_auto) then { [_x] call API(capture); };
        };
    } forEach ([] call API(getInstances));
}, 1, [_centre, _radius, _auto]] call CBA_fnc_addPerFrameHandler;

LOG_DEBUG_2("addTrap: registered (radius %1, auto %2)",_radius,_auto);
