#include "\z\root_anomalies\addons\smuggler\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Returns whether a unit carries the Smuggler's protector item (in any gear
 *              slot or inventory). Protected units are not teleported.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Protector classname ("" = no protector) <STRING>
 *
 * Return Value:
 * Unit is protected <BOOL>
 *
 * Public: No
 */

params ["_unit", "_protector"];

if (_protector == "") exitWith {false};
(headgear _unit == _protector) || {goggles _unit == _protector} || {uniform _unit == _protector} || {vest _unit == _protector} || {backpack _unit == _protector} || {_protector in (assignedItems _unit + items _unit)}
