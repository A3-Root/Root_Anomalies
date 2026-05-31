#include "\z\root_anomalies\addons\scp096\script_component.hpp"
/*
 * Author: Root
 * Description: Server-side view accumulator for a player-controlled SCP-096P. Tracks how
 *              long each viewer (players via their watchers, AI via line of sight) has
 *              looked at the unit; once a viewer passes the view time the unit becomes
 *              enraged (published on the unit) and the viewer is added to its target list.
 *              Calms after the cooldown with no active viewers. Also registers the unit as
 *              a live anomaly instance.
 *
 * Arguments:
 * 0: SCP-096P unit <OBJECT>
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
    _args params ["_unit", "_clock"];

    if (isNull _unit || {!alive _unit}) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
        GVAR(instances) = GVAR(instances) - [_unit];
    };

    private _now = time;
    private _dt = (_now - (_clock select 0)) min 1;
    _clock set [0, _now];

    if (_unit getVariable [QGVAR(captured), false]) exitWith {
        _unit setVariable [QGVAR(enraged), false, true];
    };

    private _cfg = _unit getVariable [QGVAR(config), createHashMap];
    private _triggerRange = _cfg getOrDefault ["triggerRange", 200];
    private _viewTime = _cfg getOrDefault ["viewTime", 5];
    private _cooldown = _cfg getOrDefault ["cooldown", 20];
    private _affectAI = _cfg getOrDefault ["affectAI", true];

    private _viewTimes = _unit getVariable [QGVAR(viewTimes), createHashMap];

    private _addTarget = {
        params ["_u"];
        if (isNull _u || {!alive _u}) exitWith {};
        private _targets = _unit getVariable [QGVAR(targets), []];
        if !(_u in _targets) then {
            _targets pushBack _u;
            _unit setVariable [QGVAR(targets), _targets, true];
        };
        _unit setVariable [QGVAR(lastTrigger), time, true];
        _unit setVariable [QGVAR(enraged), true, true];
    };

    private _observers = _unit getVariable [QGVAR(observers), createHashMap];
    {
        private _key = _x;
        private _viewer = objectFromNetId _key;
        if (_observers get _key) then {
            private _t = (_viewTimes getOrDefault [_key, 0]) + _dt;
            _viewTimes set [_key, _t];
            if (_t >= _viewTime) then { [_viewer] call _addTarget; };
        } else {
            _viewTimes set [_key, 0];
        };
    } forEach (keys _observers);

    if (_affectAI) then {
        {
            private _ai = _x;
            private _key = netId _ai;
            if ([_ai, _unit, 40, 1.6, false] call EFUNC(main,isObserving)) then {
                private _t = (_viewTimes getOrDefault [_key, 0]) + _dt;
                _viewTimes set [_key, _t];
                if (_t >= _viewTime) then { [_ai] call _addTarget; };
            } else {
                _viewTimes set [_key, 0];
            };
        } forEach (((getPosATL _unit) nearEntities ["CAManBase", _triggerRange]) select {
            !isPlayer _x && {alive _x} && {_x != _unit} && {typeOf _x != "VirtualCurator_F"}
        });
    };

    // Drop dead targets; calm down when none remain past the cooldown.
    private _targets = (_unit getVariable [QGVAR(targets), []]) select {!isNull _x && {alive _x}};
    _unit setVariable [QGVAR(targets), _targets, true];
    if (_targets isEqualTo [] && {(time - (_unit getVariable [QGVAR(lastTrigger), 0])) > _cooldown}) then {
        _unit setVariable [QGVAR(enraged), false, true];
    };
}, 0.25, [_unit, [time]]] call CBA_fnc_addPerFrameHandler;
