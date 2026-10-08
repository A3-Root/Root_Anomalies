#include "\z\root_anomalies\addons\wraith\script_component.hpp"
/*
 * Author: Root
 * Description: Server backend for the Wraith: a ground-bound stalker stitched together
 *              from Strigoi, Flamer and Farmer flesh. It walks and runs (no leaping) after
 *              the living in its territory and claws anyone it reaches. To the naked eye
 *              nothing is there; it only shows up through night vision and/or thermal
 *              optics (per instance), which each client decides locally in WraithViewLocal.
 *              Shared by both front-ends and the unified spawn API.
 *
 * Arguments:
 * 0: Marker name <STRING>
 * 1: Health (hits it can take) <NUMBER>
 * 2: Territory radius <NUMBER>
 * 3: Attack interval in seconds <NUMBER>
 * 4: Damage per claw 0..1 <NUMBER>
 * 5: Vision mode it shows up in: 0 night vision, 1 thermal, 2 both <NUMBER>
 * 6: Run speed multiplier <NUMBER>
 * 7: Config <HASHMAP>
 *
 * Return Value:
 * Wraith object <OBJECT>
 *
 * Example:
 * ["ROOT_ANOMALIES_WRAITH_0", 400, 150, 4, 0.3, 2, 1.2, createHashMap] spawn root_anomalies_wraith_fnc_WraithMain;
 *
 * Public: No
 */

if (!isServer) exitWith {objNull};

params [
    ["_marker", "", [""]],
    ["_health", 400, [0]],
    ["_territory", 150, [0]],
    ["_interval", 4, [0]],
    ["_damage", 0.3, [0]],
    ["_vision", 2, [0]],
    ["_speed", 1.2, [0]],
    ["_config", createHashMap, [createHashMap]]
];

private _bodyParts = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"];
private _weights = [0.4, 0.6, 0.6, 0.7, 0.6, 0.6];
private _markerPos = getMarkerPos _marker;

_config set ["visionMode", _vision];
_config set ["speed", _speed];

private _wraith = createAgent ["O_Soldier_VR_F", _markerPos, [], 0, "NONE"];
_wraith setVariable ["BIS_fnc_animalBehaviour_disable", true];
_wraith setSpeaker "NoVoice";
_wraith disableConversation true;
_wraith addRating -10000;
_wraith setBehaviour "CARELESS";
_wraith enableFatigue false;
_wraith setSkill ["courage", 1];
_wraith setUnitPos "UP";
_wraith disableAI "ALL";
{_wraith enableAI _x} forEach ["MOVE", "ANIM", "TEAMSWITCH", "PATH"];
_wraith setAnimSpeedCoef _speed;
_wraith setMass 7000;

// Patchwork of the other creatures: Flamer flesh, Farmer hide, Strigoi noise.
private _skins = [
    "\z\root_anomalies\addons\flamer\images\03_flesh.jpg",
    "a3\structures_f_mark\training\data\shootingmat_01_opfor_co.paa",
    "#(ai,512,512,1)perlinNoise(256,256,0,0.3)"
];
for "_i" from 0 to 5 do {
    _wraith setObjectMaterialGlobal [_i, "\a3\data_f\default.rvmat"];
    _wraith setObjectTextureGlobal [_i, _skins select (_i mod 3)];
};

// Hit counter health model: every hit chips away 1/health, damage itself is ignored.
_wraith setVariable [QGVAR(dmgTotal), 0];
_wraith setVariable [QGVAR(dmgIncr), 1 / (_health max 1)];
_wraith removeAllEventHandlers "HandleDamage";
_wraith addEventHandler ["HandleDamage", {0}];
_wraith addEventHandler ["Hit", {
    params ["_unit", "_source"];
    if (_unit isEqualTo _source) exitWith {};
    private _curr = (_unit getVariable [QGVAR(dmgTotal), 0]) + (_unit getVariable [QGVAR(dmgIncr), 0]);
    _unit setVariable [QGVAR(dmgTotal), _curr];
    if (_curr > 1 && {!(_unit getVariable [QGVAR(dying), false])}) then {
        _unit setVariable [QGVAR(dying), true, true];
        [_unit getVariable [QGVAR(voice), _unit], ["miscare_screamer", 300]] remoteExec ["say3D"];
        [{[_this, "Unconscious", 1, true] call EFUNC(main,deathBlast)}, _unit, 2] call CBA_fnc_waitAndExecute;
    };
}];

// Hidden objects do not reliably play sounds, so a never-hidden helper carries them.
private _voice = createVehicle ["Land_HelipadEmpty_F", _markerPos, [], 0, "CAN_COLLIDE"];
_voice attachTo [_wraith, [0, 0, 1.2]];
_wraith setVariable [QGVAR(voice), _voice, true];
_wraith setVariable [QEGVAR(main,extraDelete), [_voice], true];

// Every client decides on its own whether it can see the wraith (JIP safe).
[_wraith] remoteExec [QFUNC(WraithViewLocal), [0, -2] select isDedicated, _wraith];
[_wraith] remoteExec [QFUNC(WraithSfx), [0, -2] select isDedicated, _wraith];

[_wraith, _config] call EFUNC(main,finalizeInstance);

LOG_DEBUG_3("WraithMain spawned at %1 (territory %2, vision %3)",mapGridPosition _wraith,_territory,_vision);

private _nextAttack = 0;
while {
    alive _wraith
    && {!(_wraith getVariable [QEGVAR(main,captured), false])}
    && {!(_wraith getVariable [QGVAR(dying), false])}
    && {!(_wraith getVariable [QEGVAR(main,terminate), false])}
} do {
    [_wraith] call EFUNC(main,sedationHold);

    private _cfg = _wraith getVariable [QEGVAR(main,config), createHashMap];
    _territory = _cfg getOrDefault ["territory", _territory];
    _damage = _cfg getOrDefault ["damage", _damage];
    _interval = _cfg getOrDefault ["interval", _interval];
    _wraith setAnimSpeedCoef (_cfg getOrDefault ["speed", _speed]);
    private _activation = _cfg getOrDefault ["activationRange", ROOT_ANOMALIES_DEFAULT_ACTIVATION];

    if (allPlayers findIf {_x distance _markerPos < _activation} == -1) then {
        uiSleep 5;
        continue;
    };

    private _candidates = (_markerPos nearEntities [["CAManBase"], _territory]) select {
        alive _x && _x != _wraith && {typeOf _x != "VirtualCurator_F"} && {lifeState _x != "INCAPACITATED"} && {[_x, _wraith] call EFUNC(main,isAffectable)}
    };

    if (_candidates isEqualTo []) then {
        // Nothing to hunt: drift back home at a walk.
        if (_wraith distance2D _markerPos > 10) then {
            _wraith forceWalk true;
            _wraith moveTo (AGLToASL _markerPos);
        };
        uiSleep 3;
        continue;
    };

    private _tgt = ([_candidates, [], {_wraith distance _x}, "ASCEND"] call BIS_fnc_sortBy) select 0;
    private _dist = _wraith distance _tgt;

    // Walk while stalking from afar, break into a run once it closes in.
    _wraith forceWalk (_dist > 60);
    _wraith setDir (_wraith getDir _tgt);
    _wraith moveTo (AGLToASL (_tgt getPos [1, _tgt getDir _wraith]));

    if (_dist < 2.5 && {time >= _nextAttack}) then {
        _nextAttack = time + _interval;
        [_wraith, "AwopPercMstpSgthWnonDnon_end"] remoteExec ["switchMove", 0];
        [_voice, ["wraith_claw", 150]] remoteExec ["say3D"];
        [_voice, [selectRandom ["04_atk", "flamer_voice"], 300]] remoteExec ["say3D"];
        [_tgt, _damage, _bodyParts selectRandomWeighted _weights, "stab", _wraith] call EFUNC(main,applyDamage);
        LOG_DEBUG_2("WraithMain clawed %1 for %2",name _tgt,_damage);
    };

    uiSleep 0.5;
};

LOG_DEBUG_1("WraithMain loop ended for %1",_marker);

// Death by damage runs its own blast (deathBlast deletes the entity); the terminate API
// removes it itself. Only clean up after a capture here.
if (!(_wraith getVariable [QGVAR(dying), false]) && {!(_wraith getVariable [QEGVAR(main,terminate), false])}) then {
    uiSleep 3;
    deleteVehicle _voice;
    deleteVehicle _wraith;
};

_wraith
