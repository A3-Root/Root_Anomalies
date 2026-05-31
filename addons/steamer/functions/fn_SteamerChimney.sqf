#include "\z\root_anomalies\addons\steamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local persistent steam-vent FX at a burst crater.
 *
 * Arguments:
 * 0: Vent object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_horn"];

if (_horn getVariable [QGVAR(chimneyOn), false]) exitWith {};
_horn setVariable [QGVAR(chimneyOn), true, true];

while {!isNull _horn} do {
    waitUntil {uiSleep 10; player distance _horn < 1500};
    private _vent = "#particlesource" createVehicleLocal (getPos _horn);
    _vent setParticleCircle [0, [0, 0, 0]];
    _vent setParticleRandom [2, [0.1, 0.1, 1], [0, 0, 0], 2, 0.5, [0, 0, 0, 0.1], 1, 0];
    private _params = selectRandom [
        [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 4 + round (random 4), [0, 0, 0], [0, 0, 0.3], 5, 10, 7.9, random 0.1, [0.3, 0.5, 2], [[1, 1, 1, 0], [1, 1, 1, 0.5], [1, 1, 1, 0]], [0.8], 0.5, 0, "", "", _horn],
        [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 4 + round (random 4), [0, 0, 0], [0, 0, 0.2], 5, 10, 7.9, random 0.1, [0.2, 0.5, 2], [[1, 1, 1, 0.1], [1, 1, 1, 0.3], [1, 1, 1, 0]], [0.5], 0.5, 0, "", "", _horn]
    ];
    _vent setParticleParams _params;
    _vent setDropInterval 0.1;
    private _vapour = selectRandom ["vapori_01", "vapori_02", "vapori_03"];
    while {player distance _horn < 1500} do {
        _horn say3D [_vapour, 100];
        uiSleep 8.5;
    };
    deleteVehicle _vent;
};
