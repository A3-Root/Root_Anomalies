#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Reads the common Root's Anomalies module attributes (see
 *              module_attributes.hpp) from a 3DEN/Zeus logic into a config HashMap.
 *              Module handlers call this, then add their type-specific keys, then pass
 *              the result to root_anomalies_fnc_spawn.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * Config HashMap <HASHMAP>
 *
 * Public: No
 */

params [["_logic", objNull, [objNull]]];

private _cfg = createHashMapFromArray [
    ["affectAI", _logic getVariable ["ROOT_AFFECTAI", true]],
    ["health", _logic getVariable ["ROOT_HEALTH", ROOT_ANOMALIES_DEFAULT_HEALTH]],
    ["damageMult", _logic getVariable ["ROOT_DMGMULT", ROOT_ANOMALIES_DEFAULT_DMGMULT]],
    ["hostileSides", [_logic getVariable ["ROOT_SIDES", ""]] call FUNC(parseSides)],
    ["captureEnabled", _logic getVariable ["ROOT_CAPTURE", true]],
    ["captureTime", _logic getVariable ["ROOT_CAPTURETIME", ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME]]
];

private _sed = [_logic getVariable ["ROOT_SEDATION", ""]] call FUNC(parseClassList);
if (_sed isNotEqualTo []) then { _cfg set ["sedationClassnames", _sed]; };

private _kill = [_logic getVariable ["ROOT_KILLSWITCH", ""]] call FUNC(parseClassList);
if (_kill isNotEqualTo []) then { _cfg set ["killClassnames", _kill]; };

_cfg
