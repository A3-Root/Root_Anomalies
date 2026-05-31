#include "script_component.hpp"
/*
 * Author: Root
 * Description: PostInit handler for Strigoi. Registers a (deferred) anomaly driver for the
 *              unified API.
 *
 * Public: No
 */

["strigoi", {
    params ["_pos", "_config"];
    private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_STRIGOI_IDX", 0];
    missionNamespace setVariable ["ROOT_ANOMALIES_STRIGOI_IDX", _idx + 1];
    private _mk = format ["ROOT_ANOMALIES_STRIGOI_%1", _idx];
    createMarker [_mk, _pos];
    [
        _mk,
        _config getOrDefault ["territory", 75],
        _config getOrDefault ["nightOnly", false],
        _config getOrDefault ["damage", 0.6],
        _config getOrDefault ["health", 400],
        _config getOrDefault ["noseize", false],
        _config getOrDefault ["aiPanic", false],
        _config
    ] spawn FUNC(StrigoiMain);
    objNull
}, createHashMap] call API(registerDriver);
