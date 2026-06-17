#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Applies protective- and immunity-gear mitigation to an incoming anomaly
 *              damage fraction for a man, returning the damage that should actually be
 *              dealt. Reads the per-instance gear config off the anomaly so every anomaly
 *              honours it uniformly (wired into root_anomalies_main_fnc_applyDamage).
 *
 *              Immunity gear fully blocks damage until its durability is spent, configured
 *              per anomaly:
 *                - Infinite: never fails (also when the value is <= 0).
 *                - Time: lasts <value> seconds of contact, then fails.
 *                - Damage: absorbs <value> total damage fraction, then fails.
 *              When immunity fails the wearer is notified once, then falls back to
 *              protective gear. Protective gear cuts a flat percentage off the damage.
 *
 * Arguments:
 * 0: Anomaly (source of the per-instance config) <OBJECT>
 * 1: Victim <OBJECT>
 * 2: Incoming damage fraction <NUMBER>
 *
 * Return Value:
 * Mitigated damage fraction <NUMBER>
 *
 * Public: No
 */

params [["_anomaly", objNull, [objNull]], ["_unit", objNull, [objNull]], ["_dmg", 0, [0]]];

if (isNull _anomaly || {isNull _unit} || {!(_unit isKindOf "Man")}) exitWith {_dmg};

private _cfg = _anomaly getVariable [QGVAR(config), createHashMap];

// ---- Immunity gear (full block while durable) ----
private _immGear = _cfg getOrDefault ["immGear", []];
if (_immGear isNotEqualTo [] && {[_unit, _immGear] call FUNC(hasGear)}) then {
    private _mode = toUpper (_cfg getOrDefault ["immMode", "INFINITE"]);
    private _val = _cfg getOrDefault ["immValue", 0];
    private _failed = false;

    if (_val <= 0) then {_mode = "INFINITE"};

    switch (_mode) do {
        case "TIME": {
            private _until = _unit getVariable [QGVAR(immUntil), -1];
            if (_until < 0) then {
                _until = time + _val;
                _unit setVariable [QGVAR(immUntil), _until, true];
            };
            if (time >= _until) then {_failed = true};
        };
        case "DAMAGE": {
            private _pool = _unit getVariable [QGVAR(immPool), -1];
            if (_pool < 0) then {_pool = _val};
            _pool = _pool - _dmg;
            _unit setVariable [QGVAR(immPool), _pool, true];
            if (_pool <= 0) then {_failed = true};
        };
        default {/* INFINITE: never fails */};
    };

    if (!_failed) exitWith {0};

    if !(_unit getVariable [QGVAR(immNotified), false]) then {
        _unit setVariable [QGVAR(immNotified), true, true];
        ["Your immunity gear has failed!"] remoteExec [QFUNC(gearNotify), _unit];
    };
};

// ---- Protective gear (flat % reduction) ----
private _protGear = _cfg getOrDefault ["protGear", []];
if (_protGear isNotEqualTo [] && {[_unit, _protGear] call FUNC(hasGear)}) then {
    private _pct = (_cfg getOrDefault ["protPct", 0.5]) max 0 min 1;
    _dmg = _dmg * (1 - _pct);
};

_dmg
