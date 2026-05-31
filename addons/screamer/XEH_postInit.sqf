#include "script_component.hpp"
/*
 * Author: Root
 * Description: PostInit handler for Screamer. Registers a (deferred) anomaly driver so the
 *              Screamer can be spawned through the unified API; its blocking Main creates the
 *              entity and finalises it for capture/getInstances itself.
 *
 * Public: No
 */

["screamer", {
    params ["_pos", "_config"];
    private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_SCREAMER_IDX", 0];
    missionNamespace setVariable ["ROOT_ANOMALIES_SCREAMER_IDX", _idx + 1];
    private _mk = format ["ROOT_ANOMALIES_SCREAMER_%1", _idx];
    createMarker [_mk, _pos];
    [
        _mk,
        _config getOrDefault ["model", "Land_AncientStatue_01_F"],
        _config getOrDefault ["dmgClose", 0.8],
        _config getOrDefault ["dmgMedium", 0.4],
        _config getOrDefault ["dmgFar", 0.2],
        _config getOrDefault ["territory", 100],
        _config getOrDefault ["hostiles", [east, west, civilian, resistance]],
        _config getOrDefault ["radius", 50],
        _config getOrDefault ["affectVehicles", true],
        _config getOrDefault ["aiEngage", false],
        _config getOrDefault ["aiPanic", false],
        _config getOrDefault ["spawnSide", civilian],
        _config getOrDefault ["health", 400],
        _config
    ] spawn FUNC(ScreamerMain);
    objNull
}, createHashMap] call API(registerDriver);
