#include "\z\root_anomalies\addons\twins\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Client-side proximity effect + observation tracking for the Twins.
 *              While the local player looks at it, the Twins' "observed" counter rises
 *              (it freezes when observed); nearby it disorients and damages the player.
 *
 * Arguments:
 * 0: Twins object <OBJECT>
 * 1: Damage range <NUMBER>
 * 2: Seizure-safe <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

waitUntil {time > 0};

params ["_twins", ["_dmgRange", 75, [0]], ["_noseize", false, [false]]];

// Proximity disorientation + damage.
[_twins, _dmgRange, _noseize] spawn {
    params ["_twins", "_dmgRange", "_noseize"];
    private _canDamage = true;
    while {alive _twins} do {
        waitUntil {uiSleep 0.2; player distance _twins < _dmgRange};
        if (typeOf player != "VirtualCurator_F") then {
            if !(_noseize || SEIZURE_SAFE) then {
                [_twins, _dmgRange] spawn {
                    params ["_twins", "_dmgRange"];
                    private _aberration = ppEffectCreate ["ChromAberration", 250];
                    _aberration ppEffectEnable true;
                    enableCamShake true;
                    while {player distance _twins < _dmgRange} do {
                        addCamShake [1, 4, 33];
                        _aberration ppEffectAdjust [1, 0.8, true];
                        _aberration ppEffectCommit 3;
                        uiSleep 3;
                        addCamShake [1, 4, 33];
                        _aberration ppEffectAdjust [0, 0, true];
                        _aberration ppEffectCommit 3;
                        uiSleep 3;
                    };
                    _aberration ppEffectEnable false;
                    ppEffectDestroy _aberration;
                    resetCamShake;
                };
            };
            if (_canDamage) then {
                _canDamage = false;
                playSound "sound_twin";
                [player, random 0.33, "body", selectRandom ["backblast", "bullet", "explosive", "grenade"]] call root_anomalies_main_fnc_applyDamage;
                uiSleep 5;
                _canDamage = true;
            };
        };
    };
};

// Observation tracking: count up while the player looks at the Twins.
private _sunIni = "none";
private _token = 13;
private _vizFct = 0;
while {alive _twins} do {
    waitUntil {(player distance _twins) < 1500};
    if (typeOf player != "VirtualCurator_F") then {
        private _dirRel = [player, _twins] call BIS_fnc_dirTo;
        private _camDir = [0, 0, 0] getDir getCameraViewDirection player;
        if ((abs (_dirRel - _camDir) <= 46) || {abs (_dirRel - _camDir) >= 314}) then {
            if (_vizFct < 1) then {
                _vizFct = _vizFct + 1;
                _twins setVariable [QGVAR(visible), (_twins getVariable [QGVAR(visible), 0]) + 1, true];
            };
        } else {
            private _metalSound = selectRandom ["metalic1", "metalic2", "metalic3", "metalic4", "metalic5"];
            if ((_sunIni != _metalSound) && {_token > 12}) then {_twins say3D [_metalSound, 1500]; _token = 0};
            _token = _token + 0.2;
            _sunIni = _metalSound;
            if (_vizFct > 0) then {
                _vizFct = _vizFct - 1;
                _twins setVariable [QGVAR(visible), (_twins getVariable [QGVAR(visible), 0]) - 1, true];
            };
        };
        uiSleep 0.2;
    };
};
