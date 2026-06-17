#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Builds the attach-layer config for a legacy creature anomaly from its module
 *              logic: type id, manageDamage = false (it keeps its own health model), and the
 *              sedation/capture options. Module handlers pass the result to their Main, which
 *              finalises the spawned entity so it gains capture + getInstances support.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 * 1: Type id, e.g. "screamer" <STRING>
 *
 * Return Value:
 * Config HashMap <HASHMAP>
 *
 * Public: No
 */

params [["_logic", objNull, [objNull]], ["_type", "", [""]]];

private _cfg = createHashMapFromArray [
    ["type", _type],
    ["manageDamage", false],
    ["hostileSides", [_logic getVariable ["ROOT_SIDES", ""]] call FUNC(parseSides)],
    ["activationRange", _logic getVariable ["ROOT_ACTIVATION", ROOT_ANOMALIES_DEFAULT_ACTIVATION]],
    ["captureEnabled", _logic getVariable ["ROOT_CAPTURE", true]],
    ["captureTime", _logic getVariable ["ROOT_CAPTURETIME", ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME]],
    ["captureRadius", 15]
];

private _sed = [_logic getVariable ["ROOT_SEDATION", ""]] call FUNC(parseClassList);
if (_sed isNotEqualTo []) then { _cfg set ["sedationClassnames", _sed]; };

_cfg
