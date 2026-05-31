#include "script_component.hpp"
/*
 * Author: Root
 * Description: PostInit handler for Worm.
 *
 * Public: No
 */

call FUNC(WormPostInit);

["worm", {
    params ["_pos", "_config"];
    private _idx = missionNamespace getVariable ["ROOT_ANOMALIES_WORM_IDX", 0];
    missionNamespace setVariable ["ROOT_ANOMALIES_WORM_IDX", _idx + 1];
    private _mk = format ["ROOT_ANOMALIES_WORM_%1", _idx];
    createMarker [_mk, _pos];
    [
        _mk,
        _config getOrDefault ["damage", 0.6],
        _config getOrDefault ["territory", 200],
        _config getOrDefault ["aiPanic", false],
        _config getOrDefault ["diffuser", "SmokeShellGreen"],
        _config
    ] spawn FUNC(WormMain);
    objNull
}, createHashMap] call API(registerDriver);
