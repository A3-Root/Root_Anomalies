#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Zeus (ZEN) front-end for the Terminate module. Drop it on an anomaly to remove
 *              just that one, or on open ground and pick a radius to clear every anomaly in
 *              range. Works on all anomalies, including the otherwise-undeletable Smuggler and
 *              Steamer.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_logic"];

if (!hasInterface) exitWith {};

if !(isClass (configFile >> "CfgPatches" >> "zen_custom_modules")) exitWith {
    LOG_ERROR("ZEN not detected - Zeus modules require Zeus Enhanced.");
};

private _pos = getPosATL _logic;
deleteVehicle _logic;

[
    "Terminate Anomalies",
    [
        ["SLIDER:RADIUS", ["Radius (m)", "Terminate every anomaly within this radius. Drop the module directly on a single anomaly to remove only that one."], [0, 2000, 100, 0, _pos, [200, 40, 40, 1]]]
    ],
    {
        params ["_results", "_pos"];
        _results params ["_radius"];
        [_pos, _radius] remoteExec [QFUNC(doTerminate), 2];
        ["Anomalies terminated."] call zen_common_fnc_showMessage;
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
    },
    _pos
] call zen_dialog_fnc_create;
