#include "script_component.hpp"
/*
 * Author: Root
 * Description: PostInit handler for Smuggler. Registers a (deferred) anomaly driver for the
 *              unified API.
 *
 * Public: No
 */

["smuggler", {
    params ["_pos", "_config"];
    private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_SMUGGLER_IDX", 0];
    missionNamespace setVariable ["ROOT_ANOMALIES_SMUGGLER_IDX", _idx + 1];
    private _mk = format ["ROOT_ANOMALIES_SMUGGLER_%1", _idx];
    createMarker [_mk, _pos];
    [
        _mk,
        _config getOrDefault ["roaming", false],
        _config getOrDefault ["detector", ""],
        _config getOrDefault ["spawnList", []],
        _config getOrDefault ["spawnDelay", 10],
        _config getOrDefault ["protector", ""],
        _config getOrDefault ["damage", 0.1],
        _config
    ] spawn FUNC(SmugglerMain);
    objNull
}, createHashMap] call API(registerDriver);
