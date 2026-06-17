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
    ["_aiPanic", false, [false]],
    ["_config", createHashMap, [createHashMap]]
];

private _bodyParts = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"];
private _weights = [0.47, 0.69, 0.59, 0.55, 0.61, 0.58];

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
        if (_curr > 1) then {
            if !(_unit getVariable [QGVAR(dying), false]) then {
                _unit setVariable [QGVAR(dying), true, true];
                _unit switchMove "Unconscious";
                [{_this setDamage 1}, _unit, 1.2] call CBA_fnc_waitAndExecute;
            };
        } else {
            [_unit] remoteExec [QFUNC(FlamerSplash)];
        };
    };
}];
_flamer addEventHandler ["Killed", {
    params ["_unit", "_killer"];
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
[_flamer] call FUNC(FlamerHide);
[_flamer, _deathDamage] spawn FUNC(FlamerEnd);

[_flamer, _config] call EFUNC(main,finalizeInstance);

LOG_DEBUG_2("FlamerMain spawned at %1 (territory %2)",_markerPos,_territory);

private _activation = (_flamer getVariable [QGVAR(config), createHashMap]) getOrDefault ["activationRange", ROOT_ANOMALIES_DEFAULT_ACTIVATION];
private _ckPl = false;
while {!_ckPl && {!(_flamer getVariable [EGVAR(main,terminate), false])}} do {
    {if (_x distance _markerPos < _activation) exitWith {_ckPl = true}} forEach allPlayers;
    uiSleep 5;
};

private _inRange = [];
while {alive _flamer && {!(_flamer getVariable [EGVAR(main,captured), false])} && {!(_flamer getVariable [QGVAR(dying), false])} && {!(_flamer getVariable [EGVAR(main,terminate), false])}} do {
    private _cfg = _flamer getVariable [QGVAR(config), createHashMap];
    _territory = _cfg getOrDefault ["territory", _territory];
    _damage = _cfg getOrDefault ["damage", _damage];
    _recharge = _cfg getOrDefault ["recharge", _recharge];
    while {_inRange isEqualTo [] && {!(_flamer getVariable [EGVAR(main,terminate), false])}} do {_inRange = [_flamer, _territory] call FUNC(FlamerFindTarget); uiSleep 5};
    private _tgt = selectRandom (_inRange select {(typeOf _x != "VirtualCurator_F") && {[_x, _flamer] call EFUNC(main,isAffectable)}});
    [_flamer, _markerPos, _territory, _damage] call FUNC(FlamerShow);

    while {(!isNil "_tgt") && {(alive _flamer) && {(_flamer distance _markerPos) < _territory} && {!(_flamer getVariable [EGVAR(main,captured), false])} && {!(_flamer getVariable [QGVAR(dying), false])} && {!(_flamer getVariable [EGVAR(main,terminate), false])}}} do {
        _cfg = _flamer getVariable [QGVAR(config), createHashMap];
        _damage = _cfg getOrDefault ["damage", _damage];
        _recharge = _cfg getOrDefault ["recharge", _recharge];
        uiSleep _recharge;
        [_flamer, 0.03, _bodyParts, _weights] call FUNC(FlamerBurn);

        if (selectRandom [true, false, true, true, false]) then {
            _flamer moveTo AGLToASL (_tgt getRelPos [10, 180]);
            if (_aiPanic) then {[_flamer, _tgt] call FUNC(FlamerAvoid)};
        } else {
            [_flamer, 0.03, _bodyParts, _weights] call FUNC(FlamerBurn);
            [_flamer] remoteExec [QFUNC(FlamerJump), [0, -2] select isDedicated];
            [_flamer, _tgt, _damage, _bodyParts, _weights] spawn FUNC(FlamerLeap);
        };

        uiSleep _recharge;
        [_flamer, 0.03, _bodyParts, _weights] call FUNC(FlamerBurn);

        if ((_flamer distance _tgt < 15) && {!(_flamer getVariable [QGVAR(atk), false])}) then {
            _flamer setVariable [QGVAR(atk), true];
            [_flamer, _tgt, _damage, _bodyParts, _weights] spawn FUNC(FlamerAttack);
            uiSleep 0.5;
            [_tgt] remoteExec [QFUNC(FlamerAtk)];
        };

        uiSleep _recharge;
        [_flamer, 0.03, _bodyParts, _weights] call FUNC(FlamerBurn);

        if ((!alive _tgt) || {_tgt distance _markerPos > _territory}) then {
            _inRange = [_flamer, _territory] call FUNC(FlamerFindTarget);
            private _valid = _inRange select {(typeOf _x != "VirtualCurator_F") && {[_x, _flamer] call EFUNC(main,isAffectable)}};
            if (_valid isNotEqualTo []) then {_tgt = selectRandom _valid} else {_tgt = nil};
        };
    };

    [_flamer] call FUNC(FlamerHide);
    _tgt = nil;
    _inRange = [];
    uiSleep (_recharge + 2);
};

detach _cap;
deleteVehicle _cap;
uiSleep 5;
deleteVehicle _flamer;

_flamer
