#include "\z\root_anomalies\addons\swarmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Kills Swarmer hives in a candidate list (pesticide response). Targets the
 *              anomaly itself, so it uses a direct setDamage rather than the victim-facing
 *              applyDamage gate.
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
    if (!isNil {_x getVariable QGVAR(isHive)}) then {
        uiSleep 5;
        _x setDamage 1;
        [_x] remoteExec [QFUNC(SwarmerDead), [0, -2] select isDedicated];
    };
} forEach _candidates;
