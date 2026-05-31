#include "\z\root_anomalies\addons\scp173\script_component.hpp"
/*
 * Author: Root
 * Description: Driver for SCP-173 "The Sculpture". Frozen while observed (by the local
 *              player's own eyes/binoculars within the observation distance, or by AI);
 *              the moment it is unobserved it moves — at an abnormally high but continuous
 *              speed, no teleporting — toward the nearest victim and snaps their neck on
 *              contact. UAV terminals / external cameras do NOT count as observation.
 *
 *              Driver contract (called by root_anomalies_fnc_spawn):
 *
 * Arguments:
 * 0: Position <ARRAY>
 * 1: Config <HASHMAP>
 *
 * Return Value:
 * SCP-173 object <OBJECT>
 *
 * Public: No
 */

if (!isServer) exitWith {objNull};

params ["_pos", ["_config", createHashMap, [createHashMap]]];

private _model = _config getOrDefault ["model", ROOT_ANOMALIES_VR_BASE];
private _obj = createAgent [_model, _pos, [], 0, "NONE"];
_obj setVariable ["BIS_fnc_animalBehaviour_disable", true];
_obj setSpeaker "NoVoice";
_obj disableConversation true;
_obj setBehaviour "CARELESS";
_obj setCaptive true;
_obj enableFatigue false;
_obj disableAI "ALL";
_obj setUnitPos "UP";
_obj setSkill ["courage", 1];
_obj forceSpeed 0;
{_obj setObjectTextureGlobal [_x, "#(rgb,8,8,3)color(0.5,0.5,0.5,1)"]} forEach [0, 1, 2, 3, 4, 5];
_obj setVariable [QGVAR(observers), createHashMap, true];

// Client observation + blink watchers (JIP for late joiners).
[_obj] remoteExec [QFUNC(watch), 0, true];

LOG_DEBUG_1("SCP173 main spawned at %1",_pos);

private _h = [{
    params ["_args", "_handle"];
    _args params ["_obj", "_clock"];

    if (isNull _obj || {!alive _obj}) exitWith { _handle call CBA_fnc_removePerFrameHandler; };

    private _now = time;
    private _dt = (_now - (_clock select 0)) min 0.5;
    _clock set [0, _now];

    if (_obj getVariable [QGVAR(captured), false]) exitWith {};

    private _cfg = _obj getVariable [QGVAR(config), createHashMap];
    private _radius = _cfg getOrDefault ["radius", 150];
    private _observeDist = _cfg getOrDefault ["observeDist", 1000];
    private _killDist = _cfg getOrDefault ["killDist", 2.5];
    private _speed = _cfg getOrDefault ["speed", 7];
    private _affectAI = _cfg getOrDefault ["affectAI", true];

    // Observed by any player whose watcher reported "seeing"?
    private _observers = _obj getVariable [QGVAR(observers), createHashMap];
    private _observed = (values _observers) findIf {_x} != -1;

    // Or by nearby AI (own-eyes rule; cameras irrelevant for AI).
    if (!_observed && _affectAI) then {
        private _ai = ((getPosATL _obj) nearEntities ["CAManBase", _observeDist]) select {
            !isPlayer _x && {alive _x} && {typeOf _x != "VirtualCurator_F"}
        };
        _observed = _ai findIf { [_x, _obj, 70, 1.5, true] call EFUNC(main,isObserving) } != -1;
    };

    if (_observed) exitWith {};

    // Unobserved: hunt the nearest victim inside the territory.
    private _cands = ((getPosATL _obj) nearEntities ["CAManBase", _radius]) select {
        (alive _x) && {typeOf _x != "VirtualCurator_F"} && {_affectAI || {isPlayer _x}} && {_x != _obj}
    };

    if (_cands isEqualTo []) exitWith {
        // No prey: drift toward an active bait, else a patrol waypoint.
        private _lure = [_obj] call EFUNC(main,idleTarget);
        if (_lure isNotEqualTo []) then {
            private _step = (_speed * _dt) min (_obj distance _lure);
            _obj setDir (_obj getDir _lure);
            private _new = [getPosATL _obj, _step, _obj getRelDir _lure] call BIS_fnc_relPos;
            _obj setPosATL [_new select 0, _new select 1, 0];
        };
    };

    _cands = [_cands, [], {_obj distance _x}, "ASCEND"] call BIS_fnc_sortBy;
    private _tgt = _cands select 0;
    private _dist = _obj distance _tgt;
    _obj setDir (_obj getRelDir _tgt);

    if (_dist <= _killDist) exitWith {
        if !([_tgt, _obj] call EFUNC(main,isAffectable)) exitWith {};
        [_obj, ["bones_drop", 200]] remoteExec ["say3D"];
        [_tgt, ["punch_7", 200]] remoteExec ["say3D"];
        _tgt setVelocity [0, 0, -2];
        [_tgt, 1, "head", "stab", _obj] call EFUNC(main,applyDamage);
        _tgt setDamage 1;
        LOG_DEBUG_1("SCP173 killed %1",name _tgt);
    };

    private _step = (_speed * _dt) min (_dist - _killDist);
    private _new = [getPosATL _obj, _step, _obj getRelDir _tgt] call BIS_fnc_relPos;
    _obj setPosATL [_new select 0, _new select 1, 0];
}, 0, [_obj, [time]]] call CBA_fnc_addPerFrameHandler;

_obj setVariable [QGVAR(pfh), _h, true];
_obj
