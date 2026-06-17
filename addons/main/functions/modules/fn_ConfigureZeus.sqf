#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Zeus (ZEN) front-end for the Reconfigure module. Drop it on a placed anomaly to
 *              retune its hostile sides, activation range, damage and capturability live, or on
 *              open ground with a radius to retune every anomaly in range.
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
    "Reconfigure Anomalies",
    [
        ["SLIDER:RADIUS", ["Radius (m)", "Apply to every anomaly in range. Drop directly on a single anomaly to retune only that one."], [0, 2000, 50, 0, _pos, [40, 120, 200, 1]]],
        ["EDIT", ["Hostile Sides (CSV)", "Comma-separated sides to attack: WEST,EAST,INDEPENDENT,CIVILIAN. Empty = all."], [""]],
        ["SLIDER:RADIUS", ["Activation Range (m)", "Players within this distance wake the anomaly."], [50, 3000, 1000, 0, _pos, [120, 120, 40, 1]]],
        ["SLIDER:PERCENT", ["Damage", "Fraction of damage the anomaly deals per hit."], [0, 1, 0.4, 2]],
        ["TOOLBOX:YESNO", ["Capturable", "Allow the sedation + capture interaction."], true]
    ],
    {
        params ["_results", "_pos"];
        _results params ["_radius", "_sides", "_activation", "_damage", "_capture"];
        private _override = createHashMapFromArray [
            ["hostileSides", [_sides] call EFUNC(main,parseSides)],
            ["activationRange", _activation],
            ["damage", _damage],
            ["captureEnabled", _capture]
        ];
        [_pos, _radius, _override] remoteExec [QFUNC(doConfigure), 2];
        ["Anomalies reconfigured."] call zen_common_fnc_showMessage;
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
    },
    _pos
] call zen_dialog_fnc_create;
