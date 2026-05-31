#include "\z\root_anomalies\addons\scp173\script_component.hpp"
/*
 * Author: Root
 * Description: Server-side observation evaluator for a player-controlled SCP-173P. Reuses
 *              the standard observer reports (other clients' watchers) plus an AI line-of-
 *              sight check, and publishes a single QGVAR(observed) boolean on the unit so
 *              its controlling machine knows when to freeze. Also registers the unit as a
 *              live anomaly instance so traps / getInstances see it.
 *
 * Arguments:
 * 0: SCP-173P unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params ["_unit"];

if (isNil QGVAR(instances)) then { GVAR(instances) = []; };
GVAR(instances) pushBackUnique _unit;

[{
    params ["_args", "_handle"];
    _args params ["_unit"];

    if (isNull _unit || {!alive _unit}) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
        GVAR(instances) = GVAR(instances) - [_unit];
    };
    if (_unit getVariable [QGVAR(captured), false]) exitWith {
        _unit setVariable [QGVAR(observed), false, true];
    };

    private _cfg = _unit getVariable [QGVAR(config), createHashMap];
    private _observeDist = _cfg getOrDefault ["observeDist", 1000];
    private _affectAI = _cfg getOrDefault ["affectAI", true];

    private _observers = _unit getVariable [QGVAR(observers), createHashMap];
    private _observed = (values _observers) findIf {_x} != -1;

    if (!_observed && _affectAI) then {
        private _ai = ((getPosATL _unit) nearEntities ["CAManBase", _observeDist]) select {
            !isPlayer _x && {alive _x} && {_x != _unit} && {typeOf _x != "VirtualCurator_F"}
        };
        _observed = _ai findIf { [_x, _unit, 70, 1.5, true] call EFUNC(main,isObserving) } != -1;
    };

    _unit setVariable [QGVAR(observed), _observed, true];
}, 0.2, [_unit]] call CBA_fnc_addPerFrameHandler;
