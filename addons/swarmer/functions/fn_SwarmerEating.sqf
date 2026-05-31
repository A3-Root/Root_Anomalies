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

private _blood = {
    params ["_spot"];
    private _splash = "#particlesource" createVehicleLocal (getPosATL _spot);
    _splash setParticleCircle [0, [0, 0, 0]];
    _splash setParticleRandom [0.1, [0.2, 0.2, 0.2], [0, 0, 0.1], 0, 0.2, [0, 0, 0, 0.1], 1, 0];
    _splash setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 13, 1], "", "Billboard", 1, 0.15, [0, 0, 0], [0, 0, 0], 2, 10, 7.9, 0, [0.2, 0.8], [[1, 0, 0.1, 1], [1, 1, 0.1, 1]], [1], 1, 0, "", "", _spot];
    _splash setDropInterval 0.2;
    uiSleep 10;
    deleteVehicle _splash;
};

private _bones = ["spine3", "leftshoulder", "leftforearmroll", "leftleg", "leftfoot", "leftupleg", "rightshoulder", "rightforearmroll", "rightupleg", "rightleg", "rightfoot", "pelvis", "neck", "leftforearm", "rightforearm"];
private _anchors = [];
{
    private _anchor = "Land_HelipadEmpty_F" createVehicleLocal [0, 0, 0];
    _anchor attachTo [_victim, [0, 0, 0], _x];
    _anchors pushBack _anchor;
} forEach _bones;
{[_x] spawn _blood} forEach _anchors;
(_anchors select 0) say3D ["eating", 300];
_victim say3D ["strigat_92", 300];

uiSleep 13;
{deleteVehicle _x} forEach _anchors;
