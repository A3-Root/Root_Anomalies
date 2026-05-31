#include "\z\root_anomalies\addons\scp173\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN Editor front-end for SCP-173. Builds a config from the module
 *              attributes and spawns the anomaly through the unified API.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 * 1: Synced units <ARRAY>
 * 2: Activated <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_logic", "_units", "_activated"];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};

private _cfg = [_logic] call EFUNC(main,cfgFromLogic);
_cfg set ["model", _logic getVariable ["ROOT_SCP173_MODEL", "B_VR_Soldier_F"]];
_cfg set ["radius", _logic getVariable ["ROOT_SCP173_RADIUS", 150]];
_cfg set ["observeDist", _logic getVariable ["ROOT_SCP173_OBSERVE", 1000]];
_cfg set ["blinkInterval", _logic getVariable ["ROOT_SCP173_BLINKINT", 7]];
_cfg set ["killDist", _logic getVariable ["ROOT_SCP173_KILLDIST", 2.5]];
_cfg set ["speed", _logic getVariable ["ROOT_SCP173_SPEED", 7]];

["scp173", getPosATL _logic, _cfg] call API(spawn);
