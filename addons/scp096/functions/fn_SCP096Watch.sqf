#include "\z\root_anomalies\addons\scp096\script_component.hpp"
/*
 * Author: Root
 * Description: Client watcher - if the local player sees SCP-096's face within range,
 *              it triggers the rampage on the server.
 *
 * Arguments:
 * 0: SCP-096 object <OBJECT>
 * 1: Trigger range <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_obj", ["_triggerRange", 200, [0]]];

while {!isNull _obj} do {
    if ((alive player) && {typeOf player != "VirtualCurator_F"} && {player distance _obj < _triggerRange}) then {
        private _eye = eyePos player;
        private _face = (AGLToASL (getPosATL _obj)) vectorAdd [0, 0, 1.6];
        private _toObj = _face vectorDiff _eye;
        private _angle = acos (((getCameraViewDirection player) vectorDotProduct (vectorNormalized _toObj)) min 1 max -1);
        if ((_angle < 40) && {(lineIntersectsSurfaces [_eye, _face, player, _obj]) isEqualTo []}) then {
            [_obj, player] remoteExec ["Root_fnc_SCP096Trigger", 2];
            uiSleep 3;
        };
    };
    uiSleep 0.3;
};
