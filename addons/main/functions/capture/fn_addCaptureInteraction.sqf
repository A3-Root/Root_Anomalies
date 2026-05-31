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
        "\A3\ui_f\data\IGUI\Cfg\holdactions\holdAction_ca.paa",
        {
            params ["_target", "_player"];
            private _t = (_target getVariable [QGVAR(config), createHashMap]) getOrDefault ["captureTime", ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME];
            [
                _t,
                [_target],
                { (_this select 0) params ["_target"]; [_target] call API(capture); },
                {},
                "Capturing anomaly..."
            ] call ace_common_fnc_progressBar;
        },
        {
            params ["_target", "_player"];
            (_target getVariable [QGVAR(sedated), false]) &&
            {!(_target getVariable [QGVAR(captured), false])} &&
            {(_target getVariable [QGVAR(config), createHashMap]) getOrDefault ["captureEnabled", true]}
        }
    ] call ace_interact_menu_fnc_createAction;
    [_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};

// Vanilla hold-action fallback.
[
    _obj,
    "Capture Anomaly",
    "\A3\ui_f\data\IGUI\Cfg\holdactions\holdAction_ca.paa",
    "\A3\ui_f\data\IGUI\Cfg\holdactions\holdAction_ca.paa",
    format ["(_target getVariable ['%1', false]) && {!(_target getVariable ['%2', false])} && {(_target getVariable ['%3', createHashMap]) getOrDefault ['captureEnabled', true]}", QGVAR(sedated), QGVAR(captured), QGVAR(config)],
    "true",
    {},
    {},
    { params ["_target"]; [_target] call API(capture); },
    {},
    [],
    _captureTime,
    0,
    false,
    false
] call BIS_fnc_holdActionAdd;
