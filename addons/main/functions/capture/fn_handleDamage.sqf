#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: HandleDamage handler for anomalies. Keeps engine damage pinned at 0 and
 *              manages a private health pool instead, so the entity only "dies" when the
 *              pool is exhausted (then it is captured/killed by the framework). Honours
 *              the per-instance damage-type whitelist/blacklist and killswitch classes.
 *
 *              Only the aggregate ("") selection callback is processed; because we always
 *              return 0, the engine baseline stays 0 and each aggregate event's _damage is
 *              effectively that hit's contribution.
 *
 * Arguments: standard HandleDamage EH args.
 *
 * Return Value:
 * New damage for the selection (always 0) <NUMBER>
 *
 * Public: No
 */

params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_ammo"];

if (_selection isNotEqualTo "") exitWith {0};
if (_unit getVariable [QGVAR(captured), false]) exitWith {0};

private _incoming = _damage;
if (_incoming <= 0) exitWith {0};

private _cfg = _unit getVariable [QGVAR(config), createHashMap];

// Does this hit's ammo/projectile match any class in _list (CfgAmmo isKindOf, or exact)?
private _ammoCls = _ammo;
private _projCls = _projectile;
private _matchFn = {
    params ["_list"];
    private _hit = false;
    {
        private _cls = _x;
        if (_ammoCls isEqualType "" && {_ammoCls != ""} && {_ammoCls isKindOf [_cls, configFile >> "CfgAmmo"]}) exitWith {_hit = true};
        if (_projCls isEqualType "" && {_projCls != ""} && {_projCls isKindOf [_cls, configFile >> "CfgAmmo"]}) exitWith {_hit = true};
    } forEach _list;
    _hit
};

// Killswitch: instant kill.
private _killClasses = _cfg getOrDefault ["killClassnames", []];
if (_killClasses isNotEqualTo [] && {[_killClasses] call _matchFn}) exitWith {
    [_unit, false] call FUNC(doCapture);
    0
};

// Blacklist: ignored entirely.
private _blacklist = _cfg getOrDefault ["dmgTypeBlacklist", []];
if (_blacklist isNotEqualTo [] && {[_blacklist] call _matchFn}) exitWith {0};

// Whitelist (if set): only listed ammo hurts.
private _whitelist = _cfg getOrDefault ["dmgTypeWhitelist", []];
if (_whitelist isNotEqualTo [] && {!([_whitelist] call _matchFn)}) exitWith {0};

// Optional: record the attacker so a driver can retaliate (e.g. SCP-096 enrages).
if (_cfg getOrDefault ["enrageOnDamage", false]) then {
    private _attacker = _instigator;
    if (isNull _attacker) then { _attacker = _source; };
    if (!isNull _attacker && {_attacker != _unit}) then {
        _unit setVariable [QGVAR(pendingAttacker), _attacker, true];
    };
};

private _health = _cfg getOrDefault ["health", ROOT_ANOMALIES_DEFAULT_HEALTH];
private _mult = _cfg getOrDefault ["damageMult", ROOT_ANOMALIES_DEFAULT_DMGMULT];
private _absorbed = (_unit getVariable [QGVAR(absorbed), 0]) + (_incoming * _mult);
_unit setVariable [QGVAR(absorbed), _absorbed, true];

if (_absorbed >= _health) then {
    [_unit, false] call FUNC(doCapture);
};

0
