#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root
 * Description: True if the unit is wearing or carrying any classname in the given list
 *              (gear slots + assigned items + inventory items).
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Classname list <ARRAY of STRING>
 *
 * Return Value:
 * Has gear <BOOL>
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]], ["_list", [], [[]]]];

if (isNull _unit || {_list isEqualTo []}) exitWith {false};

private _gear = [headgear _unit, goggles _unit, uniform _unit, vest _unit, backpack _unit];
_gear append (assignedItems _unit);
_gear append (items _unit);

_list findIf {_x in _gear} != -1
