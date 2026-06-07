#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Strigoi melee/spectral attack. Plays the visual on every machine, then
 *              routes player damage to the seizure-aware client effect and AI damage
 *              through the shared applyDamage gate (respects allowDamage / targeting).
 *
 * Arguments:
 * 0: Strigoi object <OBJECT>
 * 1: Target <OBJECT>
 * 2: Damage fraction <NUMBER>
 * 3: Seizure-safe <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_strigoi", "_tgt", "_dmg", "_seizureSafe"];

[_strigoi, _tgt, _seizureSafe] remoteExec [QFUNC(StrigoiViz), [0, -2] select isDedicated];
if ((isPlayer _tgt) && {typeOf _tgt != "VirtualCurator_F"}) then {
    [_dmg, _seizureSafe] remoteExec [QFUNC(StrigoiTgt), _tgt];
} else {
    if ((_tgt isKindOf "Man") && {_tgt != _strigoi} && {typeOf _tgt != "VirtualCurator_F"}) then {
        [_tgt, _dmg, ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65], selectRandom ["backblast", "bullet", "explosive", "grenade"]] call EFUNC(main,applyDamage);
    };
};
uiSleep 1;
