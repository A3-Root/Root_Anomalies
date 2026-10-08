#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: True while an anomaly is sedated or still in its post-sedation cooldown.
 *              Attack helpers check it so nothing they do lands while the anomaly is down.
 *
 * Arguments:
 * 0: Anomaly <OBJECT>
 *
 * Return Value:
 * Pacified <BOOL>
 *
 * Example:
 * if ([_flamer] call root_anomalies_main_fnc_isPacified) exitWith {};
 *
 * Public: No
 */

params [["_obj", objNull, [objNull]]];

!isNull _obj && {
    (_obj getVariable [QGVAR(sedated), false]) || {time < (_obj getVariable [QGVAR(cooldownUntil), -1])}
}
