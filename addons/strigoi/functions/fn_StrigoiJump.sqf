#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Ground lunge: leaps the Strigoi along the ground toward its target.
 *
 * Arguments:
 * 0: Strigoi object <OBJECT>
 * 1: Target <OBJECT>
 * 2: Sound emitter (cap) <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_strigoi", "_tgt", "_cap"];

private _jumpDir = (getPosATL _strigoi vectorFromTo getPosATL _tgt) vectorMultiply 15;
[_cap, [selectRandom ["01_salt", "02_salt", "03_salt"], 200]] remoteExec ["say3D"];
_strigoi setVelocity [_jumpDir select 0, _jumpDir select 1, round (5 + random 15)];
