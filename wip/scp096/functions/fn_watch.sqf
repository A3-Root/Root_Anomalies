#include "\z\root_anomalies\addons\scp096\script_component.hpp"
/*
 * Author: Root
 * Description: Per-client watcher for one SCP-096. Reports to the server whether the local
 *              player is currently looking at its face within trigger range. Unlike
 *              SCP-173, ALL viewing means count (UAV terminals and cameras included), so
 *              cameras are NOT excluded here.
 *
 * Arguments:
 * 0: SCP-096 object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_obj"];

[{
    params ["_args", "_handle"];
    _args params ["_obj", "_state"];

    if (isNull _obj) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
        [objNull, netId player, false] remoteExec [QFUNC(report), 2];
    };

    private _cfg = _obj getVariable [QGVAR(config), createHashMap];
    private _triggerRange = _cfg getOrDefault ["triggerRange", 200];

    private _looking = (alive player)
        && {player isNotEqualTo _obj}
        && {typeOf player != "VirtualCurator_F"}
        && {(player distance _obj) < _triggerRange}
        && {[player, _obj, 40, 1.6, false] call EFUNC(main,isObserving)};

    if (_looking isNotEqualTo (_state select 0)) then {
        [_obj, netId player, _looking] remoteExec [QFUNC(report), 2];
        _state set [0, _looking];
    };
}, 0.25, [_obj, [false]]] call CBA_fnc_addPerFrameHandler;
