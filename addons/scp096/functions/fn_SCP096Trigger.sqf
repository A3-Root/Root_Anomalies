#include "\z\root_anomalies\addons\scp096\script_component.hpp"
/*
 * Author: Root
 * Description: Server handler - registers a unit as an SCP-096 target and enrages it.
 *
 * Arguments:
 * 0: SCP-096 object <OBJECT>
 * 1: Triggering unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

params ["_obj", "_unit"];

if ((isNull _obj) || {isNull _unit} || {!alive _unit}) exitWith {};

private _targets = _obj getVariable [QGVAR(targets), []];
if !(_unit in _targets) then {
    _targets pushBack _unit;
    _obj setVariable [QGVAR(targets), _targets];
    [_obj, ["scream", 600]] remoteExec ["say3D"];
    LOG_DEBUG_1("SCP096 enraged by %1",name _unit);
};
_obj setVariable [QGVAR(lastTrigger), time];
_obj setVariable [QGVAR(enraged), true, true];
