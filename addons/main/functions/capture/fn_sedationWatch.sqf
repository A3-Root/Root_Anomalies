#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Server PFH that detects sedation smoke (default or per-instance custom
 *              classnames) within the anomaly's sedation radius and opens a timed sedation
 *              window, during which the anomaly is held down by sedationHold and the
 *              capture interaction becomes available. Classes configured as the anomaly's
 *              kill device (pesticide, diffuser) never count as sedation. Also the hook
 *              used by traps to force a sedation window.
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
    private _exclude = _cfg getOrDefault ["killClassnames", []];
    private _radius = _cfg getOrDefault ["sedationRadius", _cfg getOrDefault ["captureRadius", ROOT_ANOMALIES_DEFAULT_SEDATION_RADIUS]];
    private _duration = _cfg getOrDefault ["sedationTime", ROOT_ANOMALIES_DEFAULT_SEDATION_TIME];
    private _centre = _obj getVariable [QGVAR(sedationCentre), getPosATL _obj];

    private _found = objNull;
    {
        private _t = typeOf _x;
        if !(_t in _exclude) then {
            {
                if (_t == _x || {_t isKindOf [_x, configFile >> "CfgAmmo"]}) exitWith { _found = _x; };
            } forEach _classes;
        };
        if (!isNull _found) exitWith {};
    } forEach (_centre nearObjects _radius);

    private _id = _cfg getOrDefault ["id", typeOf _obj];
    if (isNull _found) then {
        if ((_obj getVariable [QGVAR(sedated), false]) && {time > (_obj getVariable [QGVAR(sedatedUntil), 0])}) then {
            _obj setVariable [QGVAR(sedated), false, true];
            LOG_DEBUG_1("sedationWatch: %1 sedative wore off",_id);
        };
    } else {
        if !(_obj getVariable [QGVAR(sedated), false]) then {
            LOG_DEBUG_3("sedationWatch: %1 sedated by %2 at %3",_id,typeOf _found,mapGridPosition _found);
        };
        _obj setVariable [QGVAR(sedationPos), getPosATL _found, true];
        _obj setVariable [QGVAR(sedated), true, true];
        _obj setVariable [QGVAR(sedatedUntil), time + _duration, true];
    };
}, 1, [_obj]] call CBA_fnc_addPerFrameHandler;

_obj setVariable [QGVAR(sedationPfh), _h, true];
