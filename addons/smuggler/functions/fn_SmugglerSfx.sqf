#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Client FX for the Smuggler: a pulsing distortion core (revealed by the
 *              detector, or always when none is required) plus a leaf/dust "suction".
 *
 * Arguments:
 * 0: Anomaly object <OBJECT>
 * 1: Core object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_obj", "_core"];

private _detector = _obj getVariable [QGVAR(detector), ""];

if (_detector != "") then {
    while {!isNull _obj} do {
        waitUntil {uiSleep 5; player distance _obj < 1000};
        [_obj, _core] spawn FUNC(SmugglerSuction);
        waitUntil {[player, _detector] call BIS_fnc_hasItem};
        player setVariable [QGVAR(detected), true];
        [_obj, _detector] spawn {
            params ["_obj", "_detector"];
            waitUntil {uiSleep 1; !([player, _detector] call BIS_fnc_hasItem)};
            player setVariable [QGVAR(detected), false];
        };
        [_obj, _core] call FUNC(SmugglerReveal);
        player setVariable [QGVAR(loopDust), false];
        uiSleep 10;
    };
} else {
    player setVariable [QGVAR(detected), true];
    while {!isNull _obj} do {
        waitUntil {uiSleep 5; player distance _obj < 1000};
        [_obj, _core] spawn FUNC(SmugglerSuction);
        [_obj, _core] call FUNC(SmugglerReveal);
        player setVariable [QGVAR(loopDust), false];
        uiSleep 10;
    };
};
