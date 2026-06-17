#include "\z\root_anomalies\addons\swarmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server backend that spawns and runs a Swarmer anomaly: an invisible
 *              hive whose fly swarm hunts, kills and devours targets.
 *
 * Arguments:
 * 0: Hive object <OBJECT>
 * 1: Territory radius <NUMBER>
 * 2: Pesticide classname ("" disables pesticide) <STRING>
 * 3: Damage fraction <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params [
    ["_hiveObj", objNull, [objNull]],
    ["_radius", 75, [0]],
    ["_pesticide", "SmokeShellGreen", [""]],
    ["_damage", 0.6, [0]],
    ["_config", createHashMap, [createHashMap]]
];

if (isNull _hiveObj) exitWith {};

missionNamespace setVariable ["ROOT_ANOMALIES_SWARMER_PESTICIDE", _pesticide, true];

if (!isNil {_hiveObj getVariable QGVAR(activate)}) exitWith {};
_hiveObj setVariable [QGVAR(activate), true, true];

uiSleep 2;

private _agent = createAgent ["C_Soldier_VR_F", position _hiveObj, [], 0, "NONE"];
_agent hideObjectGlobal true;
_agent setVariable ["BIS_fnc_animalBehaviour_disable", true];
_agent setSpeaker "NoVoice";
_agent disableConversation true;
_agent setBehaviour "CARELESS";
_agent allowDamage false;
_agent enableFatigue false;
_agent setSkill ["courage", 1];
_agent setUnitPos "UP";
_agent disableAI "ALL";
{_agent enableAI _x} forEach ["MOVE", "ANIM", "TEAMSWITCH", "PATH"];
_agent setAnimSpeedCoef 1.1;
_agent setVariable [QGVAR(isHive), false, true];

[_agent] remoteExec [QFUNC(SwarmerVoice), [0, -2] select isDedicated];
[_agent] remoteExec [QFUNC(SwarmerSfx), [0, -2] select isDedicated];
missionNamespace setVariable ["ROOT_ANOMALIES_SWARMER_AGENT", _agent, true];
missionNamespace setVariable ["ROOT_ANOMALIES_SWARMER_ATK", false, true];

if !("sedationClassnames" in _config) then {
    _config set ["sedationClassnames", [_pesticide, ROOT_ANOMALIES_SEDATIVE_SMOKE]];
};
_agent setVariable [QGVAR(extraDelete), [_hiveObj], true];
[_agent, _config] call EFUNC(main,finalizeInstance);

LOG_DEBUG_2("SwarmerMain spawned hive at %1 (territory %2)",position _hiveObj,_radius);

while {alive _agent && {!(_agent getVariable [EGVAR(main,captured), false])} && {!(_agent getVariable [EGVAR(main,terminate), false])}} do {
    private _cfg = _agent getVariable [QGVAR(config), createHashMap];
    _radius = _cfg getOrDefault ["territory", _radius];
    _damage = _cfg getOrDefault ["damage", _damage];
    private _activation = _cfg getOrDefault ["activationRange", ROOT_ANOMALIES_DEFAULT_ACTIVATION];
    while {!(_agent getVariable [QGVAR(isHive), false]) && {!(_agent getVariable [EGVAR(main,terminate), false])}} do {
        {if (_x distance getPos _agent < _activation) exitWith {_agent setVariable [QGVAR(isHive), true, true]}} forEach allPlayers;
        uiSleep 10;
    };
    _agent setVariable [QGVAR(tgt), objNull, true];

    private _inRange = ([_agent, _radius, _hiveObj] call FUNC(SwarmerFindTarget)) select {(typeOf _x != "VirtualCurator_F") && {[_x, _agent] call EFUNC(main,isAffectable)}};
    if (_inRange isNotEqualTo []) then {
        private _tgt = selectRandom _inRange;
        _agent setVariable [QGVAR(tgt), _tgt, true];
        {[_agent, _x] spawn FUNC(SwarmerAvoid)} forEach _inRange;
        _agent disableCollisionWith _tgt;

        while {(alive _tgt) && {_tgt distance _hiveObj <= _radius}} do {
            if (_tgt distance _agent > 10) then {_agent moveTo AGLToASL (_tgt modelToWorld [0, 7, 0])};
            uiSleep 4;
            if ((_tgt distance _agent <= 10) && {alive _agent}) then {
                missionNamespace setVariable ["ROOT_ANOMALIES_SWARMER_ATK", true, true];
                _agent moveTo AGLToASL (_tgt modelToWorld [0, 0, 0]);
                [_tgt, _agent] remoteExec [QFUNC(SwarmerEating), [0, -2] select isDedicated];
                for "_h" from 1 to 5 do {
                    [_tgt, _damage, selectRandom ["head", "body", "hand_l", "hand_r", "leg_l", "leg_r"], selectRandom ["bullet", "explosive", "grenade", "punch", "ropeburn", "shell", "stab", "burn"], _agent] call EFUNC(main,applyDamage);
                };
                {[_agent, _x] spawn FUNC(SwarmerAvoid)} forEach _inRange;
                uiSleep 2;
                missionNamespace setVariable ["ROOT_ANOMALIES_SWARMER_ATK", false, true];
                private _pool = createVehicle [selectRandom ["BloodPool_01_Large_New_F", "BloodSplatter_01_Large_New_F"], [0, 0, 0], [], 0, "CAN_COLLIDE"];
                _pool setDir (round (random 360));
                _pool setPosATL [getPosATL _tgt select 0, getPosATL _tgt select 1, 0];
                _pool setVectorUp surfaceNormal getPosATL _pool;
                _agent setPos (position _pool);
                _agent stop true;
                [_pool, ["roi_atk_01", 300]] remoteExec ["say3D"];
                uiSleep 2;
                _agent stop false;
            };
        };

        if (!alive _tgt) then {
            _agent setDir ([_agent, _tgt] call BIS_fnc_dirTo);
            _agent moveTo AGLToASL (_tgt modelToWorld [0, 0, 0]);
            uiSleep 2;
            _agent stop true;
            [_tgt, _agent] remoteExec [QFUNC(SwarmerEating), [0, -2] select isDedicated];
            _tgt hideObjectGlobal true;
            private _bones = createVehicle ["Land_HumanSkeleton_F", getPosATL _tgt, [], 0, "CAN_COLLIDE"];
            _bones setDir (round (random 360));
            _agent setVariable [QGVAR(tgt), objNull, true];
            missionNamespace setVariable ["ROOT_ANOMALIES_SWARMER_ATK", false, true];
            uiSleep 12;
            _agent stop false;
        };
    } else {
        _agent setVariable [QGVAR(isHive), false, true];
        missionNamespace setVariable ["ROOT_ANOMALIES_SWARMER_ATK", false, true];
        uiSleep 5;
    };
};

// Terminate API deletes the agent (+ hive) itself.
if !(_agent getVariable [EGVAR(main,terminate), false]) then {
    uiSleep 10;
    deleteVehicle _agent;
};
