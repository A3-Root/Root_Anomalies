#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Cinematic death sequence shared by the creature anomalies: optional final
 *              animation, a short dramatic beat, then a real GBU-strength explosion at the
 *              entity's position before it is hidden and deleted. The explosion uses live
 *              ordnance, so it deals genuine area damage to nearby units and structures.
 *
 * Arguments:
 * 0: Entity <OBJECT>
 * 1: Final animation (move) to switch into, "" for none <STRING> (default "")
 * 2: Extra blast count, scales spectacle/damage <NUMBER> (default 1)
 * 3: Delete the entity after the blast <BOOL> (default true)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_farmer, "Unconscious", 1, true] call root_anomalies_main_fnc_deathBlast;
 *
 * Public: No
 */

if (!isServer) exitWith {};

params [["_obj", objNull, [objNull]], ["_anim", "", [""]], ["_count", 1, [0]], ["_delete", true, [false]]];

if (isNull _obj) exitWith {};

private _pos = getPosATL _obj;

if (_anim isNotEqualTo "") then {
    _obj switchMove _anim;
    _obj setUnitPos "DOWN";
};

[_obj, _pos, _count, _delete] spawn {
    params ["_obj", "_pos", "_count", "_delete"];

    [_pos] remoteExec [QFUNC(deathBlastFx), 0];
    uiSleep 1.2;

    private _bpos = [_pos select 0, _pos select 1, (_pos select 2) + 0.4];
    for "_i" from 1 to (1 max round _count) do {
        createVehicle ["Bo_GBU12_LGB", _bpos, [], 0, "CAN_COLLIDE"];
        if (_count > 1) then {uiSleep 0.15};
    };

    if (_delete && {!isNull _obj}) then {
        hideObjectGlobal _obj;
        uiSleep 0.2;
        deleteVehicle _obj;
    };
};
