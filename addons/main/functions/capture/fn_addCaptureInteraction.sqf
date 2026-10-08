#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Adds the 30s capture interaction to an anomaly on each client. Uses ACE
 *              Interaction when ACE is present, otherwise a vanilla hold-action. The
 *              interaction is only offered while the anomaly is sedated (smoke or trap),
 *              not yet captured, and capture is enabled in its config. On completion it
 *              calls the public capture API.
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

if (isNull _obj || {!hasInterface}) exitWith {};

private _captureTime = (_obj getVariable [QGVAR(config), createHashMap]) getOrDefault ["captureTime", ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME];

if (!isNil "ace_interact_menu_fnc_addActionToObject") exitWith {
    private _action = [
        QGVAR(capture),
        "Capture Anomaly",
        "\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_secure_ca.paa",
        {
            params ["_target", "_player"];
            private _t = (_target getVariable [QGVAR(config), createHashMap]) getOrDefault ["captureTime", ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME];
            [
                _t,
                [_target],
                { (_this select 0) params ["_target"]; [_target] call API(capture); },
                {},
                "Capturing anomaly...",
                { ((_this select 0) select 0) getVariable [QGVAR(sedated), false] }
            ] call ace_common_fnc_progressBar;
        },
        {
            params ["_target", "_player"];
            (_target getVariable [QGVAR(sedated), false]) &&
            {!(_target getVariable [QGVAR(captured), false])} &&
            {(_target getVariable [QGVAR(config), createHashMap]) getOrDefault ["captureEnabled", true]}
        }
    ] call ace_interact_menu_fnc_createAction;
    // Men carry ACE's main interaction node; props (worm head, hives) do not, so the
    // action sits on the object itself there.
    private _parent = [[], ["ACE_MainActions"]] select (_obj isKindOf "CAManBase");
    [_obj, 0, _parent, _action] call ace_interact_menu_fnc_addActionToObject;
};

// Vanilla hold-action fallback.
[
    _obj,
    "Capture Anomaly",
    "\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_secure_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_secure_ca.paa",
    format ["(_target distance _this < 6) && {_target getVariable ['%1', false]} && {!(_target getVariable ['%2', false])} && {(_target getVariable ['%3', createHashMap]) getOrDefault ['captureEnabled', true]}", QGVAR(sedated), QGVAR(captured), QGVAR(config)],
    format ["(_caller distance _target < 6) && {_target getVariable ['%1', false]}", QGVAR(sedated)],
    {},
    {},
    {
        params ["_target", "_caller"];
        LOG_DEBUG_2("capture: %1 captured by %2",typeOf _target,name _caller);
        [_target] call API(capture);
    },
    {},
    [],
    _captureTime,
    0,
    false,
    false
] call BIS_fnc_holdActionAdd;
