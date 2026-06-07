#include "\z\root_anomalies\addons\burper\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Client-side FX orchestrator for the Burper. Manages the reveal cycle
 *              (detector-gated or always visible) and spawns the primary/secondary/
 *              animation effects. Cycle state is stored locally on the anomaly object.
 *
 * Arguments:
 * 0: Anomaly object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_workObj"];

#define BURPER_TEXTURE "\z\root_anomalies\addons\burper\images\01_burper.jpg"
#define BURPER_MATERIAL "A3\Structures_F\Data\Windows\window_set.rvmat"

private _detect = _workObj getVariable [QGVAR(detect), false];

if (_detect) then {
    while {alive _workObj} do {
        _workObj setVariable [QGVAR(cycSimple), 1];
        _workObj setVariable [QGVAR(cycCompli), 1];
        uiSleep 1;
        waitUntil {uiSleep 2; (player distance _workObj) < 1500};

        private _cur = getPosATL _workObj;
        private _sphere = createVehicle ["Sign_Sphere25cm_F", [_cur select 0, _cur select 1, 1], [], 0, "CAN_COLLIDE"];
        _sphere setObjectMaterial [0, BURPER_MATERIAL];
        _sphere setObjectTextureGlobal [0, BURPER_TEXTURE];
        uiSleep 0.1;
        _sphere hideObjectGlobal true;

        [_workObj, _sphere] spawn FUNC(BurperFxSecondary);

        // Detector check: reveal when the player carries the detection device.
        [_workObj] spawn {
            params ["_workObj"];
            private _detector = _workObj getVariable [QGVAR(detector), ""];
            while {(player distance _workObj) < 1500} do {
                private _has = (typeOf player == "VirtualCurator_F") || {_detector != "" && {[player, _detector] call BIS_fnc_hasItem}};
                _workObj setVariable [QGVAR(cycCompli), [1, 2] select _has];
                uiSleep 3;
            };
        };

        waitUntil {(_workObj getVariable [QGVAR(cycSimple), 1]) != (_workObj getVariable [QGVAR(cycCompli), 1])};

        _sphere hideObjectGlobal false;
        [_workObj, _sphere] spawn FUNC(BurperFxPrimary);
        [_sphere, _workObj] call FUNC(BurperFxAnim);

        deleteVehicle _sphere;
        _workObj setVariable [QGVAR(cycCompli), 3];
        uiSleep 1;
    };
} else {
    _workObj setVariable [QGVAR(cycSimple), 1];
    _workObj setVariable [QGVAR(cycCompli), 2];
    while {alive _workObj} do {
        waitUntil {uiSleep 2; (player distance _workObj) < 1500};

        private _cur = getPosATL _workObj;
        private _sphere = createVehicle ["Sign_Sphere25cm_F", [_cur select 0, _cur select 1, 0], [], 0, "CAN_COLLIDE"];
        _sphere setObjectMaterial [0, BURPER_MATERIAL];
        _sphere setObjectTextureGlobal [0, BURPER_TEXTURE];
        uiSleep 0.1;

        [_workObj, _sphere] spawn FUNC(BurperFxPrimary);
        [_workObj, _sphere] spawn FUNC(BurperFxSecondary);
        [_sphere, _workObj] call FUNC(BurperFxAnim);

        deleteVehicle _sphere;
    };
};
