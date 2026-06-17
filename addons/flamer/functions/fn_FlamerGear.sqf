#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root
 * Description: Applies protective- and immunity-gear mitigation to an incoming Flamer damage
 *              fraction for a man, returning the damage that should actually be dealt.
 *
 *              Immunity gear fully blocks damage until its durability is spent, configured per
 *              Flamer via the module:
 *                - Infinite: never fails (also when the value is <= 0).
 *                - Time: lasts <value> seconds of contact, then fails.
 *                - Damage: absorbs <value> total damage fraction, then fails.
 *              When immunity fails the wearer is notified once, then falls back to protective
 *              gear. Protective gear cuts a flat percentage off the damage.
 *
 * Arguments:
 * 0: Flamer object (source of the per-instance config) <OBJECT>
 * 1: Victim <OBJECT>
 * 2: Incoming damage fraction <NUMBER>
 *
 * Return Value:
 * Mitigated damage fraction <NUMBER>
 *
 * Public: No
 */

// Delegates to the shared core gear-mitigation system so the Flamer honours exactly the
// same protective/immunity model as every other anomaly.
params [["_flamer", objNull, [objNull]], ["_unit", objNull, [objNull]], ["_dmg", 0, [0]]];

[_flamer, _unit, _dmg] call EFUNC(main,gearMitigate)
