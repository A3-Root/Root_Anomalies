#include "\z\root_anomalies\addons\screamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server backend that spawns and runs a Screamer anomaly: a static (or
 *              living) entity that emits a directional sonic blast, throwing and
 *              damaging targets in three range bands.
 *
 * Arguments:
 * 0: Marker name <STRING>
 * 1: Anomaly model classname <STRING>
 * 2: Damage close <NUMBER>
 * 3: Damage medium <NUMBER>
 * 4: Damage far <NUMBER>
 * 5: Territory radius <NUMBER>
 * 6: Hostile sides <ARRAY of SIDE>
 * 7: Attack radius <NUMBER>
 * 8: Affect vehicles <BOOL>
 * 9: AI engage <BOOL>
 * 10: AI panic <BOOL>
 * 11: Spawn side <SIDE>
 * 12: Health <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params [
    ["_marker", "", [""]],
    ["_model", "Land_AncientStatue_01_F", [""]],
    ["_dmgClose", 0.8, [0]],
    ["_dmgMedium", 0.4, [0]],
    ["_dmgFar", 0.2, [0]],
    ["_territory", 100, [0]],
    ["_hostiles", [east, west, civilian, resistance], [[]]],
    ["_radius", 50, [0]],
    ["_affectVehicles", true, [false]],
    ["_aiEngage", false, [false]],
    ["_aiPanic", false, [false]],
    ["_spawnSide", civilian, [civilian]],
    ["_health", 400, [0]],
    ["_config", createHashMap, [createHashMap]]
];

uiSleep 3;

private _bodyParts = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"];
private _screamTargets = ["CAManBase", "LandVehicle"];
private _screamDmgTypes = if (_affectVehicles) then {["Man", "LandVehicle", "Air"]} else {["Man"]};

private _markerPos = getMarkerPos _marker;
private _isAlive = false;
private _validStatue = false;
if (getNumber (configFile >> "CfgVehicles" >> _model >> "scope") > 0) then {
    if (_model isKindOf "Man") then {
        _isAlive = true;
    } else {
        _validStatue = !(_model isKindOf "LandVehicle");
    };
};

private _grp = createGroup [if (_aiEngage) then {_spawnSide} else {civilian}, true];
private _entity = objNull;
if (_isAlive) then {
    _entity = _grp createUnit [_model, _markerPos, [], 0, "NONE"];
} else {
    _entity = _grp createUnit ["O_Soldier_VR_F", _markerPos, [], 0, "NONE"];
    removeUniform _entity;
    removeVest _entity;
    removeHeadgear _entity;
};
[_entity] joinSilent _grp;

_entity setCaptive true;
_entity hideObjectGlobal true;
_entity setSpeaker "NoVoice";
_entity disableConversation true;
_entity addRating -10000;
removeAllItems _entity;
removeAllWeapons _entity;
_entity unassignItem "NVGoggles";
_entity removeItem "NVGoggles";
_entity setBehaviour "CARELESS";
_entity enableFatigue false;
_entity setSkill ["courage", 1];
_entity setUnitPos "UP";

private _bobs = [];
for "_i" from 1 to 3 do {
    private _bob = createVehicle ["Sign_Sphere25cm_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
    _bob hideObjectGlobal true;
    _bobs pushBack _bob;
};

private _anomaly = objNull;
private _hpHolder = _entity;
if (_isAlive) then {
    (_bobs select 0) attachTo [_entity, [0, -6, 0.5]];
    (_bobs select 1) attachTo [_entity, [0, -19, 0.5]];
    (_bobs select 2) attachTo [_entity, [0, -42, 0.5]];
} else {
    private _statueClass = ["Land_AncientStatue_01_F", _model] select _validStatue;
    _anomaly = createVehicle [_statueClass, [0, 0, 0], [], 0, "CAN_COLLIDE"];
    _anomaly attachTo [_entity, [0, 0.5, 0.5], "spine3"];
    _anomaly setVectorDirAndUp [[0, -1, 0], [0, 0, 1]];
    _anomaly setMass 1;
    (_bobs select 0) attachTo [_anomaly, [0, -6, 0.5]];
    (_bobs select 1) attachTo [_anomaly, [0, -19, 0.5]];
    (_bobs select 2) attachTo [_anomaly, [0, -42, 0.5]];
    _hpHolder = _anomaly;
};

_hpHolder setVariable [QGVAR(dmgTotal), 0];
_hpHolder setVariable [QGVAR(dmgIncr), 1 / _health];
_hpHolder removeAllEventHandlers "Hit";
_hpHolder removeAllEventHandlers "HandleDamage";
_hpHolder addEventHandler ["HandleDamage", {0}];
_hpHolder addEventHandler ["Hit", {
    params ["_unit", "_source"];
    if (_unit != _source) then {
        private _curr = (_unit getVariable [QGVAR(dmgTotal), 0]) + (_unit getVariable [QGVAR(dmgIncr), 0]);
        _unit setVariable [QGVAR(dmgTotal), _curr];
        if (_curr > 1) then {_unit setDamage 1};
        [_unit] remoteExec [QFUNC(ScreamerSplash), [0, -2] select isDedicated];
    };
}];
_hpHolder addEventHandler ["Killed", {
    params ["_unit", "_killer"];
    _unit hideObjectGlobal true;
    _killer addRating 2000;
}];

uiSleep 1;
private _entityObj = [_anomaly, _entity] select _isAlive;

// Register with the unified API (capture / sedation / getInstances).
[_entityObj, _config] call EFUNC(main,finalizeInstance);

LOG_DEBUG_2("ScreamerMain spawned at %1 (territory %2)",_markerPos,_territory);

while {alive _entity && {!(_entityObj getVariable [QGVAR(captured), false])}} do {
    _entity setUnitPos "UP";
    _entity doWatch objNull;
    private _near = (_markerPos nearEntities [_screamTargets, _territory]) - [_entity];

    if (count _near > 1) then {
        private _teleport = false;
        while {!_teleport && {alive _entity} && {!(_entityObj getVariable [QGVAR(captured), false])}} do {
            _entity setUnitPos "UP";
            _near = (_markerPos nearEntities [_screamTargets, _territory]) - [_entity];
            if (count _near < 2) then {_teleport = true};

            private _tgt = (_near select {((side _x) in _hostiles) && {typeOf _x != "VirtualCurator_F"} && {alive _x} && {(lifeState _x) != "INCAPACITATED"} && {_x != _entity} && {_x != _anomaly}}) param [0, _entity];
            if ((isNull _tgt) || {_tgt == _entity}) then {continue};

            private _targetPos = getPosATL _tgt;
            private _wave = createVehicle ["Land_Battery_F", position _entityObj, [], 0, "CAN_COLLIDE"];
            _wave setMass 10;
            _entityObj doMove _targetPos;
            [_entityObj, ["miscare_screamer", 300]] remoteExec ["say3D"];
            uiSleep 3;

            _entity lookAt (unitAimPosition _tgt vectorAdd (velocity _tgt vectorMultiply 0.01));
            uiSleep 2;
            doStop _entity;
            _entity lookAt (unitAimPosition _tgt vectorAdd (velocity _tgt vectorMultiply 0.01));
            uiSleep 1;

            private _pressure = 90;
            private _dir = getDir _entity;
            private _px = 0;
            private _py = 0;
            if (_dir <= 90) then {_px = linearConversion [0, 90, _dir, 0, 1, true]; _py = 1 - _px};
            if ((_dir > 90) && {_dir < 180}) then {_px = linearConversion [0, 90, _dir - 90, 1, 0, true]; _py = _px - 1};
            if ((_dir > 180) && {_dir < 270}) then {_px = linearConversion [0, 90, _dir - 180, 0, -1, true]; _py = (-1 * _px) - 1};
            if ((_dir > 270) && {_dir < 360}) then {_px = linearConversion [0, 90, _dir - 270, -1, 0, true]; _py = 1 + _px};

            if (_aiPanic) then {[_entity, _territory, _screamTargets] call FUNC(ScreamerAvoid)};

            private _anomalyPos = position _entityObj;
            private _overall = nearestObjects [_anomalyPos, _screamDmgTypes, _radius];
            private _front = _overall select {
                (_x != _anomaly) && {_x != _entity} && {
                    ((_entity getRelDir _x > 299) && {_entity getRelDir _x < 361}) || {(_entity getRelDir _x > -1) && {_entity getRelDir _x < 61}}
                }
            };

            private _r1 = [];
            private _r2 = [];
            private _r3 = [];
            {
                private _u = _x;
                private _d = _entityObj distance _u;
                if (_d > (_radius / 2)) then {
                    _r3 pushBack _u;
                } else {
                    if (_d < (_radius / 5)) then {_r1 pushBack _u} else {_r2 pushBack _u};
                };
            } forEach _front;
            _r1 = _r1 - [_entityObj];
            _r2 = _r2 - [_entityObj];
            _r3 = _r3 - [_entityObj];

            uiSleep 1;
            _wave attachTo [_entity, [0, -1, 1.5]];
            detach _wave;
            if (alive _entity) then {[_wave, _entityObj] remoteExec [QFUNC(ScreamerEffect), [0, -2] select isDedicated]};

            // Apply blast to the three range bands.
            private _bands = [[_r1, 2, [(_px * _pressure) / 2, (_py * _pressure) / 2], _dmgClose, 3], [_r2, 4, [(_px * _pressure) / 4, (_py * _pressure) / 4], _dmgMedium, 2], [_r3, 6, [(_px * _pressure) / 6, (_py * _pressure) / 6], _dmgFar, 1]];
            {
                _x params ["_band", "_torqueScale", "_pushXY", "_bandDmg", "_hits"];
                {
                    private _u = _x;
                    private _vel = velocity _u;
                    private _tempMass = getMass _u;
                    [_u, 3] remoteExec ["setMass", _u];
                    [_u, [_pushXY select 0, _pushXY select 1, (_vel select 2) + (random [3, 5, 8])]] remoteExec ["setVelocity", _u];
                    [_u, (_u vectorModelToWorld [_torqueScale, _torqueScale, _torqueScale])] remoteExec ["addTorque", _u];
                    if ((_u isKindOf "CAManBase") && {typeOf _u != "VirtualCurator_F"}) then {
                        for "_h" from 1 to _hits do {
                            [_u, _bandDmg, selectRandom _bodyParts, "backblast"] call EFUNC(main,applyDamage);
                        };
                    };
                    if (_affectVehicles && {(_u isKindOf "LandVehicle") || {_u isKindOf "Air"}}) then {
                        [_u, random _bandDmg] call FUNC(ScreamerVehicleDamage);
                    };
                    [_u, _tempMass] remoteExec ["setMass", _u];
                } forEach _band;
                uiSleep 0.1;
            } forEach _bands;

            _wave setVelocity [_px * _pressure, _py * _pressure, 0];
            uiSleep 1;
            deleteVehicle _wave;
            uiSleep 1;
        };
    } else {
        if (_entity distance _markerPos > 10) then {_entity doMove _markerPos} else {doStop _entity};
    };
    uiSleep 5;
};

[_entityObj] remoteExec [QFUNC(ScreamerTeleport), [0, -2] select isDedicated];
uiSleep 4;
{deleteVehicle _x} forEach _bobs;
if (!isNull _anomaly) then {deleteVehicle _anomaly};
deleteVehicle _entity;
