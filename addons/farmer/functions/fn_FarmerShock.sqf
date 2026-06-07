#include "\z\root_anomalies\addons\farmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local shockwave attack FX. Throws and damages the local player when in range.
 *
 * Arguments:
 * 0: Farmer object <OBJECT>
 * 1: Damage fraction <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_farmer", ["_damage", 0.6, [0]]];

enableCamShake true;

_farmer setAnimSpeedCoef 0.1;
_farmer switchMove "ChopperLight_L_Out_H";
_farmer setVelocity [0, 0, 3];
uiSleep 0.4;
_farmer setAnimSpeedCoef 1.8;
_farmer switchMove "AmovPercMstpSnonWnonDnon_AmovPknlMstpSnonWnonDnon";
uiSleep 0.2;

_farmer say3D ["explozie_3", 100];

private _burst = "#particlesource" createVehicleLocal getPosATL _farmer;
_burst setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 0], "", "BillBoard", 1, 1, [0, 0, 0.5], [0, 0, 4], 0, 13, 0.01, 0, [0.5, 8], [[0.1, 0.1, 0.1, 1], [0.1, 0.1, 0.1, 0]], [1000], 1, 0, "", "", _farmer];
_burst setParticleRandom [0, [0, 0, 0], [0, 0, 2], 0, 0, [0, 0, 0, 0], 0, 0, 0];
_burst setDropInterval 0.05;

private _blastWave = "#particlesource" createVehicleLocal getPosATL _farmer;
_blastWave setParticleRandom [0.1, [0, 0, 2], [10, 10, 0], 0, 1, [0, 0, 0, 0.5], 1, 0];
_blastWave setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 3, [0, 0, 0], [0, 0, 0], 0, 10, 8, 0, [5, 8], [[0.05, 0.04, 0.03, 0.3], [0.05, 0.04, 0.03, 0]], [1], 1, 0, "", "", _farmer];
_blastWave setDropInterval 0.01;

private _rocks = "#particlesource" createVehicleLocal getPosATL _farmer;
_rocks setParticleRandom [0, [0.5, 0.5, 0], [0, 0, 2], 0, 0.5, [0, 0, 0, 1], 1, 0, 90];
_rocks setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 0.1, 10, [0, 0, 0], [0, 0, 3], 1, 50 + random 100, 5, 0.1, [1, 0.05], [[0, 0, 0, 1], [0, 0, 0, 1]], [1], 1, 0, "", "", _farmer, 0, true, 0.1];
_rocks setDropInterval 0.005;

private _dust = "#particlesource" createVehicleLocal getPosATL _farmer;
_dust setParticleCircle [10, [0, 0, 0]];
_dust setParticleRandom [5, [5, 5, 2], [0, 0, 0], 1, 1, [0, 0, 0, 0.1], 0, 0];
_dust setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 8, [0, 0, 0], [0, 0, 0], 3, 10.15, 7.9, 0.1, [10, 10, 10], [[0.05, 0.04, 0.03, 0.1], [0.05, 0.04, 0.03, 0.3], [0.05, 0.04, 0.03, 0]], [1], 1, 0, "", "", _farmer];
_dust setDropInterval 0.01;
[_dust] spawn {params ["_p"]; uiSleep 1; deleteVehicle _p};

_farmer say3D ["pietre", 5000];
for "_i" from 1 to 20 do {
    _burst setParticleCircle [_i, [0, 0, 0]];
    _rocks setParticleCircle [_i, [0, 0, 0]];
    _blastWave setParticleCircle [_i, [0, 0, 0]];
    if ((player distance _farmer) < _i) then {
        private _pp = linearConversion [0, 100, _i, 5, 0, true];
        [player, 1] call BIS_fnc_dirtEffect;
        addCamShake [_pp, 2, 30];
        private _jumpDir = (getPosATL _farmer vectorFromTo getPosATL player) vectorMultiply 3;
        player setVelocity [_jumpDir select 0, _jumpDir select 1, 3];
        private _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
        if !(player isKindOf "VirtualCurator_F") then {
            [player, _damage, _bodyPart, "falling"] call EFUNC(main,applyDamage);
        };
    };
    uiSleep 0.05;
};

if ((player distance _farmer) < 20) then {
    private _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
    if !(player isKindOf "VirtualCurator_F") then {
        [player, _damage, _bodyPart, "falling"] call EFUNC(main,applyDamage);
    };
};

deleteVehicle _rocks;
deleteVehicle _burst;
deleteVehicle _blastWave;
uiSleep 1;
_farmer switchMove "";
_farmer say3D ["eko", 100];
