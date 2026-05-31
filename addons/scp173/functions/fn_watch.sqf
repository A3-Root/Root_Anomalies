#include "\z\root_anomalies\addons\scp173\script_component.hpp"
/*
 * Author: Root
 * Description: Per-client observation watcher for one SCP-173. Reports to the server
 *              whether the local player currently sees it (own eyes/binoculars within the
 *              observation distance; UAV terminals and external cameras excluded). While
 *              the player is looking, drives the blink cycle: every blinkInterval seconds
 *              the screen cuts to black (~1s) and during that window the player counts as
 *              NOT seeing, letting SCP-173 move. The player can blink early via keybind.
 *
 * Arguments:
 * 0: SCP-173 object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_obj"];

[{
    params ["_args", "_handle"];
    _args params ["_obj", "_state"];
    _state params ["_lastReport", "_lastSeeing"];

    if (isNull _obj) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
        [objNull, clientOwner, false] remoteExec [QFUNC(report), 2];
    };

    private _cfg = _obj getVariable [QGVAR(config), createHashMap];
    private _observeDist = _cfg getOrDefault ["observeDist", 1000];
    private _blinkInterval = _cfg getOrDefault ["blinkInterval", 7];

    private _seeing = (alive player)
        && {player isNotEqualTo _obj}
        && {typeOf player != "VirtualCurator_F"}
        && {(player distance _obj) < _observeDist}
        && {[player, _obj, 55, 1.5, true] call EFUNC(main,isObserving)};

    // Blink cycle only runs while the player is looking at SCP-173.
    if (_seeing) then {
        // Rising edge: arm the next blink one interval out.
        if (!_lastSeeing) then {
            player setVariable [QGVAR(nextBlink), time + _blinkInterval];
        };
        if (time >= (player getVariable [QGVAR(nextBlink), time + _blinkInterval])) then {
            [_blinkInterval] call FUNC(blink);
        };
    };
    _state set [1, _seeing];

    private _blinking = time < (player getVariable [QGVAR(blinkEnd), 0]);
    private _effective = _seeing && {!_blinking};

    if (_effective isNotEqualTo _lastReport) then {
        [_obj, clientOwner, _effective] remoteExec [QFUNC(report), 2];
        _state set [0, _effective];
    };
}, 0.1, [_obj, [false, false]]] call CBA_fnc_addPerFrameHandler;
