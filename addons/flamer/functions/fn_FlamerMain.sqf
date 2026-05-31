#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server backend that spawns and runs a Flamer anomaly (a burning,
 *              leaping creature that ignites and damages everything nearby).
 *
 * Arguments:
 * 0: Marker name <STRING>
 * 1: Territory radius <NUMBER>
 * 2: Damage fraction <NUMBER>
 * 3: Recharge delay <NUMBER>
 * 4: Health points <NUMBER>
 * 5: Death damage fraction <NUMBER>
 * 6: AI panic <BOOL>
 *
 * Return Value:
 * Flamer object <OBJECT>
 *
 * Public: No
 */

if (!isServer) exitWith {objNull};

params [
    ["_marker", "", [""]],
    ["_territory", 75, [0]],
    ["_damage", 0.4, [0]],
    ["_recharge", 1, [0]],
    ["_health", 400, [0]],
    ["_deathDamage", 1, [0]],
    ["_aiPanic", false, [false]]
];

private _bodyParts = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"];
private _weights = [0.47, 0.69, 0.59, 0.55, 0.61, 0.58];

// Burn everything within 20m: ACE-aware for people, hitpoint damage for vehicles.
private _burnNearby = {
    params ["_flamer", "_dmg", "_bodyParts", "_weights"];
    private _near = ((ASLToAGL getPosATL _flamer) nearEntities [["CAManBase", "LandVehicle", "Helicopter"], 20]) - [_flamer];
    {
        private _v = _x;
        if ((typeOf _v != "VirtualCurator_F") && {_v isKindOf "Man"}) then {
            private _bp = _bodyParts selectRandomWeighted _weights;
            [_v, _dmg, _bp, "burn"] call root_anomalies_main_fnc_applyDamage;
            [_v, [selectRandom ["04", "burned", "02", "03"], 200]] remoteExec ["say3D"];
        } else {
            if ((_v isKindOf "LandVehicle") || {_v isKindOf "Air"}) then {
                if ([_v] call root_anomalies_main_fnc_isAffectable) then {
                    {_v setHitPointDamage [_x, (_v getHitPointDamage _x) + random 0.3]} forEach ((getAllHitPointsDamage _v) param [0, []]);
                };
            };
        };
    } forEach _near;
};

private _findTarget = {
    params ["_flamer", "_terr"];
    ((ASLToAGL getPosATL _flamer) nearEntities [["CAManBase", "LandVehicle"], _terr]) - [_flamer]
};

private _hideFlamer = {
    params ["_flamer"];
    _flamer setVariable [QGVAR(visible), false, true];
    [_flamer getVariable [QGVAR(cap), _flamer], ["foc_initial", 1000]] remoteExec ["say3D"];
    _flamer enableSimulationGlobal false;
    _flamer hideObjectGlobal true;
};

private _showFlamer = {
    params ["_flamer", "_pozOrig", "_terr", "_dmg"];
    private _p = [_pozOrig, 1, _terr / 10, 3, 0, 20, 0] call BIS_fnc_findSafePos;
    _flamer setPos _p;
    _flamer setVariable [QGVAR(visible), true, true];
    [_flamer, _dmg, _pozOrig] remoteExec ["root_anomalies_flamer_fnc_FlamerSfx", [0, -2] select isDedicated];
    _flamer enableSimulationGlobal true;
    _flamer hideObjectGlobal false;
    {_flamer reveal _x} forEach (_flamer nearEntities [["CAManBase", "LandVehicle", "Helicopter"], 100]);
    [_flamer getVariable [QGVAR(cap), _flamer], ["foc_initial", 1000]] remoteExec ["say3D"];
};

private _avoidFlamer = {
    params ["_flamer", "_chased"];
    if (isPlayer _chased) exitWith {};
    private _rel = _chased getPos [30, (_flamer getDir _chased) + (random 33) * (selectRandom [1, -1])];
    _chased doMove _rel;
    _chased setSkill ["commanding", 1];
};

private _attkFlamer = {
    params ["_flamer", "_tgt", "_dmg", "_bodyParts", "_weights"];
    private _shootDir = (getPosATL _flamer vectorFromTo getPosATL _tgt) vectorMultiply 15;
    [_flamer getVariable [QGVAR(cap), _flamer], ["foc_initial", 500]] remoteExec ["say3D"];
    [_flamer, _shootDir] remoteExec ["root_anomalies_flamer_fnc_FlamerPlasma", [0, -2] select isDedicated];
    uiSleep 0.5;
    private _near = ((ASLToAGL getPosATL _flamer) nearEntities [["CAManBase", "LandVehicle", "Helicopter"], 20]) - [_flamer];
    {
        private _v = _x;
        if ((typeOf _v != "VirtualCurator_F") && {_v isKindOf "Man"}) then {
            private _bp = _bodyParts selectRandomWeighted _weights;
            [_v, _dmg, _bp, "burn"] call root_anomalies_main_fnc_applyDamage;
            [_v, [selectRandom ["04", "burned", "02", "03"], 200]] remoteExec ["say3D"];
        } else {
            if ((_v isKindOf "LandVehicle") || {_v isKindOf "Air"}) then {
                if ([_v] call root_anomalies_main_fnc_isAffectable) then {
                    {_v setHitPointDamage [_x, (_v getHitPointDamage _x) + random _dmg]} forEach ((getAllHitPointsDamage _v) param [0, []]);
                };
            };
        };
    } forEach _near;
    private _nearVik = nearestObjects [position _flamer, ["CAR", "TANK", "PLANE", "HELICOPTER", "Motorcycle", "Air"], 7, false];
    {_x setDamage (damage _x + (_dmg * 5))} forEach (_nearVik - [_flamer]);
    uiSleep 4;
    _flamer setVariable [QGVAR(atk), false];
};

private _jumpFlamer = {
    params ["_flamer", "_tgt", "_dmg", "_bodyParts", "_weights"];
    private _jumpDir = (getPosATL _flamer vectorFromTo getPosATL _tgt) vectorMultiply round (10 + random 10);
    private _blastSound = selectRandom ["01_blast", "02_blast", "03_blast"];
    private _veg = nearestTerrainObjects [position _flamer, ["TREE", "SMALL TREE", "BUSH", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "FOREST"], 20, false];
    private _nearVik = nearestObjects [position _flamer, ["CAR", "TANK", "PLANE", "HELICOPTER", "Motorcycle", "Air"], 20, false];
    [_flamer getVariable [QGVAR(cap), _flamer], [_blastSound, 200]] remoteExec ["say3D"];
    private _near = ((ASLToAGL getPosATL _flamer) nearEntities [["CAManBase", "LandVehicle"], 20]) - [_flamer];
    {
        private _v = _x;
        if ((typeOf _v != "VirtualCurator_F") && {_v isKindOf "Man"}) then {
            private _bp = _bodyParts selectRandomWeighted _weights;
            [_v, _dmg, _bp, "burn"] call root_anomalies_main_fnc_applyDamage;
            [_v, [selectRandom ["04", "burned", "02", "03"], 200]] remoteExec ["say3D"];
        } else {
            if ((_v isKindOf "LandVehicle") || {_v isKindOf "Air"}) then {
                if ([_v] call root_anomalies_main_fnc_isAffectable) then {
                    {_v setHitPointDamage [_x, (_v getHitPointDamage _x) + random _dmg]} forEach ((getAllHitPointsDamage _v) param [0, []]);
                };
            };
        };
    } forEach _near;
    _flamer setVelocity [_jumpDir select 0, _jumpDir select 1, round (10 + random 15)];
    {_x setDamage [1, false]; _x hideObjectGlobal true} forEach _veg;
    {_x setDamage (damage _x + _dmg)} forEach (_nearVik - [_flamer]);
};

uiSleep 2;

private _markerPos = getMarkerPos _marker;
private _flamer = createAgent ["O_Soldier_VR_F", _markerPos, [], 0, "NONE"];
_flamer setVariable ["BIS_fnc_animalBehaviour_disable", true];
_flamer setSpeaker "NoVoice";
_flamer disableConversation true;
_flamer addRating -10000;
_flamer setBehaviour "CARELESS";
_flamer enableFatigue false;
_flamer setSkill ["courage", 1];
_flamer setUnitPos "UP";
_flamer disableAI "ALL";
_flamer setMass 7000;
{_flamer enableAI _x} forEach ["MOVE", "ANIM", "TEAMSWITCH", "PATH"];

_flamer removeAllEventHandlers "HandleDamage";
_flamer removeAllEventHandlers "Hit";
_flamer addEventHandler ["HandleDamage", {0}];
_flamer setVariable [QGVAR(dmgTotal), 0];
_flamer setVariable [QGVAR(dmgIncr), 1 / _health];
_flamer addEventHandler ["Hit", {
    params ["_unit", "_source"];
    if (_unit != _source) then {
        private _curr = (_unit getVariable [QGVAR(dmgTotal), 0]) + (_unit getVariable [QGVAR(dmgIncr), 0]);
        _unit setVariable [QGVAR(dmgTotal), _curr];
        if (_curr > 1) then {_unit setDamage 1};
        [_unit] remoteExec ["root_anomalies_flamer_fnc_FlamerSplash"];
    };
}];
_flamer addEventHandler ["Killed", {
    params ["_unit", "_killer"];
    _unit hideObjectGlobal true;
    _killer addRating 2000;
}];

_flamer setAnimSpeedCoef 1.2;
private _cap = "Land_HelipadEmpty_F" createVehicle [0, 0, 0];
_cap attachTo [_flamer, [0, 0, 0.2], "neck"];
_flamer setVariable [QGVAR(cap), _cap, true];

for "_i" from 0 to 5 do {
    _flamer setObjectMaterialGlobal [_i, "\a3\data_f\default.rvmat"];
    uiSleep 0.1;
};
for "_i" from 0 to 5 do {
    _flamer setObjectTextureGlobal [_i, "\z\root_anomalies\addons\flamer\images\03_flesh.jpg"];
    uiSleep 0.1;
};

_flamer setVariable [QGVAR(atk), false];
[_flamer] call _hideFlamer;
[_flamer, _deathDamage] spawn root_anomalies_flamer_fnc_FlamerEnd;

LOG_DEBUG_2("FlamerMain spawned at %1 (territory %2)",_markerPos,_territory);

private _ckPl = false;
while {!_ckPl} do {
    {if (_x distance _markerPos < 1000) exitWith {_ckPl = true}} forEach allPlayers;
    uiSleep 5;
};

private _inRange = [];
while {alive _flamer} do {
    while {_inRange isEqualTo []} do {_inRange = [_flamer, _territory] call _findTarget; uiSleep 5};
    private _tgt = selectRandom (_inRange select {typeOf _x != "VirtualCurator_F"});
    [_flamer, _markerPos, _territory, _damage] call _showFlamer;

    while {(!isNil "_tgt") && {(alive _flamer) && {(_flamer distance _markerPos) < _territory}}} do {
        uiSleep _recharge;
        [_flamer, 0.03, _bodyParts, _weights] call _burnNearby;

        if (selectRandom [true, false, true, true, false]) then {
            _flamer moveTo AGLToASL (_tgt getRelPos [10, 180]);
            if (_aiPanic) then {[_flamer, _tgt] call _avoidFlamer};
        } else {
            [_flamer, 0.03, _bodyParts, _weights] call _burnNearby;
            [_flamer] remoteExec ["root_anomalies_flamer_fnc_FlamerJump", [0, -2] select isDedicated];
            [_flamer, _tgt, _damage, _bodyParts, _weights, _jumpFlamer] spawn {
                params ["_a", "_b", "_c", "_d", "_e", "_code"];
                [_a, _b, _c, _d, _e] call _code;
            };
        };

        uiSleep _recharge;
        [_flamer, 0.03, _bodyParts, _weights] call _burnNearby;

        if ((_flamer distance _tgt < 15) && {!(_flamer getVariable [QGVAR(atk), false])}) then {
            _flamer setVariable [QGVAR(atk), true];
            [_flamer, _tgt, _damage, _bodyParts, _weights, _attkFlamer] spawn {
                params ["_a", "_b", "_c", "_d", "_e", "_code"];
                [_a, _b, _c, _d, _e] call _code;
            };
            uiSleep 0.5;
            [_tgt] remoteExec ["root_anomalies_flamer_fnc_FlamerAtk"];
        };

        uiSleep _recharge;
        [_flamer, 0.03, _bodyParts, _weights] call _burnNearby;

        if ((!alive _tgt) || {_tgt distance _markerPos > _territory}) then {
            _inRange = [_flamer, _territory] call _findTarget;
            if (_inRange isNotEqualTo []) then {_tgt = selectRandom _inRange} else {_tgt = nil};
        };
    };

    [_flamer] call _hideFlamer;
    _tgt = nil;
    _inRange = [];
    uiSleep (_recharge + 2);
};

detach _cap;
deleteVehicle _cap;
uiSleep 5;
deleteVehicle _flamer;

_flamer
