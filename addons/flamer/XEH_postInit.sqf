#include "script_component.hpp"
/*
 * Author: Root
 * Description: PostInit handler for Flamer. Registers a (deferred) anomaly driver for the
 *              unified API.
 *
 * Public: No
 */

["flamer", {
    params ["_pos", "_config"];
    private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_FLAMER_IDX", 0];
    missionNamespace setVariable ["ROOT_ANOMALIES_FLAMER_IDX", _idx + 1];
    private _mk = format ["ROOT_ANOMALIES_FLAMER_%1", _idx];
    createMarker [_mk, _pos];
    [
        _mk,
        _config getOrDefault ["territory", 75],
        _config getOrDefault ["damage", 0.4],
        _config getOrDefault ["recharge", 1],
        _config getOrDefault ["health", 400],
        _config getOrDefault ["deathDamage", 1],
        _config getOrDefault ["aiPanic", false],
        _config
    ] spawn FUNC(FlamerMain);
    objNull
}, createHashMap] call API(registerDriver);
