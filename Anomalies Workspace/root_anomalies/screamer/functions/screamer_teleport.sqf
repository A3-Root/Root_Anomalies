


if (!hasInterface) exitWith {};

private ["_obj_eff", "_claymore", "_blur_sonic", "_blur_pos", "_blur_surround_pos"];

_obj_eff = _this select 0;

_obj_eff say3D ["teleport_screamer", 500];

addCamShake [1, 5, 25];

_blur_sonic = "#particlesource" createVehicleLocal (getPosATL _obj_eff);
_blur_sonic setParticleCircle [0, [0, 0, 0]];
_blur_sonic setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_blur_sonic setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 2, [0, 0, 0], [0, 0, 0], 12, 12, 6, 0.002, [7, 5, 1], [[1, 1, 1, 0.5], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _obj_eff];
_blur_sonic setDropInterval 0.01;

_blur_pos = getPosATL _obj_eff;
_blur_surround_pos = [(_blur_pos select 0) + random [-25, 0, 25], (_blur_pos select 1) + random [-25, 0, 25], (_blur_pos select 2) + random [1, 3, 5]];

uiSleep 1;
playSound "earthquakes";

uiSleep 3;
deton = "Bomb_03_F" createVehicle _blur_pos;
uiSleep 0.5;


for "_i" from 1 to 3 do {
    _blur_surround_pos = [(_blur_pos select 0) + random [-5, 0, 5], (_blur_pos select 1) + random [-5, 0, 5], (_blur_pos select 2) + random [1, 2, 3]];
    _claymore = "ClaymoreDirectionalMine_Remote_Ammo_Scripted" createVehicle _blur_surround_pos;
    _claymore setDamage 1;
    uiSleep (random[0.4, 0.8, 1.2]);
};

_nearbySpheres = _blur_pos nearObjects ["Sign_Sphere25cm_F", 100];
{
    deleteVehicle _x;
} forEach _nearbySpheres;

deleteVehicle _blur_sonic;
resetCamShake;