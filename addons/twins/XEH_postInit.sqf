#include "script_component.hpp"
/*
 * Author: Root
 * Description: PostInit handler for Twins. Registers a (deferred) anomaly driver for the
 *              unified API.
 *
 * Public: No
 */

["twins", {
    params ["_pos", "_config"];
    private _twins = (_config getOrDefault ["object", "Land_HighVoltageTower_large_F"]) createVehicle _pos;
    [
        _twins,
        _config getOrDefault ["trackDist", 100],
        _config getOrDefault ["sparks", true],
        _config getOrDefault ["dmgRange", 75],
        _config getOrDefault ["affectAI", true],
        _config getOrDefault ["emp", true],
        _config getOrDefault ["heartClass", "B_UAV_06_F"],
        _config
    ] spawn FUNC(TwinsMain);
    objNull
}, createHashMap] call API(registerDriver);
