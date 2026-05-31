#include "script_component.hpp"
/*
 * Author: Root
 * Description: PostInit handler for Burper. Registers a (deferred) anomaly driver for the
 *              unified API.
 *
 * Public: No
 */

["burper", {
    params ["_pos", "_config"];
    private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_BURPER_IDX", 0];
    missionNamespace setVariable ["ROOT_ANOMALIES_BURPER_IDX", _idx + 1];
    private _mk = format ["ROOT_ANOMALIES_BURPER_%1", _idx];
    createMarker [_mk, _pos];
    [
        _mk,
        _config getOrDefault ["roaming", false],
        _config getOrDefault ["detector", ""],
        _config getOrDefault ["protector", ""],
        _config getOrDefault ["killDevice", ""],
        _config getOrDefault ["radius", 10],
        _config getOrDefault ["vehicleAllowed", true],
        _config getOrDefault ["killRange", 20],
        _config getOrDefault ["aiPanic", true],
        _config
    ] spawn FUNC(BurperMain);
    objNull
}, createHashMap] call API(registerDriver);
