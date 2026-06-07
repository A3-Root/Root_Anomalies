#include "\z\root_anomalies\addons\swarmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local "feeding" FX on a victim (blood jets, meat chunks, chewing sounds).
 *
 * Arguments:
 * 0: Victim object <OBJECT>
 * 1: Swarmer agent <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_victim", "_hive"];

if (!alive _hive) exitWith {};

private _bones = ["spine3", "leftshoulder", "leftforearmroll", "leftleg", "leftfoot", "leftupleg", "rightshoulder", "rightforearmroll", "rightupleg", "rightleg", "rightfoot", "pelvis", "neck", "leftforearm", "rightforearm"];
private _anchors = [];
{
    private _anchor = "Land_HelipadEmpty_F" createVehicleLocal [0, 0, 0];
    _anchor attachTo [_victim, [0, 0, 0], _x];
    _anchors pushBack _anchor;
} forEach _bones;
{[_x] spawn FUNC(SwarmerBlood)} forEach _anchors;
(_anchors select 0) say3D ["eating", 300];
_victim say3D ["strigat_92", 300];

uiSleep 13;
{deleteVehicle _x} forEach _anchors;
