#include "\z\root_anomalies\addons\scp096\script_component.hpp"
/*
 * Author: Root
 * Description: Driver for SCP-096 "The Shy Guy". Cowers harmlessly until a unit views it
 *              for a sustained time (by ANY means - eyes, binoculars, UAV, cameras all
 *              count). Once viewed long enough that unit is added to its target list and
 *              SCP-096 enrages, sprinting (real pathfinding, no teleport) to every target
 *              and killing them, calming down once the list empties and the cooldown
 *              elapses. Being shot also enrages it toward the attacker.
 *
 * Arguments:
 * 0: Position <ARRAY>
 * 1: Config <HASHMAP>
 *
 * Return Value:
 * SCP-096 object <OBJECT>
 *
 * Public: No
 */

if (!isServer) exitWith {objNull};

params ["_pos", ["_config", createHashMap, [createHashMap]]];

private _model = _config getOrDefault ["model", ROOT_ANOMALIES_VR_BASE];
private _grp = createGroup [civilian, true];
private _obj = _grp createUnit [_model, _pos, [], 0, "NONE"];
_obj setVariable ["BIS_fnc_animalBehaviour_disable", true];
_obj setSpeaker "NoVoice";
_obj disableConversation true;
_obj setBehaviour "CARELESS";
_obj setCaptive true;
_obj enableFatigue false;
_obj setSkill ["courage", 1];
_obj setUnitPos "DOWN";
_obj disableAI "MOVE";
_obj disableAI "AUTOTARGET";
_obj disableAI "TARGET";
_obj disableAI "FSM";
_obj forceSpeed 0;
_obj setVariable [QGVAR(observers), createHashMap, true];
_obj setVariable [QGVAR(viewTimes), createHashMap];
_obj setVariable [QGVAR(targets), [], true];
_obj setVariable [QGVAR(enraged), false, true];

[_obj] remoteExec [QFUNC(watch), 0, true];

LOG_DEBUG_1("SCP096 main spawned at %1",_pos);

private _h = [{
    params ["_args", "_handle"];
    _args params ["_obj", "_clock"];

    if (isNull _obj || {!alive _obj}) exitWith { _handle call CBA_fnc_removePerFrameHandler; };

    private _now = time;
    private _dt = (_now - (_clock select 0)) min 1;
    _clock set [0, _now];

    if (_obj getVariable [QGVAR(captured), false]) exitWith {};

    private _cfg = _obj getVariable [QGVAR(config), createHashMap];
    private _triggerRange = _cfg getOrDefault ["triggerRange", 200];
    private _viewTime = _cfg getOrDefault ["viewTime", 5];
    private _speed = _cfg getOrDefault ["speed", 11];
    private _cooldown = _cfg getOrDefault ["cooldown", 20];
    private _damage = _cfg getOrDefault ["damage", 1];
    private _affectAI = _cfg getOrDefault ["affectAI", true];

    private _addTarget = {
        params ["_u"];
        if (isNull _u || {!alive _u}) exitWith {};
        if !([_u, _obj] call EFUNC(main,isAffectable)) exitWith {};
        private _targets = _obj getVariable [QGVAR(targets), []];
        if !(_u in _targets) then {
            _targets pushBack _u;
            _obj setVariable [QGVAR(targets), _targets, true];
            [_obj, ["scream", 600]] remoteExec ["say3D"];
            LOG_DEBUG_1("SCP096 enraged by %1",name _u);
        };
        _obj setVariable [QGVAR(lastTrigger), time, true];
        _obj setVariable [QGVAR(enraged), true, true];
    };

    private _viewTimes = _obj getVariable [QGVAR(viewTimes), createHashMap];

    // Accumulate sustained player views (reported by client watchers).
    private _observers = _obj getVariable [QGVAR(observers), createHashMap];
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

    // Accumulate sustained AI views (server line-of-sight; cameras irrelevant for AI).
    if (_affectAI) then {
        {
            private _ai = _x;
            private _key = netId _ai;
            if ([_ai, _obj, 40, 1.6, false] call EFUNC(main,isObserving)) then {
                private _t = (_viewTimes getOrDefault [_key, 0]) + _dt;
                _viewTimes set [_key, _t];
                if (_t >= _viewTime) then { [_ai] call _addTarget; };
            } else {
                _viewTimes set [_key, 0];
            };
        } forEach (((getPosATL _obj) nearEntities ["CAManBase", _triggerRange]) select {
            !isPlayer _x && {alive _x} && {_x != _obj} && {typeOf _x != "VirtualCurator_F"}
        });
    };

    // Being shot enrages it toward the attacker (set by the shared damage handler).
    private _pending = _obj getVariable [QGVAR(pendingAttacker), objNull];
    if (!isNull _pending) then {
        _obj setVariable [QGVAR(pendingAttacker), objNull, true];
        [_pending] call _addTarget;
    };

    if !(_obj getVariable [QGVAR(enraged), false]) exitWith {};

    // Enraged: chase the nearest living target with real pathfinding.
    private _targets = (_obj getVariable [QGVAR(targets), []]) select {!isNull _x && {alive _x}};
    _obj setVariable [QGVAR(targets), _targets, true];

    if (_targets isEqualTo []) exitWith {
        if ((time - (_obj getVariable [QGVAR(lastTrigger), 0])) > _cooldown) then {
            _obj setVariable [QGVAR(enraged), false, true];
            _obj setUnitPos "DOWN";
            _obj disableAI "MOVE";
            _obj forceSpeed 0;
        };
    };

    _targets = [_targets, [], {_obj distance _x}, "ASCEND"] call BIS_fnc_sortBy;
    private _tgt = _targets select 0;
    _obj setUnitPos "UP";
    _obj enableAI "MOVE";
    _obj enableAI "PATH";
    _obj forceSpeed _speed;

    private _dist = _obj distance _tgt;
    if (_dist <= 2.5) exitWith {
        [_obj, ["bones_drop", 200]] remoteExec ["say3D"];
        _tgt setVelocity [0, 0, 4];
        [_tgt, _damage, "body", "stab", _obj] call EFUNC(main,applyDamage);
        if (_damage >= 1) then { _tgt setDamage 1; };
        _targets deleteAt 0;
        _obj setVariable [QGVAR(targets), _targets, true];
    };

    _obj doMove (getPosATL _tgt);
}, 0.25, [_obj, [time]]] call CBA_fnc_addPerFrameHandler;

_obj setVariable [QGVAR(pfh), _h, true];
_obj
