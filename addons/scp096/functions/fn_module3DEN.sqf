#include "\z\root_anomalies\addons\scp096\script_component.hpp"
/*
 * Author: Root
 * Description: 3DEN Editor front-end for SCP-096. Builds a config from the module
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
_cfg set ["model", _logic getVariable ["ROOT_SCP096_MODEL", "B_VR_Soldier_F"]];
_cfg set ["triggerRange", _logic getVariable ["ROOT_SCP096_TRIGGER", 200]];
_cfg set ["viewTime", _logic getVariable ["ROOT_SCP096_VIEWTIME", 5]];
_cfg set ["speed", _logic getVariable ["ROOT_SCP096_SPEED", 11]];
_cfg set ["cooldown", _logic getVariable ["ROOT_SCP096_COOLDOWN", 20]];
_cfg set ["damage", _logic getVariable ["ROOT_SCP096_DAMAGE", 1]];
_cfg set ["enrageOnDamage", true];

["scp096", getPosATL _logic, _cfg] call API(spawn);
