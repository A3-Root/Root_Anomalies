#include "\z\root_anomalies\addons\burper\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Server loop that destroys eligible entities within the Burper's territory.
 *
 * Arguments:
 * 0: Anomaly object <OBJECT>
 * 1: Territory radius <NUMBER>
 * 2: Affect vehicles <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params ["_obj", ["_radius", 10, [0]], ["_vehicleAllowed", true, [false]]];

private _types = if (_vehicleAllowed) then {["Man", "LandVehicle"]} else {["Man"]};
private _screams = ["strigat_1", "strigat_2", "strigat_3", "strigat_4", "strigat_5", "strigat_6", "strigat_7", "strigat_8", "strigat_9", "strigat_91", "strigat_92"];

while {alive _obj && {!(_obj getVariable [QGVAR(terminate), false])}} do {
    private _protector = _obj getVariable [QGVAR(protector), ""];
    private _radiusLive = (_obj getVariable [QGVAR(config), createHashMap]) getOrDefault ["territory", _radius];
    private _victims = (position _obj) nearEntities [_types, _radiusLive];

    {
        private _victim = _x;
        private _protected = (typeOf _victim == "VirtualCurator_F")
            || {_protector != "" && {[_victim, _protector] call BIS_fnc_hasItem}}
            || {!([_victim, _obj] call EFUNC(main,isAffectable))}
            || {!([_victim] call EFUNC(main,isDamageable))};

        if (!_protected) then {
            private _scream = selectRandom _screams;
            [_victim, [_scream, 100]] remoteExec ["say3D"];
            uiSleep (0.5 + random 0.5);
            _victim setDamage 1;
            _victim hideObjectGlobal true;

            private _bonePos = getPosATL _victim;
            if !(_victim isKindOf "LandVehicle") then {deleteVehicle _victim};

            private _skeleton = createVehicle ["Land_HumanSkeleton_F", [_bonePos select 0, _bonePos select 1, 1.5], [], 0, "CAN_COLLIDE"];
            _skeleton setDir (random 360);
            _skeleton setVectorUp [0, -1, 1];
            [_skeleton] remoteExec [QFUNC(BurperSplash), [0, -2] select isDedicated];

            private _splat = createVehicle ["BloodSplatter_01_Medium_New_F", [_bonePos select 0, _bonePos select 1, 0], [], 0, "CAN_COLLIDE"];
            [_obj, ["blood_splash", 100]] remoteExec ["say3D"];
            uiSleep 0.3;
            [_splat, ["bones_drop", 100]] remoteExec ["say3D"];
        };
    } forEach _victims;

    uiSleep 1;
};
