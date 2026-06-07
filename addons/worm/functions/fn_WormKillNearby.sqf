#include "\z\root_anomalies\addons\worm\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Deletes worm head/tail segments from a candidate list (diffuser cleanup).
 *
 * Arguments:
 * 0: Candidate objects <ARRAY of OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_candidates"];

{
    if (!isNil {_x getVariable QGVAR(isWorm)}) then {uiSleep 4; deleteVehicle _x};
    if (typeOf _x == "land_CanOpener_F") then {deleteVehicle _x};
} forEach _candidates;
