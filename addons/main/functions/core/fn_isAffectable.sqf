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

// Per-unit whitelist opt-out (global or this anomaly's type).
private _anomType = "";
if (!isNull _anomaly) then {
    _anomType = (_anomaly getVariable [QGVAR(config), createHashMap]) getOrDefault ["type", ""];
};
if ([_entity, _anomType] call FUNC(isWhitelisted)) exitWith {
    LOG_DEBUG_1("isAffectable: %1 whitelisted",_type);
    false
};

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

// Per-instance targeting filter: sides + explicit unit/group include & exclude.
// Precedence: exclude wins; empty positive lists = no constraint; any positive
// include (unit OR group OR side) makes the entity affectable (an explicit unit/group
// include thus overrides the side filter). Set via the setTarget*/setHostileSides API.
private _ok = true;
if (!isNull _anomaly) then {
    private _config = _anomaly getVariable [QGVAR(config), createHashMap];
    private _sides = _config getOrDefault ["hostileSides", []];
    private _units = _config getOrDefault ["targetUnits", []];
    private _groups = _config getOrDefault ["targetGroups", []];
    private _exUnits = _config getOrDefault ["excludeUnits", []];
    private _exGroups = _config getOrDefault ["excludeGroups", []];
    private _grp = group _entity;

    if (_entity in _exUnits || {_grp in _exGroups}) exitWith {
        LOG_DEBUG_1("isAffectable: %1 excluded",_type);
        _ok = false;
    };

    if (_sides isEqualTo [] && {_units isEqualTo []} && {_groups isEqualTo []}) exitWith {};

    _ok = (_units isNotEqualTo [] && {_entity in _units})
        || {_groups isNotEqualTo [] && {_grp in _groups}}
        || {_sides isNotEqualTo [] && {(side _grp) in _sides}};
    if (!_ok) then {LOG_DEBUG_1("isAffectable: %1 filtered by targeting",_type)};
};

_ok
