#include "\z\root_anomalies\addons\scp173\script_component.hpp"
/*
 * Author: Root
 * Description: Server backend for SCP-173 "The Sculpture". It is frozen while any
 *              player (or, optionally, AI) observes it; the instant it is unobserved it
 *              blinks toward the nearest victim and snaps their neck on contact.
 *
 * Arguments:
 * 0: Marker name <STRING>
 * 1: Model classname <STRING>
 * 2: Territory radius <NUMBER>
 * 3: Blink distance <NUMBER>
 * 4: Kill distance <NUMBER>
 * 5: Affect AI <BOOL>
 *
 * Return Value:
 * SCP-173 object <OBJECT>
 *
 * Public: No
 */

if (!isServer) exitWith {objNull};

params [
    ["_marker", "", [""]],
    ["_model", ROOT_ANOMALIES_VR_BASE, [""]],
    ["_territory", 150, [0]],
    ["_blink", 8, [0]],
    ["_killDist", 2.5, [0]],
    ["_affectAI", true, [false]]
];

private _pos = getMarkerPos _marker;
private _obj = createAgent [_model, _pos, [], 0, "NONE"];
_obj setVariable ["BIS_fnc_animalBehaviour_disable", true];
_obj setSpeaker "NoVoice";
_obj disableConversation true;
_obj setBehaviour "CARELESS";
_obj setCaptive true;
_obj allowDamage false;
_obj enableFatigue false;
_obj disableAI "ALL";
_obj setUnitPos "UP";
_obj setSkill ["courage", 1];
_obj forceSpeed 0;
{_obj setObjectTextureGlobal [_x, "#(rgb,8,8,3)color(0.5,0.5,0.5,1)"]} forEach [0, 1, 2, 3, 4, 5];
_obj setVariable [QGVAR(observers), createHashMap];

[_obj, _territory] remoteExec ["Root_fnc_SCP173Watch", 0, true];

LOG_DEBUG_2("SCP173Main spawned at %1 (territory %2)",_pos,_territory);

// True when any nearby AI (if enabled) has line of sight to and is facing SCP-173.
private _aiObserving = {
    params ["_obj", "_territory"];
    private _seen = false;
    {
        if ((!isPlayer _x) && {alive _x} && {typeOf _x != "VirtualCurator_F"}) then {
            private _eye = eyePos _x;
            private _head = (AGLToASL (getPosATL _obj)) vectorAdd [0, 0, 1.5];
            private _toObj = _head vectorDiff _eye;
            private _angle = acos (((vectorDir _x) vectorDotProduct (vectorNormalized _toObj)) min 1 max -1);
            if ((_angle < 70) && {(lineIntersectsSurfaces [_eye, _head, _x, _obj]) isEqualTo []}) exitWith {_seen = true};
        };
    } forEach ((position _obj) nearEntities ["CAManBase", _territory]);
    _seen
};

while {alive _obj} do {
    private _observers = _obj getVariable [QGVAR(observers), createHashMap];
    private _observed = (values _observers) findIf {_x} != -1;
    if (!_observed && _affectAI) then {_observed = [_obj, _territory] call _aiObserving};

    if (!_observed) then {
        private _candidates = ((position _obj) nearEntities ["CAManBase", _territory]) select {
            (alive _x) && {typeOf _x != "VirtualCurator_F"} && {_affectAI || {isPlayer _x}}
        };
        if (_candidates isNotEqualTo []) then {
            _candidates = [_candidates, [], {_obj distance _x}, "ASCEND"] call BIS_fnc_sortBy;
            private _tgt = _candidates select 0;
            private _dist = _obj distance _tgt;
            _obj setDir (_obj getRelDir _tgt);
            if (_dist <= _killDist) then {
                [_obj, ["bones_drop", 200]] remoteExec ["say3D"];
                [_tgt, ["punch_7", 200]] remoteExec ["say3D"];
                _tgt setVelocity [0, 0, -2];
                [_tgt, 1, "head", "stab"] call Root_fnc_applyDamage;
                _tgt setDamage 1;
                LOG_DEBUG_1("SCP173 killed %1",name _tgt);
            } else {
                private _step = _blink min (_dist - _killDist);
                private _new = [getPosATL _obj, _step, _obj getRelDir _tgt] call BIS_fnc_relPos;
                _obj setPosATL [_new select 0, _new select 1, 0];
            };
        };
    };
    uiSleep 0.3;
};

_obj
