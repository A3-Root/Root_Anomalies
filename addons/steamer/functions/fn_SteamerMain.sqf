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

private _markerPos = getMarkerPos _marker;
private _activation = (_config getOrDefault ["activationRange", ROOT_ANOMALIES_DEFAULT_ACTIVATION]);
private _ckPl = false;
while {!_ckPl} do {
    {if (_x distance _markerPos < _activation) exitWith {_ckPl = true}} forEach allPlayers;
    uiSleep 5;
};

private _steamer = createAgent ["O_Soldier_VR_F", _markerPos, [], 0, "NONE"];
_steamer hideObjectGlobal true;
_steamer enableSimulationGlobal false;
[_steamer] remoteExec [QFUNC(SteamerVoice), 0, true];

[_steamer, _config] call EFUNC(main,finalizeInstance);

LOG_DEBUG_2("SteamerMain spawned at %1 (territory %2)",_markerPos,_territory);

private _inRange = [];
while {alive _steamer && {!(_steamer getVariable [EGVAR(main,captured), false])} && {!(_steamer getVariable [EGVAR(main,terminate), false])}} do {
    private _cfg = _steamer getVariable [QGVAR(config), createHashMap];
    _territory = _cfg getOrDefault ["territory", _territory];
    _damage = _cfg getOrDefault ["damage", _damage];
    _recharge = _cfg getOrDefault ["recharge", _recharge];
    while {_inRange isEqualTo [] && {!(_steamer getVariable [EGVAR(main,terminate), false])}} do {_inRange = [_steamer, _territory] call FUNC(SteamerFindTarget); uiSleep 5};
    private _tgt = selectRandom (_inRange select {(typeOf _x != "VirtualCurator_F") && {[_x, _steamer] call EFUNC(main,isAffectable)}});
    uiSleep 0.5;

    while {(!isNil "_tgt") && {alive _steamer} && {!(_steamer getVariable [EGVAR(main,captured), false])} && {!(_steamer getVariable [EGVAR(main,terminate), false])}} do {
        _cfg = _steamer getVariable [QGVAR(config), createHashMap];
        _damage = _cfg getOrDefault ["damage", _damage];
        _recharge = _cfg getOrDefault ["recharge", _recharge];
        if (_travelPath) then {[_steamer, _tgt] call FUNC(SteamerTravelPath)};
        private _burstPos = ASLToAGL getPosATL _tgt;
        private _blowUnits = (_burstPos nearEntities [["CAManBase", "LandVehicle", "Air"], 10]) - [_steamer];
        [getPosATL _tgt, selectRandom [false, true, false, false]] remoteExec [QFUNC(SteamerBurst)];

        {
            private _u = _x;
            if ([_u, _steamer] call EFUNC(main,isAffectable)) then {
                if (_u isKindOf "CAManBase") then {
                    [_u, _damage, _bodyParts selectRandomWeighted _weights, selectRandom ["backblast", "bullet", "explosive", "grenade"], _steamer] call EFUNC(main,applyDamage);
                };
                if ((_u isKindOf "LandVehicle") || {_u isKindOf "Air"}) then {
                    [_u, _damage] call FUNC(SteamerKillVehicle);
                };
                if (isPlayer _u) then {[_burstPos, _u] remoteExec [QFUNC(SteamerRagdoll), _u]} else {[_burstPos, _u] spawn FUNC(SteamerRagdoll)};
            };
        } forEach _blowUnits;

        {[_x] call FUNC(SteamerAvoid)} forEach _inRange;
        uiSleep (4 + round (random _recharge));
        _inRange = [_steamer, _territory] call FUNC(SteamerFindTarget);
        if (_inRange isNotEqualTo []) then {_tgt = selectRandom _inRange} else {_tgt = nil};
    };
    _tgt = nil;
    _inRange = [];
};

// Terminate API removes the Steamer cleanly, without the death geyser/area damage.
if (_steamer getVariable [EGVAR(main,terminate), false]) exitWith {};

waitUntil {!alive _steamer};
[getPosATL _steamer] remoteExec [QFUNC(SteamerEnd), [0, -2] select isDedicated];

{_x setDamage [_deathDamage, true]} forEach nearestTerrainObjects [position _steamer, ["TREE", "SMALL TREE", "BUSH", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "FOREST"], 20, false];
{_x setDamage [_deathDamage, false]} forEach nearestObjects [position _steamer, ["BUILDING", "HOUSE", "CHURCH", "CHAPEL", "FUELSTATION", "HOSPITAL", "RUIN", "BUNKER", "Land_fs_roof_F", "Land_TTowerBig_2_F", "Land_TTowerBig_1_F", "Lamps_base_F", "PowerLines_base_F", "PowerLines_Small_base_F", "Land_LampStreet_small_F"], 20, false];
{
    if (typeOf _x != "VirtualCurator_F") then {
        [_x, _deathDamage, _bodyParts selectRandomWeighted _weights, selectRandom ["backblast", "bullet", "explosive", "grenade"], _steamer] call EFUNC(main,applyDamage);
    };
} forEach (_steamer nearEntities ["CAManBase", 20]);
{_x setDamage ((damage _x) + random [0, _deathDamage, 1])} forEach nearestObjects [position _steamer, ["CAR", "TANK", "PLANE", "HELICOPTER", "Motorcycle", "Air", "Ship"], 20, false];

uiSleep 10;
deleteVehicle _steamer;
