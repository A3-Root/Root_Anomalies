#include "\z\root_anomalies\addons\scp096\script_component.hpp"
/*
 * Author: Root
 * Description: Server backend for SCP-096 "The Shy Guy". It cowers, harmless, until a
 *              unit sees its face or damages it; then it sprints to every such unit and
 *              kills them, calming down once its target list is empty and the cooldown
 *              has elapsed.
 *
 * Arguments:
 * 0: Marker name <STRING>
 * 1: Model classname <STRING>
 * 2: Trigger range <NUMBER>
 * 3: Rage speed (m/s) <NUMBER>
 * 4: Calm cooldown (s) <NUMBER>
 * 5: Damage fraction <NUMBER>
 * 6: Affect AI <BOOL>
 *
 * Return Value:
 * SCP-096 object <OBJECT>
 *
 * Public: No
 */

if (!isServer) exitWith {objNull};

params [
    ["_marker", "", [""]],
    ["_model", ROOT_ANOMALIES_VR_BASE, [""]],
    ["_triggerRange", 200, [0]],
    ["_speed", 11, [0]],
    ["_cooldown", 20, [0]],
    ["_damage", 1, [0]],
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
_obj setSkill ["courage", 1];
_obj setVariable [QGVAR(targets), []];
_obj setVariable [QGVAR(enraged), false, true];
_obj setUnitPos "DOWN";

// Being shot enrages SCP-096 toward the instigator.
_obj addEventHandler ["HandleDamage", {
    params ["_unit", "_selection", "_dmg", "_source", "_proj", "_idx", "_instigator"];
    private _attacker = _instigator;
    if (isNull _attacker) then {_attacker = _source};
    if ((!isNull _attacker) && {_attacker != _unit} && {_unit getVariable [QGVAR(affectAI), true] || {isPlayer _attacker}}) then {
        [_unit, _attacker] call Root_fnc_SCP096Trigger;
    };
    0
}];
_obj setVariable [QGVAR(affectAI), _affectAI, true];

[_obj, _triggerRange] remoteExec ["Root_fnc_SCP096Watch", 0, true];

LOG_DEBUG_2("SCP096Main spawned at %1 (trigger %2)",_pos,_triggerRange);

while {alive _obj} do {
    if (_obj getVariable [QGVAR(enraged), false]) then {
        private _targets = (_obj getVariable [QGVAR(targets), []]) select {!isNull _x && {alive _x}};
        _obj setVariable [QGVAR(targets), _targets];

        if (_targets isEqualTo []) then {
            if ((time - (_obj getVariable [QGVAR(lastTrigger), 0])) > _cooldown) then {
                _obj setVariable [QGVAR(enraged), false, true];
                _obj setUnitPos "DOWN";
                _obj setDir (random 360);
            };
            uiSleep 1;
        } else {
            _targets = [_targets, [], {_obj distance _x}, "ASCEND"] call BIS_fnc_sortBy;
            private _tgt = _targets select 0;
            _obj setUnitPos "UP";
            _obj setDir (_obj getRelDir _tgt);
            private _dist = _obj distance _tgt;
            if (_dist <= 2.5) then {
                [_tgt, ["bones_drop", 200]] remoteExec ["say3D"];
                _tgt setVelocity [0, 0, 4];
                [_tgt, _damage, "body", "stab"] call Root_fnc_applyDamage;
                if (_damage >= 1) then {_tgt setDamage 1};
                _targets deleteAt 0;
                _obj setVariable [QGVAR(targets), _targets];
            } else {
                private _step = (_speed * 0.1) min _dist;
                private _new = [getPosATL _obj, _step, _obj getRelDir _tgt] call BIS_fnc_relPos;
                _obj setPosATL [_new select 0, _new select 1, 0];
            };
            uiSleep 0.1;
        };
    } else {
        uiSleep 1;
    };
};

_obj
