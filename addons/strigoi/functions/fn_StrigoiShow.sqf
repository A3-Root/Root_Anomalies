#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Surfaces the Strigoi at a safe position near its origin, re-enables
 *              simulation and plays the materialise FX.
 *
 * Arguments:
 * 0: Strigoi object <OBJECT>
 * 1: Origin position <ARRAY>
 * 2: Territory radius <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_strigoi", "_originPos", "_territoryRadius"];

private _safePos = [_originPos, 1, _territoryRadius / 10, 3, 0, 20, 0] call BIS_fnc_findSafePos;
_strigoi setPos _safePos;
_strigoi setVariable [QGVAR(visible), true, true];
[_strigoi] remoteExec [QFUNC(StrigoiSfx), [0, -2] select isDedicated];
_strigoi enableSimulationGlobal true;
_strigoi hideObjectGlobal false;
{_strigoi reveal _x} forEach (_strigoi nearEntities [["CAManBase"], 100]);
[_strigoi getVariable [QGVAR(cap), _strigoi], ["03_tip_casp", 1000]] remoteExec ["say3D"];
