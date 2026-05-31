#include "\z\root_anomalies\addons\twins\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server backend that runs a Twins anomaly: an electric entity with a
 *              vulnerable "heart" that stalks targets, freezes when observed, sparks,
 *              disorients/damages nearby units and can EMP on death.
 *
 * Arguments:
 * 0: Twins object <OBJECT>
 * 1: Tracking distance <NUMBER>
 * 2: Electric sparks <BOOL>
 * 3: Damage range <NUMBER>
 * 4: Affect AI <BOOL>
 * 5: EMP on death <BOOL>
 * 6: Heart classname <STRING>
 * 7: Seizure-safe <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params [
    ["_twins", objNull, [objNull]],
    ["_trackDist", 100, [0]],
    ["_sparks", true, [false]],
    ["_dmgRange", 75, [0]],
    ["_affectAI", true, [false]],
    ["_emp", true, [false]],
    ["_heartClass", "B_UAV_06_F", [""]],
    ["_noseize", false, [false]]
];

if (isNull _twins) exitWith {};

private _heart = _heartClass createVehicle [0, 0, 0];
_heart attachTo [_twins, [-0.5, 0, 1.5]];
[_heart] remoteExec ["root_anomalies_twins_fnc_TwinsInima", [0, -2] select isDedicated];

private _sparkBall = objNull;
if (_sparks) then {
    _sparkBall = createVehicle ["Sign_Sphere10cm_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
    [_sparkBall, true] remoteExec ["hideObject", 0, true];
};

if (_affectAI) then {[_twins, _dmgRange] remoteExec ["root_anomalies_twins_fnc_TwinsDamage", 2]};

_twins setVariable [QGVAR(visible), 0, true];
[_twins, _dmgRange, _noseize] remoteExec ["root_anomalies_twins_fnc_TwinsViz", [0, -2] select isDedicated, true];

LOG_DEBUG_2("TwinsMain spawned (track %1, dmgRange %2)",_trackDist,_dmgRange);

// Movement / observation-freeze loop.
[_twins, _trackDist, _dmgRange, _heart, _emp, _noseize] spawn {
    params ["_twins", "_trackDist", "_dmgRange", "_heart", "_emp", "_noseize"];
    private _allowMove = 15;
    private _incr = 0;

    while {alive _heart} do {
        private _closest = (position _twins) nearEntities [["CAManBase", "LandVehicle"], _trackDist];
        if ((_twins getVariable [QGVAR(visible), 0]) < 1) then {
            if ((_closest isNotEqualTo []) && {_allowMove > 10}) then {
                private _closer = _closest select 0;
                if ((_closer distance _twins) > _dmgRange) then {
                    private _dir = [_closer, _twins] call BIS_fnc_dirTo;
                    private _newPos = [getPosATL _twins, _incr, _dir] call BIS_fnc_relPos;
                    _twins setPosATL _newPos;
                    _twins setDir _dir;
                    _incr = _incr - (15 + floor (random 11));
                    _allowMove = 0;
                };
            };
            _allowMove = _allowMove + 3;
        } else {
            _allowMove = 0;
        };
        uiSleep 2;
    };

    if (_emp) then {
        [_twins, _noseize, _trackDist] remoteExec ["root_anomalies_twins_fnc_TwinsEmp", [0, -2] select isDedicated, true];
        uiSleep 2;
    };
    deleteVehicle _twins;
    deleteVehicle _heart;
};

// Spark visuals.
if (_sparks) then {
    while {alive _twins} do {
        switch (selectRandom ["st", "dr", "ct"]) do {
            case "st": {_sparkBall attachTo [_twins, [-12, 0, 12.35]]};
            case "dr": {_sparkBall attachTo [_twins, [11.5, 0, 12.35]]};
            default {_sparkBall attachTo [_twins, [-0.3, 0, 12.2]]};
        };
        _twins setDamage 0;
        private _flashes = 1 + floor (random 5);
        uiSleep 5;
        for "_n" from 1 to _flashes do {
            private _gap = 0.1 + (random 2);
            [_sparkBall, _gap] remoteExec ["root_anomalies_twins_fnc_TwinsEffect", [0, -2] select isDedicated];
            uiSleep _gap;
        };
    };
    deleteVehicle _sparkBall;
};
