#include "script_component.hpp"
/*
 * Author: Root
 * Description: PostInit handler for Wraith. Registers a (deferred) anomaly driver for the
 *              unified API.
 *
 * Public: No
 */

["wraith", {
    params ["_pos", "_config"];
    private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_WRAITH_IDX", 0];
    missionNamespace setVariable ["ROOT_ANOMALIES_WRAITH_IDX", _idx + 1];
    private _mk = format ["ROOT_ANOMALIES_WRAITH_%1", _idx];
    createMarker [_mk, _pos];
    [
        _mk,
        _config getOrDefault ["model", ROOT_ANOMALIES_VR_BASE],
        _config getOrDefault ["health", 400],
        _config getOrDefault ["territory", 150],
        _config getOrDefault ["interval", 8],
        _config getOrDefault ["damage", 0.4],
        _config getOrDefault ["fearRadius", 25],
        _config getOrDefault ["noseize", false],
        _config
    ] spawn FUNC(WraithMain);
    objNull
}, createHashMap] call API(registerDriver);
