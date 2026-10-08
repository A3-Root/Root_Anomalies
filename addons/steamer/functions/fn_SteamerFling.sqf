#include "\z\root_anomalies\addons\steamer\script_component.hpp"
/*
 * Author: Root
 * Description: Throws one object up and away from the Steamer eruption. Runs where the
 *              object is local, because setVelocity only takes effect on the owner.
 *
 * Arguments:
 * 0: Object to throw <OBJECT>
 * 1: Strength 0..1, falls off with distance <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_crate, 0.8] call root_anomalies_steamer_fnc_SteamerFling;
 *
 * Public: No
 */

params [["_target", objNull, [objNull]], ["_strength", 1, [0]]];

if (isNull _target) exitWith {};

// Mostly upward with a lateral kick, so the pile comes apart as it rises.
private _lift = 12 + random 14;
_target setVelocity [
    (random 16 - 8) * _strength,
    (random 16 - 8) * _strength,
    _lift * _strength
];
