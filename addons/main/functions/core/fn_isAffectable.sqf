#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Decides whether an entity may be harmed/affected by an anomaly,
 *              honoring the global immune blacklist and affect whitelist CBA settings.
 *
 * Logic:
 * - If the entity's type isKindOf any blacklisted class -> NOT affectable.
 * - If the whitelist is non-empty and the entity matches none of it -> NOT affectable.
 * - Otherwise affectable.
 *
 * Arguments:
 * 0: Entity <OBJECT>
 *
 * Return Value:
 * Affectable <BOOL>
 *
 * Example:
 * [_unit] call Root_fnc_isAffectable;
 *
 * Public: No
 */

params [["_entity", objNull, [objNull]]];

if (isNull _entity) exitWith {false};

private _type = typeOf _entity;

private _blacklist = [missionNamespace getVariable [SETTING_IMMUNE_BLACKLIST, ""]] call Root_fnc_parseClassList;
if (_blacklist findIf {_entity isKindOf _x} != -1) exitWith {
    LOG_DEBUG_1("isAffectable: %1 blocked by blacklist",_type);
    false
};

private _whitelist = [missionNamespace getVariable [SETTING_AFFECT_WHITELIST, ""]] call Root_fnc_parseClassList;
if (_whitelist isEqualTo []) exitWith {true};

private _match = _whitelist findIf {_entity isKindOf _x} != -1;
if (!_match) then {
    LOG_DEBUG_1("isAffectable: %1 not in whitelist",_type);
};
_match
