#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Decides whether an entity may take HEALTH damage right now. This is the
 *              single damage gate, kept separate from isAffectable (which governs whether a
 *              unit may be a target / receive effects). Honours the engine allowDamage flag
 *              via isDamageAllowed, which also covers ACE-protected/unconscious units. Must
 *              be checked before any damage application, including the ACE medical path
 *              (ace_medical_fnc_addDamageToUnit ignores allowDamage on its own).
 *
 * Arguments:
 * 0: Entity <OBJECT>
 *
 * Return Value:
 * Entity may take damage <BOOL>
 *
 * Example:
 * [_unit] call EFUNC(main,isDamageable);
 *
 * Public: No
 */

params [["_entity", objNull, [objNull]]];

!isNull _entity && {alive _entity} && {isDamageAllowed _entity}
