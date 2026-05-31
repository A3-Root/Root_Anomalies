#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Wires the durability / damage-filter / killswitch / capture systems onto a
 *              freshly spawned anomaly. Replaces the old blanket "allowDamage false" with a
 *              controlled HandleDamage model: the entity keeps a configurable health pool,
 *              ignores filtered ammo, dies instantly to killswitch ammo, and exposes the
 *              sedation + 30s capture interaction. Runs where the anomaly is local.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_obj", objNull, [objNull]]];

if (isNull _obj) exitWith {};

if (!local _obj) exitWith {
    [_obj] remoteExec [QFUNC(initDamage), _obj];
};

_obj setVariable [QGVAR(captured), false, true];
_obj setVariable [QGVAR(sedated), false, true];

// Generic health-pool / damage-filter / killswitch model. Anomalies that keep their own
// damage handling (the legacy creatures) set manageDamage = false and skip this, but still
// get the sedation + capture interaction below.
private _cfg = _obj getVariable [QGVAR(config), createHashMap];
if ((_cfg getOrDefault ["manageDamage", true]) && {_obj isKindOf "CAManBase"}) then {
    _obj allowDamage true;
    _obj setVariable [QGVAR(absorbed), 0, true];
    _obj addEventHandler ["HandleDamage", {_this call EFUNC(main,handleDamage)}];
};

// Sedation-smoke detection (server PFH) and the capture interaction (every machine).
[_obj] call FUNC(sedationWatch);
[_obj] remoteExec [QFUNC(addCaptureInteraction), 0, _obj];

LOG_DEBUG_1("initDamage: wired %1",typeOf _obj);
