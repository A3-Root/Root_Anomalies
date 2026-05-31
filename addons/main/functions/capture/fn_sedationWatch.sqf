#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Server PFH that detects sedation smoke (default or per-instance custom
 *              classnames) within the anomaly's capture radius and opens a timed sedation
 *              window, during which the capture interaction becomes available. Also the
 *              hook used by traps to force a sedation window.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_obj", objNull, [objNull]]];

if (isNull _obj || {!isServer}) exitWith {};

private _h = [{
    params ["_args", "_handle"];
    _args params ["_obj"];

    if (isNull _obj || {!alive _obj}) exitWith { _handle call CBA_fnc_removePerFrameHandler; };
    if (_obj getVariable [QGVAR(captured), false]) exitWith {};

    private _cfg = _obj getVariable [QGVAR(config), createHashMap];
    private _classes = _cfg getOrDefault ["sedationClassnames", [ROOT_ANOMALIES_SEDATIVE_SMOKE, "ROOT_Ammo_SmokeShell_Sedative"]];
    private _radius = _cfg getOrDefault ["captureRadius", 15];

    private _found = false;
    {
        private _t = typeOf _x;
        {
            private _cls = _x;
            if ((_t isKindOf [_cls, configFile >> "CfgAmmo"]) || {_t == _cls}) exitWith { _found = true; };
        } forEach _classes;
        if (_found) exitWith {};
    } forEach ((getPosATL _obj) nearObjects _radius);

    if (_found) then {
        _obj setVariable [QGVAR(sedated), true, true];
        _obj setVariable [QGVAR(sedatedUntil), time + 20, true];
    } else {
        if (time > (_obj getVariable [QGVAR(sedatedUntil), 0])) then {
            _obj setVariable [QGVAR(sedated), false, true];
        };
    };
}, 1, [_obj]] call CBA_fnc_addPerFrameHandler;

_obj setVariable [QGVAR(sedationPfh), _h, true];
