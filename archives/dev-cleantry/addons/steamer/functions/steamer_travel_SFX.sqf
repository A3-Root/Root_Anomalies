
 

if (!hasInterface) exitWith {};


_project = _this select 0;

_burst = "#particlesource" createVehicleLocal (getPosATL _project);
_burst setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 0], "", "BillBoard", 1, 1, [0, 0, 0.5], [0, 0, 2], 0, 13, 0.01, 0, [0.5, 8], [[0.1, 0.1, 0.1, 1], [0.1, 0.1, 0.1, 0]], [1000], 1, 0, "", "", _project];
_burst setParticleRandom [0.5, [1, 1, 0.5], [1, 1, 2], 20, 0.1, [0, 0, 0, 0.5], 1, 0, 1, 0];
_burst setParticleCircle [0, [0, 0, 0]];
_burst setDropInterval 0.2;

_ground = "#particlesource" createVehicleLocal (getPosATL _project);
_ground setParticleCircle [0.3, [0, 0, 0]];
_ground setParticleRandom [0, [0.25, 0.25, 0], [0, 0, 0], 0, 0.2, [0, 0, 0, 0], 0, 0];
_ground setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 30, [0, 0, 0], [0, 0, 0.1], 0, 20, 7.9, 0, [1, 0.1], [[1, 1, 1, 1], [1, 1, 1, 0]], [1], 0, 0, "", "", _project, 0, true, 0.1, [[0, 0, 0, 0]]];
_ground setDropInterval 0.05;

uiSleep 0.1;

while {alive _project} do {
    playSound3D ["\z\root_anomalies\addons\main\sounds\al_boil.ogg", "", false, [getPos _project select 0, getPos _project select 1, 0.5], 20, 5, 0]; 
    uiSleep 1;
};
deleteVehicle _ground; deleteVehicle _burst;
