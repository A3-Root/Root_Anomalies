#include "\z\root_anomalies\addons\scp096\script_component.hpp"
/*
 * Author: Root
 * Description: Initialises a player-controlled SCP-096P unit. Moves at normal pace while
 *              docile; once it has been viewed long enough by anyone (evaluated on the
 *              server) it enrages and gains a large speed boost so the player can run down
 *              their viewers. Capturable through the shared sedation/capture system.
 *
 * Arguments:
 * 0: SCP-096P unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_unit"];

if (isServer) then { [_unit] call FUNC(playerObserveEval); };

if (!local _unit) exitWith {};

private _cfg = _unit getVariable [QGVAR(config), createHashMap];
if (count _cfg == 0) then {
    _cfg = createHashMapFromArray [
        ["type", "scp096"], ["triggerRange", 200], ["viewTime", 5],
        ["cooldown", 20], ["affectAI", true], ["health", ROOT_ANOMALIES_DEFAULT_HEALTH],
        ["damageMult", ROOT_ANOMALIES_DEFAULT_DMGMULT], ["captureEnabled", true],
        ["enrageOnDamage", true]
    ];
    _unit setVariable [QGVAR(config), _cfg, true];
};
_unit setVariable [QGVAR(observers), createHashMap, true];
_unit setVariable [QGVAR(viewTimes), createHashMap, true];
_unit setVariable [QGVAR(targets), [], true];
_unit setVariable [QGVAR(enraged), false, true];

_unit setCaptive true;
_unit setAnimSpeedCoef 1.1;

[_unit] call EFUNC(main,initDamage);
[_unit] remoteExec [QFUNC(watch), 0, true];

[{
    params ["_args", "_handle"];
    _args params ["_unit", "_state"];

    if (isNull _unit || {!alive _unit}) exitWith { _handle call CBA_fnc_removePerFrameHandler; };

    private _enraged = _unit getVariable [QGVAR(enraged), false];
    if (_enraged isNotEqualTo (_state select 0)) then {
        _state set [0, _enraged];
        _unit setAnimSpeedCoef ([1.1, 1.7] select _enraged);
        hintSilent ([
            "SCP-096P: You are calm.",
            "SCP-096P: ENRAGED - hunt those who looked at you!"
        ] select _enraged);
    };
}, 0.5, [_unit, [false]]] call CBA_fnc_addPerFrameHandler;
