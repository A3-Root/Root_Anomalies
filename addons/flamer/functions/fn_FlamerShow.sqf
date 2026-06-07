#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Surfaces the Flamer at a safe position near its origin, re-enables
 *              simulation and plays the ignite FX.
 *
 * Arguments:
 * 0: Flamer object <OBJECT>
 * 1: Origin position <ARRAY>
 * 2: Territory radius <NUMBER>
 * 3: Damage fraction <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_flamer", "_originPos", "_territoryRadius", "_dmg"];

private _safePos = [_originPos, 1, _territoryRadius / 10, 3, 0, 20, 0] call BIS_fnc_findSafePos;
_flamer setPos _safePos;
_flamer setVariable [QGVAR(visible), true, true];
[_flamer, _dmg, _originPos] remoteExec [QFUNC(FlamerSfx), [0, -2] select isDedicated];
_flamer enableSimulationGlobal true;
_flamer hideObjectGlobal false;
{_flamer reveal _x} forEach (_flamer nearEntities [["CAManBase", "LandVehicle", "Helicopter"], 100]);
[_flamer getVariable [QGVAR(cap), _flamer], ["foc_initial", 1000]] remoteExec ["say3D"];
