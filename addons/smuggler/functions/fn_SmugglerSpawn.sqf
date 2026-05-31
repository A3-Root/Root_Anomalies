#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server loop that periodically conjures random units/objects out of the
 *              Smuggler when players are near.
 *
 * Arguments:
 * 0: Spawn classnames <ARRAY of STRING>
 * 1: Smuggler core object <OBJECT>
 * 2: Spawn delay <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params ["_spawnList", "_core", ["_spawnDelay", 10, [0]]];

_core setVariable [QGVAR(active), false, true];

while {!isNull _core} do {
    while {!(_core getVariable [QGVAR(active), false])} do {
        {if (_x distance getPos _core < 1100) exitWith {_core setVariable [QGVAR(active), true, true]}} forEach allPlayers;
        uiSleep 10;
    };
    _core setVariable [QGVAR(active), false, true];

    private _class = selectRandom _spawnList;
    if (getNumber (configFile >> "CfgVehicles" >> _class >> "scope") > 0) then {
        private _bounce = createVehicle ["Land_CanOpener_F", getPosATL _core, [], 0, "CAN_COLLIDE"];
        [_bounce] remoteExec ["hideObject", -2];
        [_core, [selectRandom ["telep_01", "telep_02", "telep_03", "telep_04", "telep_05"], 300]] remoteExec ["say3D"];

        if (_class isKindOf "Man") then {
            private _grp = createGroup [selectRandom [east, west, civilian, independent], true];
            private _unit = _grp createUnit [_class, getPosATL _core, [], 0, "CAN_COLLIDE"];
            [_unit, "NoVoice"] remoteExec ["setSpeaker", 0];
            _unit setBehaviour "AWARE";
            _unit enableFatigue false;
            _unit setUnitPos "UP";
            _unit setSkill ["commanding", 1];
            _unit setVariable [QGVAR(teleportedIn), 1, true];
            _bounce setDir (random 360);
            _unit attachTo [_bounce, [0, 0, 1]];
            _bounce setVelocity [selectRandom [-4, 4], selectRandom [-4, 4], 2];
            [_bounce, ["tremor", 300]] remoteExec ["say3D"];
            uiSleep 0.8;
            [_unit, [selectRandom ["strigat_1", "strigat_2", "strigat_3", "strigat_4", "strigat_5", "strigat_6", "strigat_7", "strigat_8", "strigat_9", "strigat_91", "strigat_92"], 100]] remoteExec ["say3D", 0];
            detach _unit;
            deleteVehicle _bounce;
            uiSleep 0.5;
            _unit setPosATL [getPosATL _unit select 0, getPosATL _unit select 1, 0.0001];
            [_unit, selectRandom ["ApanPknlMrunSnonWnonDb", "ApanPknlMrunSnonWnonDf", "ApanPercMrunSnonWnonDf", "ApanPercMsprSnonWnonDfr"]] remoteExec ["switchMove"];
            uiSleep 3;
            if (alive _unit) then {[_unit, ""] remoteExec ["switchMove"]};
            _unit setDamage (damage _unit + (random 0.15));
            _unit doMove ([getPosATL _core, 100 + random 500, random 360] call BIS_fnc_relPos);
            [_unit] spawn {params ["_u"]; uiSleep 120; _u setVariable [QGVAR(teleportedIn), nil, true]};
            uiSleep (10 + random _spawnDelay);
        } else {
            private _bounceObj = createVehicle ["Land_CanOpener_F", getPosATL _core, [], 0, "CAN_COLLIDE"];
            [_bounceObj] remoteExec ["hideObject", -2];
            private _obj = createVehicle [_class, [getPosATL _core select 0, getPosATL _core select 1, 1], [], 0, "NONE"];
            _obj attachTo [_bounceObj, [0, 0, 0]];
            _bounceObj setVelocity [selectRandom [-20, 20], selectRandom [-20, 20], 10];
            [_bounceObj, ["tremor", 300]] remoteExec ["say3D"];
            waitUntil {(getPosATL _obj select 2) < 0.3};
            detach _obj;
            [_obj, [selectRandom ["bodyfall_wood_3", "bodyfall_wood_1", "bodyfall_wood_2", "bodyfall_metal_3"], 100]] remoteExec ["say3D", 0];
            _obj setPosATL [getPosATL _obj select 0, getPosATL _obj select 1, 0.0001];
            uiSleep 0.1;
            deleteVehicle _bounceObj;
            uiSleep (10 + random _spawnDelay);
            if ((_obj distance _core < 10) && {local _obj}) then {deleteVehicle _obj};
        };
    };
};
