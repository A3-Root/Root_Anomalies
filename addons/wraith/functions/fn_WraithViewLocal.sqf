#include "\z\root_anomalies\addons\wraith\script_component.hpp"
/*
 * Author: Root
 * Description: Client-side visibility for one Wraith. hideObject is local, so every
 *              machine with a player decides for itself: the Wraith is hidden unless the
 *              player is looking through the vision mode it shows up in (night vision,
 *              thermal or both). Covers the player's own NVG/optics, the turret they man
 *              and a UAV they control. Zeus always sees it, and a sedated Wraith is visible
 *              to everyone so it can be captured.
 *
 * Arguments:
 * 0: Wraith <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_wraith] call root_anomalies_wraith_fnc_WraithViewLocal;
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params [["_wraith", objNull, [objNull]]];

if (isNull _wraith) exitWith {};

_wraith hideObject true;

[{
    params ["_args", "_handle"];
    _args params ["_wraith", "_shown"];

    if (isNull _wraith) exitWith {_handle call CBA_fnc_removePerFrameHandler};

    private _modes = [[1], [2], [1, 2]] select (((_wraith getVariable [QEGVAR(main,config), createHashMap]) getOrDefault ["visionMode", 2]) min 2 max 0);

    // Work out what the player is actually looking through right now.
    private _viewer = cameraOn;
    private _mode = currentVisionMode player;
    if (_viewer != vehicle player && {unitIsUAV _viewer}) then {
        _mode = (_viewer currentVisionMode [0]) param [0, 0];
    } else {
        private _veh = vehicle player;
        if (_veh != player) then {
            private _turret = _veh unitTurret player;
            if (_turret isNotEqualTo []) then {_mode = (_veh currentVisionMode _turret) param [0, _mode]};
        };
    };

    private _visible = (_mode in _modes)
        || {!isNull curatorCamera}
        || {_wraith getVariable [QEGVAR(main,sedated), false]}
        || {!alive _wraith};

    if (_visible isNotEqualTo _shown) then {
        _wraith hideObject !_visible;
        _wraith setVariable [QGVAR(seen), _visible];
        _args set [1, _visible];
    };
}, 0, [_wraith, false]] call CBA_fnc_addPerFrameHandler;
