#include "script_component.hpp"
/*
 * Author: Root
 * Description: PostInit handler for Swarmer.
 *
 * Public: No
 */

call FUNC(SwarmerPostInit);

["swarmer", {
    params ["_pos", "_config"];
    private _hive = (_config getOrDefault ["hive", "Land_GarbageBags_F"]) createVehicle _pos;
    [
        _hive,
        _config getOrDefault ["radius", 75],
        _config getOrDefault ["pesticide", "SmokeShellGreen"],
        _config getOrDefault ["damage", 0.6],
        _config
    ] spawn FUNC(SwarmerMain);
    objNull
}, createHashMap] call API(registerDriver);
