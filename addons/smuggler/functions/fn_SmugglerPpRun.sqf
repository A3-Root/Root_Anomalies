#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Creates, applies and tears down a temporary post-process effect (used for
 *              the Smuggler teleport screen distortion variants).
 *
 * Arguments:
 * 0: Effect name <STRING>
 * 1: Priority <NUMBER>
 * 2: Effect params <ARRAY>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_name", "_priority", "_effect"];

private _handle = -1;
while {_handle = ppEffectCreate [_name, _priority]; _handle < 0} do {_priority = _priority + 1};
_handle ppEffectEnable true;
_handle ppEffectAdjust _effect;
_handle ppEffectCommit 5;
waitUntil {ppEffectCommitted _handle};
uiSleep 3;
_handle ppEffectEnable false;
ppEffectDestroy _handle;
