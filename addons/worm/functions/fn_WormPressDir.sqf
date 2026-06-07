#include "\z\root_anomalies\addons\worm\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Converts a compass heading into a planar push vector [x, y] used to fling
 *              the worm (and its victims) in the target's direction.
 *
 * Arguments:
 * 0: Heading in degrees <NUMBER>
 *
 * Return Value:
 * Planar vector [x, y] <ARRAY>
 *
 * Public: No
 */

params ["_dir"];

private _px = 0;
private _py = 0;
if (_dir <= 90) then {_px = linearConversion [0, 90, _dir, 0, 1, true]; _py = 1 - _px};
if ((_dir > 90) && {_dir < 180}) then {_px = linearConversion [0, 90, _dir - 90, 1, 0, true]; _py = _px - 1};
if ((_dir > 180) && {_dir < 270}) then {_px = linearConversion [0, 90, _dir - 180, 0, -1, true]; _py = (-1 * _px) - 1};
if ((_dir > 270) && {_dir < 360}) then {_px = linearConversion [0, 90, _dir - 270, -1, 0, true]; _py = 1 + _px};
[_px, _py]
