#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Perches the Strigoi onto a nearby tree (anchor), facing its target,
 *              using a helipad walker prop as the attach carrier.
 *
 * Arguments:
 * 0: Strigoi object <OBJECT>
 * 1: Target position <ARRAY>
 * 2: Walker carrier prop <OBJECT>
 * 3: Anchor (tree) object <OBJECT>
 * 4: Sound emitter (cap) <OBJECT>
 * 5: Anchor height <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_strigoi", "_targetPos", "_walker", "_anchor", "_cap", "_anchorHeight"];

_walker setPos (_anchor getPos [2, _anchor getRelDir _targetPos]);
[_cap, [selectRandom ["01_salt", "02_salt", "03_salt"], 200]] remoteExec ["say3D"];
_strigoi setVelocityTransformation [getPosATL _strigoi, getPosATL _walker, velocity _strigoi, velocity _walker, [0, 0, 0], [0, 0, 0], [0, 0, 1], [0, 0, 2], 0.3];
_strigoi attachTo [_walker, [0, 0, (getPos _anchor select 2) + _anchorHeight / 4]];
_strigoi setDir (_strigoi getRelDir _targetPos);
[_cap, [selectRandom ["01_tip_casp", "NoSound", "02_tip_casp", "03_tip_casp", "NoSound", "04_tip_casp", "05_tip_casp", "06_tip_casp", "07_tip_casp", "NoSound"], 500]] remoteExec ["say3D"];
