#include "\z\root_anomalies\addons\scp173\script_component.hpp"
/*
 * Author: Root
 * Description: Initialises a player-controlled SCP-173P unit. The player moves at boosted
 *              speed but is hard-frozen in place while any hostile observer sees them
 *              (released during the observers' blink windows, exactly like the AI version).
 *              Capturable through the shared sedation/capture system. Driven on the unit's
 *              local (controlling) machine; observation is evaluated on the server.
 *
 * Arguments:
 * 0: SCP-173P unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_unit"];

// Server sets up observation evaluation + instance registration for everyone.
if (isServer) then { [_unit] call FUNC(playerObserveEval); };

if (!local _unit) exitWith {};

private _cfg = _unit getVariable [QGVAR(config), createHashMap];
if (count _cfg == 0) then {
    _cfg = createHashMapFromArray [
        ["type", "scp173"], ["observeDist", 1000], ["blinkInterval", 7],
        ["affectAI", true], ["health", ROOT_ANOMALIES_DEFAULT_HEALTH],
        ["damageMult", ROOT_ANOMALIES_DEFAULT_DMGMULT], ["captureEnabled", true]
    ];
    _unit setVariable [QGVAR(config), _cfg, true];
};
_unit setVariable [QGVAR(observers), createHashMap, true];

_unit setCaptive true;
_unit setAnimSpeedCoef 1.6;

// Durability + capture interaction.
[_unit] call EFUNC(main,initDamage);

// Observation watchers on every client (skips the controlling player itself).
[_unit] remoteExec [QFUNC(watch), 0, true];

// Local freeze loop.
[{
    params ["_args", "_handle"];
    _args params ["_unit", "_anchor"];

    if (isNull _unit || {!alive _unit}) exitWith { _handle call CBA_fnc_removePerFrameHandler; };
    if (_unit getVariable [QGVAR(captured), false]) exitWith {};

    if (_unit getVariable [QGVAR(observed), false]) then {
        // Frozen: pin to the last free position.
        if (_anchor select 0 isEqualTo []) then { _anchor set [0, getPosATL _unit]; };
        _unit setPosATL (_anchor select 0);
        _unit setVelocity [0, 0, 0];
    } else {
        _anchor set [0, getPosATL _unit];
    };
}, 0, [_unit, [[]]]] call CBA_fnc_addPerFrameHandler;
