#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Shallow-merges an override HashMap into a base config HashMap in place
 *              (override keys win). The anomaly config schema is flat, so a shallow
 *              merge is sufficient. Returns the (mutated) base map.
 *
 * Arguments:
 * 0: Base config <HASHMAP>
 * 1: Overrides <HASHMAP>
 *
 * Return Value:
 * Base config <HASHMAP>
 *
 * Public: No
 */

params [["_base", createHashMap, [createHashMap]], ["_over", createHashMap, [createHashMap]]];

{
    _base set [_x, _over get _x];
} forEach (keys _over);

_base
