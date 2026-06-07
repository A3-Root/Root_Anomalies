#include "\z\root_anomalies\addons\wraith\script_component.hpp"
/*
 * Author: Root
 * Description: Server backend for the Wraith: a floating entity that teleport-stalks
 *              the nearest living target, burning everyone in its fear radius.
 *
 * Arguments:
 * 0: Marker name <STRING>
 * 1: Model classname <STRING>
 * 2: Health points <NUMBER>
 * 3: Territory radius <NUMBER>
 * 4: Attack interval <NUMBER>
 * 5: Damage fraction <NUMBER>
 * 6: Fear radius <NUMBER>
 * 7: Seizure-safe <BOOL>
 *
 * Return Value:
 * Wraith object <OBJECT>
 *
 * Public: No
 */

if (!isServer) exitWith {objNull};

params [
    ["_marker", "", [""]],
    ["_model", ROOT_ANOMALIES_VR_BASE, [""]],
    ["_health", 400, [0]],
    ["_territory", 150, [0]],
    ["_interval", 8, [0]],
    ["_damage", 0.4, [0]],
    ["_fearRadius", 25, [0]],
    ["_seizureSafe", false, [false]],
    ["_config", createHashMap, [createHashMap]]
];

private _pos = getMarkerPos _marker;
private _obj = createAgent [_model, _pos, [], 0, "NONE"];
_obj setVariable ["BIS_fnc_animalBehaviour_disable", true];
_obj setSpeaker "NoVoice";
_obj disableConversation true;
_obj setBehaviour "CARELESS";
_obj setCaptive true;
_obj enableFatigue false;
_obj disableAI "ALL";
_obj enableSimulationGlobal false;
_obj setSkill ["courage", 1];
{_obj setObjectTextureGlobal [_x, "#(argb,8,8,3)color(0,0,0,0.55)"]} forEach [0, 1, 2, 3, 4, 5];
_obj setVariable [QGVAR(dmgTotal), 0];
_obj setVariable [QGVAR(dmgIncr), 1 / _health];
_obj allowDamage true;
_obj addEventHandler ["HandleDamage", {
    params ["_unit", "_sel", "_dmg", "_source"];
    if ((!isNull _source) && {_source != _unit}) then {
        private _curr = (_unit getVariable [QGVAR(dmgTotal), 0]) + (_unit getVariable [QGVAR(dmgIncr), 0]);
        _unit setVariable [QGVAR(dmgTotal), _curr];
        if (_curr > 1) then {_unit setDamage 1};
    };
    0
}];

[_obj, _fearRadius, _seizureSafe] remoteExec [QFUNC(WraithSfx), 0, true];

// Hover.
[_obj] spawn {
    params ["_obj"];
    while {alive _obj} do {
        private _p = getPosATL _obj;
        _obj setPosATL [_p select 0, _p select 1, 1.2];
        uiSleep 0.5;
    };
};

[_obj, _config] call EFUNC(main,finalizeInstance);

LOG_DEBUG_2("WraithMain spawned at %1 (territory %2)",_pos,_territory);

while {alive _obj && {!(_obj getVariable [QGVAR(captured), false])}} do {
    private _candidates = ((position _obj) nearEntities ["CAManBase", _territory]) select {
        (alive _x) && {typeOf _x != "VirtualCurator_F"} && {_x != _obj}
    };
    if (_candidates isNotEqualTo []) then {
        _candidates = [_candidates, [], {_obj distance _x}, "ASCEND"] call BIS_fnc_sortBy;
        private _tgt = _candidates select 0;
        private _dest = [getPosATL _tgt, 3 + random 4, random 360] call BIS_fnc_relPos;
        _obj setPosATL [_dest select 0, _dest select 1, 1.2];
        _obj setDir (_obj getRelDir _tgt);
        [_obj, ["furnal", 400]] remoteExec ["say3D"];

        {
            if ((typeOf _x != "VirtualCurator_F") && {alive _x} && {_x != _obj}) then {
                [_x, _damage, "body", "burn"] call EFUNC(main,applyDamage);
            };
        } forEach ((position _obj) nearEntities ["CAManBase", _fearRadius]);
    };
    uiSleep _interval;
};

[_obj, ["explozie_2", 600]] remoteExec ["say3D"];
uiSleep 3;
deleteVehicle _obj;

_obj
