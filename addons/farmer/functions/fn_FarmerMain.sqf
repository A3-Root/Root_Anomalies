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
    ["_aiPanic", false, [false]]
];

private _findTarget = {
    params ["_farmer", "_teritoriu"];
    ((ASLToAGL getPosATL _farmer) nearEntities [["CAManBase", "LandVehicle"], _teritoriu]) - [_farmer]
};

private _hideFarmer = {
    params ["_farmer"];
    _farmer setAnimSpeedCoef 0.8;
    _farmer switchMove "AmovPknlMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon";
    _farmer setVariable [QGVAR(visible), false, true];
    [_farmer, ["pietre", 1000]] remoteExec ["say3D"];
    [_farmer] remoteExec ["root_anomalies_farmer_fnc_FarmerTeleport", [0, -2] select isDedicated];
    _farmer hideObjectGlobal true;
};

private _showFarmer = {
    params ["_farmer", "_pozOrig"];
    _farmer setPos _pozOrig;
    _farmer setVariable [QGVAR(visible), true, true];
    [_farmer, ["punch_7", 1000]] remoteExec ["say3D"];
    _farmer hideObjectGlobal false;
    [_farmer] remoteExec ["root_anomalies_farmer_fnc_FarmerTeleport", [0, -2] select isDedicated];
    _farmer setAnimSpeedCoef 0.8;
    _farmer switchMove "AmovPknlMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon";
    _farmer setUnitPos "UP";
    uiSleep 1;
    [_farmer, ["eko", 1000]] remoteExec ["say3D"];
};

private _avoidFarmer = {
    params ["_strig", "_chased"];
    if (isPlayer _chased) exitWith {};
    private _relPos = _chased getPos [25, round ((_strig getDir _chased) + (random 33) * (selectRandom [1, -1]))];
    _chased doMove _relPos;
    _chased setSkill ["commanding", 1];
};

private _attkFarmer = {
    params ["_farmer", "_damageFarmer"];
    _farmer setUnitPos "UP";
    [_farmer, _damageFarmer] remoteExec ["root_anomalies_farmer_fnc_FarmerShock", [0, -2] select isDedicated];
    private _targets = ((ASLToAGL getPosATL _farmer) nearEntities [["CAManBase", "LandVehicle"], 20]) - [_farmer];

    uiSleep 1.2;
    {
        private _victim = _x;
        if (!(isPlayer _victim) && {_victim != _farmer}) then {
            private _jumpDir = (getPosATL _farmer vectorFromTo getPosATL _victim) vectorMultiply 3;
            private _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
            if ((typeOf _victim != "VirtualCurator_F") && {_victim isKindOf "CAManBase"}) then {
                _victim setVelocity [_jumpDir select 0, _jumpDir select 1, 9];
                [_victim, _damageFarmer, _bodyPart, "falling"] call root_anomalies_main_fnc_applyDamage;
            };
        };
        if ((_victim isKindOf "LandVehicle") && {_victim != _farmer}) then {
            private _jumpDir = (getPosATL _farmer vectorFromTo getPosATL _victim) vectorMultiply 5;
            _victim setVelocity [_jumpDir select 0, _jumpDir select 1, 7];
            if ([_victim] call root_anomalies_main_fnc_isAffectable) then {
                private _hitPoints = (getAllHitPointsDamage _victim) param [0, []];
                {
                    private _dmg = random [0, _damageFarmer, 1];
                    _victim setHitPointDamage [_x, (_victim getHitPointDamage _x) + _dmg];
                } forEach _hitPoints;
            };
        };
    } forEach _targets;
};

private _travelFarmer = {
    params ["_farmer", "_tgtFarmer"];
    _farmer setUnitPos "DOWN";
    private _rag = "Land_PenBlack_F" createVehicle [getPosATL _farmer select 0, getPosATL _farmer select 1, 3000];
    private _jumpDir = (getPosATL _farmer vectorFromTo getPosATL _tgtFarmer) vectorMultiply 20;
    _rag setVelocity [_jumpDir select 0, _jumpDir select 1, 5];
    [_rag] remoteExec ["root_anomalies_farmer_fnc_FarmerTravel", [0, -2] select isDedicated];
    uiSleep (round (2 + random 2));
    _farmer setVariable [QGVAR(newPos), getPos _rag];
    deleteVehicle _rag;
};

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
        if (_curr > 1) then {_unit setDamage 1};
        [_unit] remoteExec ["root_anomalies_farmer_fnc_FarmerSplash", [0, -2] select isDedicated];
    };
}];
_farmer addEventHandler ["Killed", {
    params ["_unit", "_killer"];
    _unit hideObjectGlobal true;
    _killer addRating 2000;
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

[_farmer] call _hideFarmer;
_farmer enableSimulationGlobal false;

LOG_DEBUG_2("FarmerMain spawned at %1 (territory %2)",_markerPos,_territory);

while {alive _farmer} do {
    private _ckPl = false;
    _farmer setUnitPos "UP";
    while {!_ckPl} do {
        {
            if (_x distance _markerPos < 1000) exitWith {_ckPl = true};
        } forEach allPlayers;
        uiSleep 5;
    };

    private _inRange = [_farmer, _territory] call _findTarget;
    private _tgt = selectRandom (_inRange select {
        (typeOf _x != "VirtualCurator_F") && {lifeState _x != "INCAPACITATED"}
    });
    _farmer enableSimulationGlobal true;
    _farmer setUnitPos "UP";
    [_farmer, _markerPos] call _showFarmer;

    while {
        (!isNil "_tgt") && {(alive _farmer) && {(_farmer distance _markerPos) < _territory}}
    } do {
        _farmer setDir (_farmer getRelDir _tgt);
        if ((_farmer distance _tgt) > 15) then {
            [_farmer] call _hideFarmer;
            [_farmer, _tgt] call _travelFarmer;
            [_farmer, _farmer getVariable [QGVAR(newPos), _markerPos]] call _showFarmer;
            if (_aiPanic) then {
                {[_farmer, _x, _avoidFarmer] spawn {params ["_a", "_b", "_code"]; [_a, _b] call _code}} forEach _inRange;
            };
            uiSleep 1;
        };
        _farmer setUnitPos "UP";
        if ((_farmer distance _tgt) <= 15) then {
            uiSleep 1;
            [_farmer, _damage] call _attkFarmer;
            if (_aiPanic) then {
                {[_farmer, _x, _avoidFarmer] spawn {params ["_a", "_b", "_code"]; [_a, _b] call _code}} forEach _inRange;
            };
            uiSleep _recharge;
        } else {
            uiSleep (1 + random 2);
            [_farmer] call _hideFarmer;
        };
        _farmer setUnitPos "UP";
        if ((!alive _tgt) || {_tgt distance _markerPos > _territory}) then {
            _inRange = [_farmer, _territory] call _findTarget;
            if (_inRange isNotEqualTo []) then {
                _tgt = selectRandom (_inRange select {(typeOf _x != "VirtualCurator_F") && {lifeState _x != "INCAPACITATED"}});
            } else {
                _tgt = nil;
            };
        };
    };
    _farmer setUnitPos "UP";
    uiSleep 1;
    [_farmer] call _hideFarmer;
    _farmer enableSimulationGlobal false;
    _farmer setUnitPos "UP";
    _farmer setPos _markerPos;
};

[_farmer, ["eko", 100]] remoteExec ["say3D"];
deleteVehicle _farmer;

_farmer
