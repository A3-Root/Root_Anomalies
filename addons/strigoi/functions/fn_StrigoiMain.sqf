#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server backend that spawns and runs a Strigoi anomaly: an invisible
 *              spectral entity that drains stamina, hops between trees and attacks.
 *
 * Arguments:
 * 0: Marker name <STRING>
 * 1: Territory radius <NUMBER>
 * 2: Night only <BOOL>
 * 3: Damage fraction <NUMBER>
 * 4: Health points <NUMBER>
 * 5: Seizure-safe <BOOL>
 * 6: AI panic <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params [
    ["_marker", "", [""]],
    ["_territory", 75, [0]],
    ["_nightOnly", false, [false]],
    ["_damage", 0.6, [0]],
    ["_health", 400, [0]],
    ["_seizureSafe", false, [false]],
    ["_aiPanic", false, [false]],
    ["_config", createHashMap, [createHashMap]]
];

uiSleep 2;

private _markerPos = getMarkerPos _marker;
private _ckPl = false;
while {!_ckPl} do {
    {if (_x distance _markerPos < 1000) exitWith {_ckPl = true}} forEach allPlayers;
    uiSleep 10;
};

private _strigoi = createAgent ["C_Soldier_VR_F", _markerPos, [], 0, "NONE"];
_strigoi setVariable ["BIS_fnc_animalBehaviour_disable", true];
_strigoi setSpeaker "NoVoice";
_strigoi disableConversation true;
_strigoi addRating -10000;
_strigoi setBehaviour "CARELESS";
_strigoi enableFatigue false;
_strigoi setSkill ["courage", 1];
_strigoi setUnitPos "UP";
_strigoi disableAI "ALL";
_strigoi setMass 7000;
{_strigoi enableAI _x} forEach ["MOVE", "ANIM", "TEAMSWITCH", "PATH"];

_strigoi setVariable [QGVAR(dmgTotal), 0];
_strigoi setVariable [QGVAR(dmgIncr), 1 / _health];
_strigoi removeAllEventHandlers "Hit";
_strigoi removeAllEventHandlers "HandleDamage";
_strigoi addEventHandler ["HandleDamage", {0}];
_strigoi addEventHandler ["Hit", {
    params ["_unit", "_source"];
    if (_unit != _source) then {
        private _curr = (_unit getVariable [QGVAR(dmgTotal), 0]) + (_unit getVariable [QGVAR(dmgIncr), 0]);
        _unit setVariable [QGVAR(dmgTotal), _curr];
        if (_curr > 1) then {_unit setDamage 1};
        [_unit] remoteExec [QFUNC(StrigoiSplash), [0, -2] select isDedicated];
    };
}];
_strigoi addEventHandler ["Killed", {
    params ["_unit", "_killer"];
    _unit hideObjectGlobal true;
    _killer addRating 2000;
}];

_strigoi setAnimSpeedCoef 1.1;
private _walker = "Land_HelipadEmpty_F" createVehicle [getPosATL _strigoi select 0, getPosATL _strigoi select 1, 20];
private _cap = "Land_HelipadEmpty_F" createVehicle [0, 0, 0];
_cap attachTo [_strigoi, [0, 0, 0.2], "neck"];
_strigoi setVariable [QGVAR(cap), _cap, true];
for "_i" from 0 to 5 do {_strigoi setObjectMaterialGlobal [_i, "A3\Structures_F\Data\Windows\window_set.rvmat"]; uiSleep 0.1};
uiSleep 0.3;
for "_i" from 0 to 5 do {_strigoi setObjectTextureGlobal [_i, "#(ai,512,512,1)perlinNoise(256,256,0,0.3)"]; uiSleep 0.1};
[_strigoi] call FUNC(StrigoiHide);
[_strigoi] remoteExec [QFUNC(StrigoiFatigue), [0, -2] select isDedicated, true];

[_strigoi, _config] call EFUNC(main,finalizeInstance);

LOG_DEBUG_2("StrigoiMain spawned at %1 (territory %2)",_markerPos,_territory);

private _inRange = [];
while {alive _strigoi && {!(_strigoi getVariable [QGVAR(captured), false])}} do {
    if (_nightOnly && {sunOrMoon >= 0.5}) then {
        if (_strigoi getVariable [QGVAR(visible), false]) then {[_strigoi] call FUNC(StrigoiHide)};
        uiSleep 30;
        continue;
    };

    while {_inRange isEqualTo []} do {_inRange = [_strigoi, _territory] call FUNC(StrigoiFindTarget); uiSleep 5};
    private _tgt = selectRandom (_inRange select {(typeOf _x != "VirtualCurator_F") && {lifeState _x != "INCAPACITATED"}});
    [_strigoi, _markerPos, _territory] call FUNC(StrigoiShow);

    while {(!isNil "_tgt") && {(alive _strigoi) && {(_strigoi distance _markerPos) < _territory}}} do {
        [_inRange] call FUNC(StrigoiDrain);
        _strigoi moveTo AGLToASL (_tgt getRelPos [10, 180]);
        if (_aiPanic) then {[_strigoi, _tgt] call FUNC(StrigoiAvoid)};
        uiSleep 1;

        if (_strigoi distance _tgt < 40) then {
            [_strigoi, [selectRandom ["01_atk_bg", "02_atk", "03_atk", "04_atk"], 400]] remoteExec ["say3D"];
            [_strigoi, _tgt, _damage, _seizureSafe] call FUNC(StrigoiAttack);
            uiSleep 1;
        };

        if (selectRandom [true, false]) then {
            if (selectRandom [true, false]) then {
                private _trees = nearestTerrainObjects [_tgt, ["TREE"], 20];
                if (_trees isNotEqualTo []) then {
                    uiSleep 1;
                    {
                        private _angleTgt = _strigoi getRelDir _tgt;
                        private _angleAnchor = _strigoi getRelDir _x;
                        private _anchorHeight = (boundingCenter _x) select 2;
                        if ((_anchorHeight > 2) && {(abs (_angleTgt - _angleAnchor) < 60) && {_strigoi distance _x < 20}}) exitWith {
                            [_strigoi, _tgt, _walker, _x, _cap, _anchorHeight] call FUNC(StrigoiPerch);
                            uiSleep 1;
                            [_strigoi, _tgt, _walker, _x, _cap] call FUNC(StrigoiLeap);
                        };
                    } forEach _trees;
                };
            } else {
                [_strigoi, _tgt, _cap] call FUNC(StrigoiJump);
            };
        };

        if ((!alive _tgt) || {_tgt distance _markerPos > _territory}) then {
            _inRange = [_strigoi, _territory] call FUNC(StrigoiFindTarget);
            if (_inRange isNotEqualTo []) then {_tgt = selectRandom (_inRange select {(typeOf _x != "VirtualCurator_F") && {lifeState _x != "INCAPACITATED"}})} else {_tgt = nil};
        };
        uiSleep 1;
    };

    [_strigoi] call FUNC(StrigoiHide);
    _tgt = nil;
    _inRange = [];
    _strigoi moveTo _markerPos;
    uiSleep 5;
};

deleteVehicle _walker;
detach _cap;
deleteVehicle _cap;
uiSleep 5;
deleteVehicle _strigoi;
