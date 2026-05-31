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
    ["_damage", 0.6, [0]]
];

if (isNull _hiveObj) exitWith {};

missionNamespace setVariable ["ROOT_ANOMALIES_SWARMER_PESTICIDE", _pesticide, true];

if (!isNil {_hiveObj getVariable QGVAR(activate)}) exitWith {};
_hiveObj setVariable [QGVAR(activate), true, true];

private _avoidHive = {
    params ["_hiver", "_chased"];
    if (isPlayer _chased) exitWith {};
    private _rel = _chased getPos [50, (_hiver getDir _chased) + (random 33) * (selectRandom [1, -1])];
    _chased doMove _rel;
    _chased setSkill ["commanding", 1];
};

private _findTarget = {
    params ["_hiver", "_terr", "_hiveObj"];
    ((getPosATL _hiveObj) nearEntities ["CAManBase", _terr]) - [_hiver]
};

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

[_agent] remoteExec ["Root_fnc_SwarmerVoice", [0, -2] select isDedicated];
[_agent] remoteExec ["Root_fnc_SwarmerSfx", [0, -2] select isDedicated];
missionNamespace setVariable ["ROOT_ANOMALIES_SWARMER_AGENT", _agent, true];
missionNamespace setVariable ["ROOT_ANOMALIES_SWARMER_ATK", false, true];

LOG_DEBUG_2("SwarmerMain spawned hive at %1 (territory %2)",position _hiveObj,_radius);

while {alive _agent} do {
    while {!(_agent getVariable [QGVAR(isHive), false])} do {
        {if (_x distance getPos _agent < 1000) exitWith {_agent setVariable [QGVAR(isHive), true, true]}} forEach allPlayers;
        uiSleep 10;
    };
    _agent setVariable [QGVAR(tgt), objNull, true];

    private _inRange = ([_agent, _radius, _hiveObj] call _findTarget) select {typeOf _x != "VirtualCurator_F"};
    if (_inRange isNotEqualTo []) then {
        private _tgt = selectRandom _inRange;
        _agent setVariable [QGVAR(tgt), _tgt, true];
        {[_agent, _x, _avoidHive] spawn {params ["_a", "_b", "_c"]; [_a, _b] call _c}} forEach _inRange;
        _agent disableCollisionWith _tgt;

        while {(alive _tgt) && {_tgt distance _hiveObj <= _radius}} do {
            if (_tgt distance _agent > 10) then {_agent moveTo AGLToASL (_tgt modelToWorld [0, 7, 0])};
            uiSleep 4;
            if ((_tgt distance _agent <= 10) && {alive _agent}) then {
                missionNamespace setVariable ["ROOT_ANOMALIES_SWARMER_ATK", true, true];
                _agent moveTo AGLToASL (_tgt modelToWorld [0, 0, 0]);
                [_tgt, _agent] remoteExec ["Root_fnc_SwarmerEating", [0, -2] select isDedicated];
                for "_h" from 1 to 5 do {
                    [_tgt, _damage, selectRandom ["head", "body", "hand_l", "hand_r", "leg_l", "leg_r"], selectRandom ["bullet", "explosive", "grenade", "punch", "ropeburn", "shell", "stab", "burn"]] call Root_fnc_applyDamage;
                };
                {[_agent, _x, _avoidHive] spawn {params ["_a", "_b", "_c"]; [_a, _b] call _c}} forEach _inRange;
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
            [_tgt, _agent] remoteExec ["Root_fnc_SwarmerEating", [0, -2] select isDedicated];
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

uiSleep 10;
deleteVehicle _agent;
