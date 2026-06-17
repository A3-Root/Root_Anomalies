#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Applies the Strigoi's drain attack to the local player: damage, pulse
 *              sound and (unless seizure-safe) a brief blur/colour-inversion effect.
 *
 * Arguments:
 * 0: Damage fraction <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params [["_damage", 0.6, [0]]];

private _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
if (typeOf player != "VirtualCurator_F") then {
    [player, _damage, _bodyPart, selectRandom ["backblast", "bullet", "explosive", "grenade"]] call EFUNC(main,applyDamage);
};

playSound "puls";

if (SENS_LIGHTS_OFF) exitWith {};

["DynamicBlur", 400, [10]] spawn {
    params ["_name", "_priority", "_effect"];
    private _handle = -1;
    while {_handle = ppEffectCreate [_name, _priority]; _handle < 0} do {
        _priority = _priority + 1;
        uiSleep 0.01;
    };
    _handle ppEffectEnable true;
    _handle ppEffectAdjust _effect;
    _handle ppEffectCommit 0.5;
    waitUntil {ppEffectCommitted _handle};
    uiSleep 0.5;
    _handle ppEffectAdjust [0];
    _handle ppEffectCommit 0.5;
    uiSleep 1.5;
    _handle ppEffectEnable false;
    ppEffectDestroy _handle;
};

["ColorInversion", 2500, [0.53, 0.66, 0.94]] spawn {
    params ["_name", "_priority", "_effect"];
    private _handle = -1;
    while {_handle = ppEffectCreate [_name, _priority]; _handle < 0} do {
        _priority = _priority + 1;
    };
    _handle ppEffectEnable true;
    _handle ppEffectAdjust _effect;
    _handle ppEffectCommit 0.5;
    uiSleep 0.5;
    _handle ppEffectEnable false;
    ppEffectDestroy _handle;
};

// Tinnitus ring: suppressed entirely when sensitivity lights are off (handled by the
// exit above) and only an occasional chance otherwise, to cut its frequency.
uiSleep 4;
if (random 1 < 0.3) then {playSound "tiuit"};
