#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Merges the shared capture/sedation rows (always the last five results of
 *              an anomaly Zeus dialog, see zeusCaptureRows) into the anomaly config.
 *
 * Arguments:
 * 0: Anomaly config <HASHMAP>
 * 1: Full dialog results <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_config, _results] call root_anomalies_main_fnc_zeusCaptureApply;
 *
 * Public: No
 */

params [["_config", createHashMap, [createHashMap]], ["_results", [], [[]]]];

if (count _results < 5) exitWith {};

(_results select [count _results - 5, 5]) params ["_capturable", "_captureTime", "_sedation", "_sedationTime", "_cooldown"];

_config set ["captureEnabled", _capturable];
_config set ["captureTime", round _captureTime];
_config set ["sedationTime", round _sedationTime];
_config set ["sedationCooldown", round _cooldown];

private _classes = (([_sedation] call FUNC(parseClassList)) apply {[_x] call FUNC(resolveThrowable)}) select {_x isNotEqualTo ""};
if (_classes isNotEqualTo []) then {_config set ["sedationClassnames", _classes]};

private _type = _config getOrDefault ["type", "?"];
LOG_DEBUG_3("zeusCaptureApply: %1 by %2, sedation %3",_type,profileName,_classes);
