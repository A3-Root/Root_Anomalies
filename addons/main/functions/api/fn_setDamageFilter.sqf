#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Sets the damage-type/ammo immunity filter for an anomaly. Matching is by
 *              ammo classname or its base classes (isKindOf), so e.g. "Grenade",
 *              "G_40mm_HE", or a specific smoke class all work.
 *              - Whitelist non-empty: ONLY these ammo types can hurt the anomaly.
 *              - Blacklist: these ammo types are always ignored (takes priority).
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 * 1: Whitelist ammo classes <ARRAY of STRING> (optional)
 * 2: Blacklist ammo classes <ARRAY of STRING> (optional)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_scp, [], ["Grenade","G_40mm_HE"]] call root_anomalies_fnc_setDamageFilter;
 *
 * Public: Yes
 */

params [["_obj", objNull, [objNull]], ["_whitelist", [], [[]]], ["_blacklist", [], [[]]]];

if (isNull _obj) exitWith {};
[_obj, createHashMapFromArray [["dmgTypeWhitelist", _whitelist], ["dmgTypeBlacklist", _blacklist]]] call API(configure);
