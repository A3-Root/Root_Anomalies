#include "\z\root_anomalies\addons\burper\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local bobbing/spin animation of the Burper sphere while it is revealed.
 *
 * Arguments:
 * 0: Visual sphere object <OBJECT>
 * 1: Anomaly object (range/cycle/active reference) <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_sphere", "_workObj"];

private _dir = 0;
private _height = 0;
private _descending = false;

while {
    ((player distance _sphere) < 1500)
    && {(_workObj getVariable [QGVAR(cycSimple), 1]) != (_workObj getVariable [QGVAR(cycCompli), 1])}
    && {_workObj getVariable [QGVAR(active), false]}
} do {
    if ((_height < 0.61) && {!_descending}) then {_height = _height + 0.01};
    if (_height > 0.61) then {_descending = true};
    if (_descending && {_height > 0.2}) then {_height = _height - 0.01};
    if (_height < 0.2) then {_descending = false};
    _dir = _dir + 2;
    _sphere setDir _dir;
    private _cur = getPosATL _sphere;
    _sphere setPosATL [_cur select 0, _cur select 1, _height];
    uiSleep 0.01;
};
