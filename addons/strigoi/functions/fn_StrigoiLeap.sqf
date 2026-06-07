#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Leaps the Strigoi off its tree anchor toward the target.
 *
 * Arguments:
 * 0: Strigoi object <OBJECT>
 * 1: Target <OBJECT>
 * 2: Walker carrier prop <OBJECT>
 * 3: Anchor (tree) object <OBJECT>
 * 4: Sound emitter (cap) <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_strigoi", "_tgt", "_walker", "_anchor", "_cap"];

private _jumpDir = (getPosATL _strigoi vectorFromTo getPosATL _tgt) vectorMultiply 10;
_strigoi attachTo [_walker, [0, 0, ((boundingCenter _anchor) select 2) * 2]];
[_cap, [selectRandom ["01_salt", "02_salt", "03_salt"], 200]] remoteExec ["say3D"];
detach _strigoi;
_strigoi setVelocity [_jumpDir select 0, _jumpDir select 1, 3];
