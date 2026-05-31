#include "script_component.hpp"
/*
 * Author: Root
 * Description: PostInit handler for Steamer. Registers a (deferred) anomaly driver for the
 *              unified API.
 *
 * Public: No
 */

["steamer", {
    params ["_pos", "_config"];
    private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_STEAMER_IDX", 0];
    missionNamespace setVariable ["ROOT_ANOMALIES_STEAMER_IDX", _idx + 1];
    private _mk = format ["ROOT_ANOMALIES_STEAMER_%1", _idx];
    createMarker [_mk, _pos];
    [
        _mk,
        _config getOrDefault ["territory", 75],
        _config getOrDefault ["damage", 0.2],
        _config getOrDefault ["recharge", 10],
        _config getOrDefault ["deathDamage", 0.6],
        _config getOrDefault ["travelPath", false],
        _config
    ] spawn FUNC(SteamerMain);
    objNull
}, createHashMap] call API(registerDriver);
