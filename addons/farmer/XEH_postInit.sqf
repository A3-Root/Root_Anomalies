#include "script_component.hpp"
/*
 * Author: Root
 * Description: PostInit handler for Farmer. Registers a (deferred) anomaly driver so it can
 *              be spawned through the unified API.
 *
 * Public: No
 */

["farmer", {
    params ["_pos", "_config"];
    private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_FARMER_IDX", 0];
    missionNamespace setVariable ["ROOT_ANOMALIES_FARMER_IDX", _idx + 1];
    private _mk = format ["ROOT_ANOMALIES_FARMER_%1", _idx];
    createMarker [_mk, _pos];
    [
        _mk,
        _config getOrDefault ["territory", 75],
        _config getOrDefault ["damage", 0.6],
        _config getOrDefault ["recharge", 5],
        _config getOrDefault ["health", 400],
        _config getOrDefault ["aiPanic", false],
        _config
    ] spawn FUNC(FarmerMain);
    objNull
}, createHashMap] call API(registerDriver);
