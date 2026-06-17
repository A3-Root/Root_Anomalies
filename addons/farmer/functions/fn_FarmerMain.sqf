#include "\z\root_anomalies\addons\farmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server backend that spawns and runs a Farmer anomaly (a burrowing,
 *              teleporting shockwave creature). Shared by both front-ends.
 *
 * Arguments:
 * 0: Marker name <STRING>
 * 1: Territory radius <NUMBER>
 * 2: Damage fraction <NUMBER>
 * 3: Recharge delay <NUMBER>
 * 4: Health points <NUMBER>
 * 5: AI panic <BOOL>
 *
 * Return Value:
 * Farmer object <OBJECT>
 *
 * Public: No
 */

if (!isServer) exitWith {objNull};

params [
    ["_marker", "", [""]],
    ["_territory", 75, [0]],
    ["_damage", 0.6, [0]],
    ["_recharge", 5, [0]],
    ["_health", 400, [0]],
    ["_aiPanic", false, [false]],
    ["_config", createHashMap, [createHashMap]]
];

private _markerPos = getMarkerPos _marker;
private _farmer = createAgent ["C_Soldier_VR_F", _markerPos, [], 0, "NONE"];
_farmer setVariable ["BIS_fnc_animalbehaviour_disable", true];
_farmer setSpeaker "NoVoice";
_farmer disableConversation true;
_farmer addRating -10000;
_farmer setBehaviour "CARELESS";
_farmer enableFatigue false;
_farmer setSkill ["courage", 1];
_farmer setUnitPos "UP";
_farmer disableAI "ALL";
_farmer setMass 7000;
{_farmer enableAI _x} forEach ["move", "ANIM", "teamSwitch", "PATH"];

_farmer setVariable [QGVAR(dmgTotal), 0];
_farmer setVariable [QGVAR(dmgIncr), 1 / _health];

_farmer removeAllEventHandlers "Hit";
_farmer removeAllEventHandlers "HandleDamage";
_farmer addEventHandler ["HandleDamage", {0}];
_farmer addEventHandler ["Hit", {
    params ["_unit", "_source"];
    if (_unit != _source) then {
        private _curr = (_unit getVariable [QGVAR(dmgTotal), 0]) + (_unit getVariable [QGVAR(dmgIncr), 0]);
        _unit setVariable [QGVAR(dmgTotal), _curr];
        if (_curr > 1) then {
            if !(_unit getVariable [QGVAR(dying), false]) then {
                _unit setVariable [QGVAR(dying), true, true];
                // Warp-sound warning beat (like the Screamer) so players can flee the GBU.
                [_unit] spawn {
                    params ["_unit"];
                    [_unit, ["miscare_screamer", 300]] remoteExec ["say3D"];
                    uiSleep 3;
                    [_unit, "Unconscious", 1, true] call EFUNC(main,deathBlast);
                };
            };
        } else {
            [_unit] remoteExec [QFUNC(FarmerSplash), [0, -2] select isDedicated];
        };
    };
}];

for "_i" from 0 to 5 do {
    _farmer setObjectMaterialGlobal [_i, "\a3\data_f\default.rvmat"];
    uiSleep 0.1;
};
uiSleep 2;
for "_i" from 0 to 5 do {
    _farmer setObjectTextureGlobal [_i, "#(rgb,8,8,3)color(0,0.5,0,0.5)"];
    uiSleep 0.1;
};
uiSleep 0.5;
for "_i" from 0 to 5 do {
    _farmer setObjectTextureGlobal [_i, "a3\structures_f_mark\training\data\shootingmat_01_opfor_co.paa"];
    uiSleep 0.1;
};

[_farmer] call FUNC(FarmerHide);
_farmer enableSimulationGlobal false;

[_farmer, _config] call EFUNC(main,finalizeInstance);

LOG_DEBUG_2("FarmerMain spawned at %1 (territory %2)",_markerPos,_territory);

while {alive _farmer && {!(_farmer getVariable [EGVAR(main,captured), false])} && {!(_farmer getVariable [QGVAR(dying), false])} && {!(_farmer getVariable [EGVAR(main,terminate), false])}} do {
    private _cfg = _farmer getVariable [QGVAR(config), createHashMap];
    _territory = _cfg getOrDefault ["territory", _territory];
    _damage = _cfg getOrDefault ["damage", _damage];
    _recharge = _cfg getOrDefault ["recharge", _recharge];
    _aiPanic = _cfg getOrDefault ["aiPanic", _aiPanic];
    private _activation = _cfg getOrDefault ["activationRange", ROOT_ANOMALIES_DEFAULT_ACTIVATION];
    private _ckPl = false;
    _farmer setUnitPos "UP";
    while {!_ckPl && {!(_farmer getVariable [EGVAR(main,terminate), false])}} do {
        {
            if (_x distance _markerPos < _activation) exitWith {_ckPl = true};
        } forEach allPlayers;
        uiSleep 5;
    };

    private _inRange = [_farmer, _territory] call FUNC(FarmerFindTarget);
    private _tgt = selectRandom (_inRange select {
        (typeOf _x != "VirtualCurator_F") && {lifeState _x != "INCAPACITATED"} && {[_x, _farmer] call EFUNC(main,isAffectable)}
    });
    _farmer enableSimulationGlobal true;
    _farmer setUnitPos "UP";
    [_farmer, _markerPos] call FUNC(FarmerShow);

    while {
        (!isNil "_tgt") && {(alive _farmer) && {(_farmer distance _markerPos) < _territory} && {!(_farmer getVariable [EGVAR(main,captured), false])} && {!(_farmer getVariable [QGVAR(dying), false])} && {!(_farmer getVariable [EGVAR(main,terminate), false])}}
    } do {
        _cfg = _farmer getVariable [QGVAR(config), createHashMap];
        _territory = _cfg getOrDefault ["territory", _territory];
        _damage = _cfg getOrDefault ["damage", _damage];
        _recharge = _cfg getOrDefault ["recharge", _recharge];
        _farmer setDir (_farmer getRelDir _tgt);
        if ((_farmer distance _tgt) > 15) then {
            [_farmer] call FUNC(FarmerHide);
            [_farmer, _tgt] call FUNC(FarmerTravelPath);
            [_farmer, _farmer getVariable [QGVAR(newPos), _markerPos]] call FUNC(FarmerShow);
            if (_aiPanic) then {
                {[_farmer, _x] spawn FUNC(FarmerAvoid)} forEach _inRange;
            };
            uiSleep 1;
        };
        _farmer setUnitPos "UP";
        if ((_farmer distance _tgt) <= 15) then {
            uiSleep 1;
            [_farmer, _damage] call FUNC(FarmerAttack);
            if (_aiPanic) then {
                {[_farmer, _x] spawn FUNC(FarmerAvoid)} forEach _inRange;
            };
            uiSleep _recharge;
        } else {
            uiSleep (1 + random 2);
            [_farmer] call FUNC(FarmerHide);
        };
        _farmer setUnitPos "UP";
        if ((!alive _tgt) || {_tgt distance _markerPos > _territory}) then {
            _inRange = [_farmer, _territory] call FUNC(FarmerFindTarget);
            if (_inRange isNotEqualTo []) then {
                _tgt = selectRandom (_inRange select {(typeOf _x != "VirtualCurator_F") && {lifeState _x != "INCAPACITATED"} && {[_x, _farmer] call EFUNC(main,isAffectable)}});
            } else {
                _tgt = nil;
            };
        };
    };
    _farmer setUnitPos "UP";
    uiSleep 1;
    [_farmer] call FUNC(FarmerHide);
    _farmer enableSimulationGlobal false;
    _farmer setUnitPos "UP";
    _farmer setPos _markerPos;
};

// Death by damage runs its own cinematic (deathBlast deletes the entity); only clean up
// here for the capture / terminate exits.
if !(_farmer getVariable [QGVAR(dying), false]) then {
    [_farmer, ["eko", 100]] remoteExec ["say3D"];
    deleteVehicle _farmer;
};

_farmer
