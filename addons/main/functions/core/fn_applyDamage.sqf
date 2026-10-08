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

if (isNull _entity || _amount <= 0 || {!([_entity] call FUNC(isDamageable))}) exitWith {false};

// A sedated anomaly, or one still groggy after waking, cannot hurt anyone. This also
// covers attacks that were already in flight in spawned sub-tasks.
if (!isNull _anomaly && {
    (_anomaly getVariable [QGVAR(sedated), false]) || {time < (_anomaly getVariable [QGVAR(cooldownUntil), -1])}
}) exitWith {false};
if !([_entity, _anomaly] call FUNC(isAffectable)) exitWith {false};

// Protective/immunity gear mitigation (no-op unless the anomaly defines gear in its config).
if (!isNull _anomaly) then {_amount = [_anomaly, _entity, _amount] call FUNC(gearMitigate)};
if (_amount <= 0) exitWith {false};

private _isAce = !isNil "ace_medical_fnc_addDamageToUnit";

// Drivers use a mix of selection and hitpoint names; map them all onto the six body
// parts ACE understands, and onto the matching vanilla hitpoint.
private _part = switch (toLowerANSI _bodyPart) do {
    case "head"; case "face_hub"; case "neck": {"Head"};
    case "leftarm"; case "hand_l"; case "arm_l": {"LeftArm"};
    case "rightarm"; case "hand_r"; case "arm_r": {"RightArm"};
    case "leftleg"; case "leg_l": {"LeftLeg"};
    case "rightleg"; case "leg_r": {"RightLeg"};
    default {"Body"};
};
private _validTypes = ["backblast", "bite", "bullet", "explosive", "falling", "grenade", "punch", "ropeburn", "shell", "stab", "unknown", "vehiclecrash", "burn", "drowning"];
private _type = [_dmgType, "unknown"] select !(toLowerANSI _dmgType in _validTypes);

if (_entity isKindOf "CAManBase") then {
    if (_isAce) then {
        [_entity, _amount, _part, _type] remoteExec ["ace_medical_fnc_addDamageToUnit", _entity];
    } else {
        private _hitPoint = switch (_part) do {
            case "Head": {"HitHead"};
            case "LeftArm"; case "RightArm": {"HitHands"};
            case "LeftLeg"; case "RightLeg": {"HitLegs"};
            default {"HitBody"};
        };
        // setHitPointDamage is local to the unit; setDamage is global.
        [_entity, [_hitPoint, ((_entity getHitPointDamage _hitPoint) + _amount) min 1]] remoteExec ["setHitPointDamage", _entity];
        _entity setDamage (((damage _entity) + _amount * 0.5) min 1);
    };
} else {
    _entity setDamage (((damage _entity) + _amount) min 1);
};

LOG_DEBUG_4("applyDamage: %1 took %2 (%3 %4)",typeOf _entity,_amount,_part,_type);
true
