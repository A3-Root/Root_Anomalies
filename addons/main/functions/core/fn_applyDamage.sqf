#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Applies damage to an entity, using ACE Medical when available and
 *              falling back to vanilla setDamage otherwise. Respects the affect
 *              whitelist/blacklist via root_anomalies_fnc_isAffectable.
 *
 * Arguments:
 * 0: Entity <OBJECT>
 * 1: Damage amount (0..1, additive) <NUMBER>
 * 2: Body part (ACE only) <STRING> (default "body")
 * 3: Damage type (ACE only) <STRING> (default "stab")
 * 4: Anomaly (optional, for hostile-side filtering) <OBJECT>
 *
 * Return Value:
 * Damage was applied <BOOL>
 *
 * Example:
 * [_unit, 0.5, "body", "stab"] call EFUNC(main,applyDamage);
 *
 * Public: No
 */

params [["_entity", objNull, [objNull]], ["_amount", 0, [0]], ["_bodyPart", "body", [""]], ["_dmgType", "stab", [""]], ["_anomaly", objNull, [objNull]]];

if (isNull _entity || {_amount <= 0} || {!([_entity] call FUNC(isDamageable))}) exitWith {false};
if !([_entity, _anomaly] call FUNC(isAffectable)) exitWith {false};

// Protective/immunity gear mitigation (no-op unless the anomaly defines gear in its config).
if (!isNull _anomaly) then {_amount = [_anomaly, _entity, _amount] call FUNC(gearMitigate)};
if (_amount <= 0) exitWith {false};

private _isAce = !isNil "ace_medical_fnc_addDamageToUnit";

if (_isAce && {_entity isKindOf "CAManBase"}) then {
    [_entity, _amount, _bodyPart, _dmgType] remoteExec ["ace_medical_fnc_addDamageToUnit", _entity];
} else {
    _entity setDamage ((damage _entity) + _amount);
};

LOG_DEBUG_3("applyDamage: %1 took %2 (%3)",typeOf _entity,_amount,_dmgType);
true
