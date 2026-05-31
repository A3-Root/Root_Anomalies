#include "\z\root_anomalies\addons\worm\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server backend that spawns and runs a Worm anomaly: a burrowing creature
 *              that erupts from the ground, leaps at targets and flings/damages them.
 *
 * Arguments:
 * 0: Marker name <STRING>
 * 1: Damage fraction <NUMBER>
 * 2: Territory radius <NUMBER>
 * 3: AI panic <BOOL>
 * 4: Diffuser classname ("" disables diffuser) <STRING>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params [
    ["_marker", "", [""]],
    ["_damage", 0.6, [0]],
    ["_territory", 200, [0]],
    ["_aiPanic", false, [false]],
    ["_diffuser", "SmokeShellGreen", [""]]
];

private _bodyParts = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"];
private _weights = [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];

// Convert a heading into a planar push vector [x, y].
private _pressDir = {
    params ["_dir"];
    private _px = 0;
    private _py = 0;
    if (_dir <= 90) then {_px = linearConversion [0, 90, _dir, 0, 1, true]; _py = 1 - _px};
    if ((_dir > 90) && {_dir < 180}) then {_px = linearConversion [0, 90, _dir - 90, 1, 0, true]; _py = _px - 1};
    if ((_dir > 180) && {_dir < 270}) then {_px = linearConversion [0, 90, _dir - 180, 0, -1, true]; _py = (-1 * _px) - 1};
    if ((_dir > 270) && {_dir < 360}) then {_px = linearConversion [0, 90, _dir - 270, -1, 0, true]; _py = 1 + _px};
    [_px, _py]
};

private _avoid = {
    params ["_origin", "_units"];
    {
        private _relDir = [_x, getPos _origin] call BIS_fnc_dirTo;
        private _fct = selectRandom [30, -30];
        private _opDir = if (_relDir < 180) then {_relDir + 180 + _fct} else {_relDir - 180 + _fct};
        _x doMove ([getPosATL _x, 20 + random 50, _opDir] call BIS_fnc_relPos);
        _x setSkill ["commanding", 1];
    } forEach _units;
};

private _vehicleDmg = {
    params ["_vehicle", "_dmg"];
    if !([_vehicle] call root_anomalies_main_fnc_isAffectable) exitWith {};
    {_vehicle setHitPointDamage [_x, (_vehicle getHitPointDamage _x) + random _dmg]} forEach ((getAllHitPointsDamage _vehicle) param [0, []]);
    {_vehicle setHitPointDamage [_x, 1]} forEach ["HitLight", "HitBatteries"];
};

uiSleep 2;

missionNamespace setVariable ["ROOT_ANOMALIES_WORM_DIFFUSER", _diffuser, true];

private _markerPos = getMarkerPos _marker;
private _head = createVehicle ["land_CanOpener_F", _markerPos, [], 0, "CAN_COLLIDE"];
private _tail = createVehicle ["land_CanOpener_F", _markerPos, [], 0, "CAN_COLLIDE"];
private _tail2 = createVehicle ["land_CanOpener_F", _markerPos, [], 0, "CAN_COLLIDE"];
_head setVariable [QGVAR(isWorm), true, true];
_tail attachTo [_head, [0, -1, 1]];
_tail2 attachTo [_tail, [0, -1, 1]];
[_tail, true] remoteExec ["hideObject", 0, true];
[_tail2, true] remoteExec ["hideObject", 0, true];

LOG_DEBUG_2("WormMain spawned at %1 (territory %2)",_markerPos,_territory);

// Emergence: wait for a target, then erupt.
private _hidden = true;
while {_hidden} do {
    uiSleep 2;
    private _near = (_markerPos nearEntities [["CAManBase", "LandVehicle"], _territory]);
    if (_near isNotEqualTo []) then {
        _hidden = false;
        private _tgt = selectRandom _near;
        ([(([getPos _head, _tgt] call BIS_fnc_dirTo) + 45)] call _pressDir) params ["_px", "_py"];
        [_head, _tail, _tail2] remoteExec ["root_anomalies_worm_fnc_WormEffect", [0, -2] select isDedicated, true];
        [_head, _tail] remoteExec ["root_anomalies_worm_fnc_WormAttack", [0, -2] select isDedicated];
        _head setPosATL [getPosATL _head select 0, getPosATL _head select 1, 2];
        _head setVelocity [_px * 5, _py * 5, 20 + random 10];
        uiSleep 1;
        [_tail, ["strigat", 1000]] remoteExec ["say3D"];
    };
};

uiSleep 1;
resetCamShake;
waitUntil {(getPosATL _head select 2) < 1};
[_head, ["bump", 500]] remoteExec ["say3D"];
addCamShake [1, 4, 23];
[_head, _tail] remoteExec ["root_anomalies_worm_fnc_WormAttack", [0, -2] select isDedicated];
[_head] remoteExec ["root_anomalies_worm_fnc_WormBump", [0, -2] select isDedicated];
uiSleep 1;

while {!isNull _head} do {
    private _near = (_markerPos nearEntities [["CAManBase", "LandVehicle"], _territory]) select {typeOf _x != "VirtualCurator_F"};
    if (_near isNotEqualTo []) then {
        private _tgt = selectRandom _near;

        if ((_tgt distance _head < 15) && {!(surfaceIsWater getPos _tgt)}) then {
            if (_aiPanic) then {[_head, _near] call _avoid};
            ([[getPos _head, _tgt] call BIS_fnc_dirTo] call _pressDir) params ["_px", "_py"];
            _head setVelocity [_px * 5, _py * 5, 15 + random 10];
            [_tail, [selectRandom ["salt_08", "salt_05"], 500]] remoteExec ["say3D"];
            uiSleep 0.5;
            waitUntil {(getPosATL _head select 2) < 1};
            [_head, _tail] remoteExec ["root_anomalies_worm_fnc_WormAttack", [0, -2] select isDedicated];

            {
                if ((_x != _head) && {_x != _tail} && {_x != _tail2} && {!(surfaceIsWater getPos _x)}) then {
                    if ((_x isKindOf "LandVehicle") || {_x isKindOf "Air"}) then {
                        [_x, [_px * 5, _py * 5, 15 + random 10]] remoteExec ["setVelocityModelSpace", _x];
                        [_x, _damage] call _vehicleDmg;
                    } else {
                        if ((typeOf _x != "VirtualCurator_F") && {_x isKindOf "CAManBase"}) then {
                            [_x, [_px * 5, _py * 5, 15 + random 10]] remoteExec ["setVelocityModelSpace", _x];
                            for "_h" from 1 to 5 do {
                                [_x, _damage, _bodyParts selectRandomWeighted _weights, selectRandom ["backblast", "bullet", "explosive", "grenade", "falling"]] call root_anomalies_main_fnc_applyDamage;
                            };
                        };
                    };
                };
            } forEach (nearestObjects [getPosATL _head, [], 25]);

            uiSleep 1;
            if (_aiPanic) then {[_head, _near] call _avoid};
            if (((getPosATL _head select 2) < 0) || {(getPosATL _head select 2) > 2}) then {
                _head setPos ([getPos _head, 0.5, 50, 10, 0, 1, 0] call BIS_fnc_findSafePos);
            };
            uiSleep 8;
            _head setPosATL [getPosATL _head select 0, getPosATL _head select 1, 2];
        };

        if ((_tgt distance _head > 15) && {!(surfaceIsWater getPos _tgt)}) then {
            if (_aiPanic) then {[_head, _near] call _avoid};
            private _moveSpeed = 8 + random 8;
            private _fct = selectRandom [10 + random -35, 10 + random 45];
            ([([getPos _head, _tgt] call BIS_fnc_dirTo) + _fct] call _pressDir) params ["_px", "_py"];
            [_tail, [selectRandom ["move_01", "move_02", "move_03", "move_04", "move_05", "move_06", "move_07", "move_08", "move_09", "move_10", "move_11", "move_12", "move_13", "move_14", "move_15"], 500]] remoteExec ["say3D"];
            _head setVelocity [_px * _moveSpeed, _py * _moveSpeed, 5 + random 5];
            uiSleep 2;
            _head setPosATL [getPosATL _head select 0, getPosATL _head select 1, 2];
        };
    } else {
        uiSleep 3;
    };
};
