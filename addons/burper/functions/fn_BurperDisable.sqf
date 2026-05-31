#include "\z\root_anomalies\addons\burper\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local neutralization pulse FX when the killswitch device is suppressing the Burper.
 *
 * Arguments:
 * 0: Anomaly object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_obj"];

if (player distance _obj < 300) then {
    playSound "device_puls";
    addCamShake [1, 8, 33 + (random 33)];
    private _eff = "#particlesource" createVehicleLocal (getPosATL _obj);
    _eff setParticleCircle [0, [0, 0, 0]];
    _eff setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
    _eff setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 1.7, [0, 0, 0], [0, 0, 0], 7, 10, 7.9, 0.007, [2, 50, 2], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _obj];
    _eff setDropInterval 1.5;
    uiSleep 4;
    deleteVehicle _eff;
};
