#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Registers an anomaly "driver" so it can be spawned/configured through
 *              the unified API. Each anomaly component calls this once in its postInit.
 *              Other mods may register their own anomaly types the same way.
 *
 *              The handler is responsible for creating the anomaly entity and wiring its
 *              per-frame behaviour (reading the live config HashMap each tick), then
 *              returning the created object:
 *                  [_position, _config] call _handler  ->  _obj
 *              Common setup (config var, durability, capture, instance registry) is done
 *              by root_anomalies_fnc_spawn around the handler.
 *
 * Arguments:
 * 0: Type id, e.g. "scp173" <STRING>
 * 1: Handler <CODE>
 * 2: Default config <HASHMAP> (optional)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["scp173", EFUNC(scp173,main), _defaults] call root_anomalies_fnc_registerDriver;
 *
 * Public: Yes
 */

params [["_type", "", [""]], ["_handler", {}, [{}]], ["_default", createHashMap, [createHashMap]]];

if (_type isEqualTo "") exitWith { LOG_ERROR("registerDriver: empty type"); };

if (isNil QGVAR(drivers)) then { GVAR(drivers) = createHashMap; };
GVAR(drivers) set [toLower _type, [_handler, _default]];

LOG_DEBUG_1("registerDriver: registered %1",_type);
