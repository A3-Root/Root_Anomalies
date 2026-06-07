#include "\z\root_anomalies\addons\burper\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Zeus (ZEN) front-end for the Burper. Opens a configuration dialog and
 *              hands off to root_anomalies_burper_fnc_BurperMain on the server.
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

private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_BURPER_IDX", 0];
missionNamespace setVariable ["ROOT_ANOMALIES_BURPER_IDX", _idx + 1];
private _markerName = format ["ROOT_ANOMALIES_BURPER_%1", _idx];

private _pos = getPosATL _logic;
createMarker [_markerName, _pos];
deleteVehicle _logic;

[
    "Burper Anomaly Settings",
    [
        ["SLIDER:RADIUS", ["Burper Territory", "Radius in meters of the Burper's effective range for destruction."], [5, 2000, 10, 0, _pos, [7, 120, 32, 1]]],
        ["TOOLBOX:YESNO", ["Enable Vehicle Damage", "If true, all land vehicles will also be affected by the Burper."], true],
        ["TOOLBOX:YESNO", ["Enable Roaming Burper", "If true, the Burper teleports to random positions over time."], false],
        ["TOOLBOX:YESNO", ["Enable Detection Device", "If true, the Burper is invisible and can only be detected with the detection device configured below."], true],
        ["TOOLBOX:YESNO", ["Enable Burper Protection", "If true, the Burper will not attack anyone carrying the protection device configured below."], true],
        ["TOOLBOX:YESNO", ["Enable Killswitch", "If true, the Burper is destroyed if the configured object is within range of its position."], true],
        ["TOOLBOX:YESNO", ["Enable AI Panic", "If true, AI flee to a safe distance from the Burper when it is visible."], true],
        ["SLIDER:RADIUS", ["Killswitch Range", "Radius in meters of the killswitch trigger. Keep at least 5m above Burper Territory when using a vehicle."], [10, 4000, 20, 0, _pos, [7, 120, 32, 1]]],
        ["EDIT", ["Detection Device", "Classname of the detection device. Can be the same item as the protection device."], ["MineDetector"]],
        ["EDIT", ["Protection Device", "Classname of the protection device. Can be the same item as the detection device."], ["B_Kitbag_mcamo"]],
        ["EDIT", ["Killswitch Device", "Classname of the killswitch device (default: CSAT Typhoon Device)."], ["O_Truck_03_device_F"]]
    ],
    {
        params ["_results", "_markerName"];
        _results params ["_radius", "_vehicleAllowed", "_roaming", "_detectable", "_protectable", "_killable", "_aiPanic", "_killRange", "_detector", "_protector", "_killDevice"];

        if (!_detectable) then {_detector = ""};
        if (!_protectable) then {_protector = ""};
        if (!_killable) then {_killDevice = ""; _killRange = 1};

        if (_killRange < _radius) then {
            if (_killDevice isKindOf "LandVehicle") then {
                if ((_killRange + _radius) > (2 * _radius)) then {_killRange = 1.5 * _radius};
            } else {
                _killRange = _killRange + 5;
            };
        };

        ["Burper Anomaly configured and created!"] call zen_common_fnc_showMessage;
        private _config = createHashMapFromArray [["type", "burper"], ["manageDamage", false], ["captureEnabled", true], ["captureTime", ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME], ["captureRadius", 15]];
        [_markerName, _roaming, _detector, _protector, _killDevice, _radius, _vehicleAllowed, _killRange, _aiPanic, _config] remoteExec [QFUNC(BurperMain), 2];
    },
    {
        ["Aborted"] call zen_common_fnc_showMessage;
        playSound "FD_Start_F";
    },
    _markerName
] call zen_dialog_fnc_create;
