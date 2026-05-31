#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Decides whether an entity may be harmed/affected by an anomaly,
 *              honoring the global immune blacklist and affect whitelist CBA settings.
 *
 * Logic:
 * - If the entity's type isKindOf any blacklisted class -> NOT affectable.
 * - If the whitelist is non-empty and the entity matches none of it -> NOT affectable.
 * - If an anomaly is given and it has a hostile-sides filter, the entity's side must
 *   be in that list -> otherwise NOT affectable.
 * - Otherwise affectable.
 *
 * Arguments:
 * 0: Entity <OBJECT>
 * 1: Anomaly (optional, for per-instance hostile-side filtering) <OBJECT>
 *
 * Return Value:
 * Affectable <BOOL>
 *
 * Example:
 * [_unit, _anomaly] call root_anomalies_fnc_isAffectable;
 *
 * Public: No
 */

params [["_entity", objNull, [objNull]], ["_anomaly", objNull, [objNull]]];

if (isNull _entity) exitWith {false};

private _type = typeOf _entity;

private _blacklist = [missionNamespace getVariable [SETTING_IMMUNE_BLACKLIST, ""]] call FUNC(parseClassList);
if (_blacklist findIf {_entity isKindOf _x} != -1) exitWith {
    LOG_DEBUG_1("isAffectable: %1 blocked by blacklist",_type);
    false
};

private _whitelist = [missionNamespace getVariable [SETTING_AFFECT_WHITELIST, ""]] call FUNC(parseClassList);
if (_whitelist isNotEqualTo [] && {_whitelist findIf {_entity isKindOf _x} == -1}) exitWith {
    LOG_DEBUG_1("isAffectable: %1 not in whitelist",_type);
    false
};

// Per-instance hostile-side filter (set via root_anomalies_fnc_setHostileSides).
private _ok = true;
if (!isNull _anomaly) then {
    private _sides = (_anomaly getVariable [QGVAR(config), createHashMap]) getOrDefault ["hostileSides", []];
    if (_sides isNotEqualTo [] && {!((side group _entity) in _sides)}) then {
        LOG_DEBUG_1("isAffectable: %1 filtered by hostile sides",_type);
        _ok = false;
    };
};

_ok
