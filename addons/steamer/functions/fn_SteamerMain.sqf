#include "\z\root_anomalies\addons\steamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server backend that spawns and runs a Steamer anomaly: an invisible
 *              entity that erupts geyser bursts beneath its targets.
 *
 * Arguments:
 * 0: Marker name <STRING>
 * 1: Territory radius <NUMBER>
 * 2: Damage fraction <NUMBER>
 * 3: Recharge delay <NUMBER>
 * 4: Death damage fraction <NUMBER>
 * 5: Show travel path <BOOL>
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
    ["_damage", 0.2, [0]],
    ["_recharge", 10, [0]],
    ["_deathDamage", 0.6, [0]],
    ["_travelPath", false, [false]],
    ["_config", createHashMap, [createHashMap]]
];

private _bodyParts = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"];
private _weights = [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];

private _findTarget = {
    params ["_steamer", "_terr"];
    ((ASLToAGL getPosATL _steamer) nearEntities ["CAManBase", _terr]) - [_steamer]
};

private _avoidSteam = {
    params ["_chased"];
    if (isPlayer _chased) exitWith {};
    private _rel = _chased getPos [10 + round (random 30), round (random 360)];
    _chased doMove _rel;
    _chased setSkill ["commanding", 1];
};

private _travel = {
    params ["_steamer", "_tgt"];
    private _rag = "Land_PenBlack_F" createVehicle [getPosATL _steamer select 0, getPosATL _steamer select 1, 3000];
    private _dir = (getPosATL _steamer vectorFromTo getPosATL _tgt) vectorMultiply 20;
    _rag setVelocity [_dir select 0, _dir select 1, 5];
    [_rag] remoteExec ["root_anomalies_steamer_fnc_SteamerTravel"];
    uiSleep 1;
    deleteVehicle _rag;
};

private _killVehicle = {
    params ["_vehicle", "_dmg"];
    if !([_vehicle] call root_anomalies_main_fnc_isAffectable) exitWith {};
    _vehicle setVelocity [25, 25, 25];
    {_vehicle setHitPointDamage [_x, (_vehicle getHitPointDamage _x) + random _dmg]} forEach ((getAllHitPointsDamage _vehicle) param [0, []]);
    {_vehicle setHitPointDamage [_x, 1]} forEach ["HitLight", "HitBatteries"];
};

private _markerPos = getMarkerPos _marker;
private _ckPl = false;
while {!_ckPl} do {
    {if (_x distance _markerPos < 1000) exitWith {_ckPl = true}} forEach allPlayers;
    uiSleep 5;
};

private _steamer = createAgent ["O_Soldier_VR_F", _markerPos, [], 0, "NONE"];
_steamer hideObjectGlobal true;
_steamer enableSimulationGlobal false;
[_steamer] remoteExec ["root_anomalies_steamer_fnc_SteamerVoice", 0, true];

[_steamer, _config] call root_anomalies_main_fnc_finalizeInstance;

LOG_DEBUG_2("SteamerMain spawned at %1 (territory %2)",_markerPos,_territory);

private _inRange = [];
while {alive _steamer && {!(_steamer getVariable [QGVAR(captured), false])}} do {
    while {_inRange isEqualTo []} do {_inRange = [_steamer, _territory] call _findTarget; uiSleep 5};
    private _tgt = selectRandom (_inRange select {typeOf _x != "VirtualCurator_F"});
    uiSleep 0.5;

    while {(!isNil "_tgt") && {alive _steamer} && {!(_steamer getVariable [QGVAR(captured), false])}} do {
        if (_travelPath) then {[_steamer, _tgt] call _travel};
        private _burstPoz = ASLToAGL getPosATL _tgt;
        private _blowUnits = (_burstPoz nearEntities [["CAManBase", "LandVehicle", "Air"], 10]) - [_steamer];
        [getPosATL _tgt, selectRandom [false, true, false, false]] remoteExec ["root_anomalies_steamer_fnc_SteamerBurst"];

        {
            private _u = _x;
            if (_u isKindOf "CAManBase") then {
                [_u, _damage, _bodyParts selectRandomWeighted _weights, selectRandom ["backblast", "bullet", "explosive", "grenade"]] call root_anomalies_main_fnc_applyDamage;
            };
            if ((_u isKindOf "LandVehicle") || {_u isKindOf "Air"}) then {
                [_u, _damage] call _killVehicle;
            };
            if (isPlayer _u) then {[_burstPoz, _u] remoteExec ["root_anomalies_steamer_fnc_SteamerRagdoll", _u]} else {[_burstPoz, _u] spawn root_anomalies_steamer_fnc_SteamerRagdoll};
        } forEach _blowUnits;

        {[_x] call _avoidSteam} forEach _inRange;
        uiSleep (4 + round (random _recharge));
        _inRange = [_steamer, _territory] call _findTarget;
        if (_inRange isNotEqualTo []) then {_tgt = selectRandom _inRange} else {_tgt = nil};
    };
    _tgt = nil;
    _inRange = [];
};

waitUntil {!alive _steamer};
[getPosATL _steamer] remoteExec ["root_anomalies_steamer_fnc_SteamerEnd", [0, -2] select isDedicated];

{_x setDamage [_deathDamage, true]} forEach nearestTerrainObjects [position _steamer, ["TREE", "SMALL TREE", "BUSH", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "FOREST"], 20, false];
{_x setDamage [_deathDamage, false]} forEach nearestObjects [position _steamer, ["BUILDING", "HOUSE", "CHURCH", "CHAPEL", "FUELSTATION", "HOSPITAL", "RUIN", "BUNKER", "Land_fs_roof_F", "Land_TTowerBig_2_F", "Land_TTowerBig_1_F", "Lamps_base_F", "PowerLines_base_F", "PowerLines_Small_base_F", "Land_LampStreet_small_F"], 20, false];
{
    if (typeOf _x != "VirtualCurator_F") then {
        [_x, _deathDamage, _bodyParts selectRandomWeighted _weights, selectRandom ["backblast", "bullet", "explosive", "grenade"]] call root_anomalies_main_fnc_applyDamage;
    };
} forEach (_steamer nearEntities ["CAManBase", 20]);
{_x setDamage ((damage _x) + random [0, _deathDamage, 1])} forEach nearestObjects [position _steamer, ["CAR", "TANK", "PLANE", "HELICOPTER", "Motorcycle", "Air", "Ship"], 20, false];

uiSleep 10;
deleteVehicle _steamer;
