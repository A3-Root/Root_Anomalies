#include "\z\root_anomalies\addons\scp173\script_component.hpp"
/*
 * Author: Root
 * Description: Client watcher - reports to the server whether the local player has
 *              SCP-173 within their view cone and line of sight.
 *
 * Arguments:
 * 0: SCP-173 object <OBJECT>
 * 1: Territory radius <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_obj", ["_territory", 150, [0]]];

private _last = false;
while {!isNull _obj} do {
    private _seeing = false;
    if ((alive player) && {typeOf player != "VirtualCurator_F"} && {player distance _obj < _territory}) then {
        private _eye = eyePos player;
        private _head = (AGLToASL (getPosATL _obj)) vectorAdd [0, 0, 1.5];
        private _toObj = _head vectorDiff _eye;
        private _camDir = getCameraViewDirection player;
        private _angle = acos ((_camDir vectorDotProduct (vectorNormalized _toObj)) min 1 max -1);
        if (_angle < 55) then {
            private _hits = lineIntersectsSurfaces [_eye, _head, player, _obj];
            _seeing = _hits isEqualTo [];
        };
    };
    if (_seeing != _last) then {
        [_obj, clientOwner, _seeing] remoteExec ["Root_fnc_SCP173Report", 2];
        _last = _seeing;
    };
    uiSleep 0.25;
};

// Clear our observation flag when SCP-173 is gone.
[objNull, clientOwner, false] remoteExec ["Root_fnc_SCP173Report", 2];
