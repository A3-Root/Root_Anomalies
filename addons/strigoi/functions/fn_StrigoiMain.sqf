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
    ["_noseize", false, [false]],
    ["_aiPanic", false, [false]]
];

private _findTarget = {
    params ["_strigoi", "_terr"];
    ((ASLToAGL getPosATL _strigoi) nearEntities ["CAManBase", _terr]) - [_strigoi]
};

private _drain = {
    params ["_units"];
    {_x setFatigue ((getFatigue _x) + 0.1)} forEach _units;
};

private _avoid = {
    params ["_strigoi", "_chased"];
    if (isPlayer _chased) exitWith {};
    private _rel = _chased getPos [10, (_strigoi getDir _chased) + (random 33) * (selectRandom [1, -1])];
    _chased doMove _rel;
    _chased setSkill ["commanding", 1];
};

private _attk = {
    params ["_strigoi", "_tgt", "_dmg", "_noseize"];
    [_strigoi, _tgt, _noseize] remoteExec ["root_anomalies_strigoi_fnc_StrigoiViz", [0, -2] select isDedicated];
    if ((isPlayer _tgt) && {typeOf _tgt != "VirtualCurator_F"}) then {
        [_dmg, _noseize] remoteExec ["root_anomalies_strigoi_fnc_StrigoiTgt", _tgt];
    } else {
        if ((_tgt isKindOf "Man") && {_tgt != _strigoi} && {typeOf _tgt != "VirtualCurator_F"}) then {
            [_tgt, _dmg, ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65], selectRandom ["backblast", "bullet", "explosive", "grenade"]] call root_anomalies_main_fnc_applyDamage;
        };
    };
    uiSleep 1;
};

private _hide = {
    params ["_strigoi"];
    _strigoi setVariable [QGVAR(visible), false, true];
    [_strigoi getVariable [QGVAR(cap), _strigoi], ["03_tip_casp", 1000]] remoteExec ["say3D"];
    _strigoi enableSimulationGlobal false;
    _strigoi hideObjectGlobal true;
};

private _show = {
    params ["_strigoi", "_pozOrig", "_terr"];
    private _p = [_pozOrig, 1, _terr / 10, 3, 0, 20, 0] call BIS_fnc_findSafePos;
    _strigoi setPos _p;
    _strigoi setVariable [QGVAR(visible), true, true];
    [_strigoi] remoteExec ["root_anomalies_strigoi_fnc_StrigoiSfx", [0, -2] select isDedicated];
    _strigoi enableSimulationGlobal true;
    _strigoi hideObjectGlobal false;
    {_strigoi reveal _x} forEach (_strigoi nearEntities [["CAManBase"], 100]);
    [_strigoi getVariable [QGVAR(cap), _strigoi], ["03_tip_casp", 1000]] remoteExec ["say3D"];
};

private _salt1 = {
    params ["_strigoi", "_pozTgt", "_walker", "_anchor", "_cap", "_potPoz"];
    _walker setPos (_anchor getPos [2, _anchor getRelDir _pozTgt]);
    [_cap, [selectRandom ["01_salt", "02_salt", "03_salt"], 200]] remoteExec ["say3D"];
    _strigoi setVelocityTransformation [getPosATL _strigoi, getPosATL _walker, velocity _strigoi, velocity _walker, [0, 0, 0], [0, 0, 0], [0, 0, 1], [0, 0, 2], 0.3];
    _strigoi attachTo [_walker, [0, 0, (getPos _anchor select 2) + _potPoz / 4]];
    _strigoi setDir (_strigoi getRelDir _pozTgt);
    [_cap, [selectRandom ["01_tip_casp", "NoSound", "02_tip_casp", "03_tip_casp", "NoSound", "04_tip_casp", "05_tip_casp", "06_tip_casp", "07_tip_casp", "NoSound"], 500]] remoteExec ["say3D"];
};

private _salt2 = {
    params ["_strigoi", "_tgt", "_walker", "_anchor", "_cap"];
    private _jumpDir = (getPosATL _strigoi vectorFromTo getPosATL _tgt) vectorMultiply 10;
    _strigoi attachTo [_walker, [0, 0, ((boundingCenter _anchor) select 2) * 2]];
    [_cap, [selectRandom ["01_salt", "02_salt", "03_salt"], 200]] remoteExec ["say3D"];
    detach _strigoi;
    _strigoi setVelocity [_jumpDir select 0, _jumpDir select 1, 3];
};

private _jumpGround = {
    params ["_strigoi", "_tgt", "_cap"];
    private _jumpDir = (getPosATL _strigoi vectorFromTo getPosATL _tgt) vectorMultiply 15;
    [_cap, [selectRandom ["01_salt", "02_salt", "03_salt"], 200]] remoteExec ["say3D"];
    _strigoi setVelocity [_jumpDir select 0, _jumpDir select 1, round (5 + random 15)];
};

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
        [_unit] remoteExec ["root_anomalies_strigoi_fnc_StrigoiSplash", [0, -2] select isDedicated];
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
[_strigoi] call _hide;
[_strigoi] remoteExec ["root_anomalies_strigoi_fnc_StrigoiFatigue", [0, -2] select isDedicated, true];

LOG_DEBUG_2("StrigoiMain spawned at %1 (territory %2)",_markerPos,_territory);

private _inRange = [];
while {alive _strigoi} do {
    if (_nightOnly && {sunOrMoon >= 0.5}) then {
        if (_strigoi getVariable [QGVAR(visible), false]) then {[_strigoi] call _hide};
        uiSleep 30;
        continue;
    };

    while {_inRange isEqualTo []} do {_inRange = [_strigoi, _territory] call _findTarget; uiSleep 5};
    private _tgt = selectRandom (_inRange select {(typeOf _x != "VirtualCurator_F") && {lifeState _x != "INCAPACITATED"}});
    [_strigoi, _markerPos, _territory] call _show;

    while {(!isNil "_tgt") && {(alive _strigoi) && {(_strigoi distance _markerPos) < _territory}}} do {
        [_inRange] call _drain;
        _strigoi moveTo AGLToASL (_tgt getRelPos [10, 180]);
        if (_aiPanic) then {[_strigoi, _tgt] call _avoid};
        uiSleep 1;

        if (_strigoi distance _tgt < 40) then {
            [_strigoi, [selectRandom ["01_atk_bg", "02_atk", "03_atk", "04_atk"], 400]] remoteExec ["say3D"];
            [_strigoi, _tgt, _damage, _noseize] call _attk;
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
                        private _potPoz = (boundingCenter _x) select 2;
                        if ((_potPoz > 2) && {(abs (_angleTgt - _angleAnchor) < 60) && {_strigoi distance _x < 20}}) exitWith {
                            [_strigoi, _tgt, _walker, _x, _cap, _potPoz] call _salt1;
                            uiSleep 1;
                            [_strigoi, _tgt, _walker, _x, _cap] call _salt2;
                        };
                    } forEach _trees;
                };
            } else {
                [_strigoi, _tgt, _cap] call _jumpGround;
            };
        };

        if ((!alive _tgt) || {_tgt distance _markerPos > _territory}) then {
            _inRange = [_strigoi, _territory] call _findTarget;
            if (_inRange isNotEqualTo []) then {_tgt = selectRandom (_inRange select {(typeOf _x != "VirtualCurator_F") && {lifeState _x != "INCAPACITATED"}})} else {_tgt = nil};
        };
        uiSleep 1;
    };

    [_strigoi] call _hide;
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
