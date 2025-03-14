
 

if (!hasInterface) exitWith {};

params ["_tgt_poz", "_crater_bool"];

_blow_poz = "CraterLong_small" createVehicleLocal [_tgt_poz select 0, _tgt_poz select 1, -0.5]; _blow_poz hideObjectGlobal true; _blow_poz setDir round (random 360);
_blow_poz setVectorUp surfaceNormal getPosATL _blow_poz;
enableCamShake true;
explozie = "root_anomalies\main\sounds\explozie_3.ogg";
pietre = "root_anomalies\main\sounds\pietre.ogg";
eko_01 = "root_anomalies\main\sounds\eko_01.ogg";
eko_02 = "root_anomalies\main\sounds\eko_02.ogg";
_eko = selectRandom [eko_01, eko_02];

playSound3D ["root_anomalies\main\sounds\explozie_3.ogg", "", false, [getPos _blow_poz select 0, getPos _blow_poz select 1, 1], 7, 5, 0];
_bolovani = "#particlesource" createVehicleLocal (getPos _blow_poz);
_bolovani setParticleCircle [0.5, [-3, -3, 0]];
_bolovani setParticleRandom [0.1, [0.3, 0.3, 0], [5, 5, 50], 0, 0.2, [0, 0, 0, 0.1], 1, 0];
_bolovani setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 10, [0, 0, 0], [2, 2, 20], 2, 200, 5, 3, [0.5, 0.5, 0.5], [[0, 0, 0, 1], [0, 0, 0, 1], [0, 0, 0, 1]], [1], 1, 0, "", "", _blow_poz, round (random 360), true, 0.1];
_bolovani setDropInterval 0.01;	
[_bolovani] spawn {params ["_sterg"]; uiSleep 0.5; deleteVehicle _sterg};
_pp = linearConversion [0, 100, player distance _blow_poz, 5, 0, true];
addCamShake [_pp, 2, 30];
uiSleep 0.5;

_jet = selectRandom ["gheizer_4", "gheizer_3", "gheizer_2", "gheizer_1"];
_blow_poz say3D ["gheizer_1", 400];

_blast = "#particlesource" createVehicleLocal (getPos _blow_poz);
_blast setParticleCircle [1, [0, 0, 0]];
_blast setParticleRandom [0.1, [0.1, 0.1, 0.1], [0, 0, 0], 2, 0.1, [0, 0, 0, 0.1], 1, 0];
_blast setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 3, [0, 0, 0], [0, 0, 3], 5, 13, 7.9, 0, [4, 10, 15], [[1, 1, 1, 0.1], [1, 1, 1, 0.2], [1, 1, 1, 0]], [0.8], 0, 0, "", "", _blow_poz];
_blast setDropInterval 0.05;
[_blast] spawn {params ["_sterg"]; uiSleep 0.5; deleteVehicle _sterg};

_wave = "#particlesource" createVehicleLocal (getPos _blow_poz);
_wave setParticleCircle [0.5, [-3, -3, 0]];
_wave setParticleRandom [0.1, [0.1, 0.1, 0.1], [-7, -7, 0], 5, 0.1, [0, 0, 0, 0.1], 1, 0];
_wave setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 1, [0, 0, 0], [0, 0, 0.1], 5, 10, 7.9, 0, [3, 3, 3], [[1, 1, 1, 0.1], [1, 1, 1, 0.2], [1, 1, 1, 0]], [0.5], 1, 0, "", "", _blow_poz];
_wave setDropInterval 0.002;
[_wave] spawn {params ["_sterg"]; uiSleep 0.5; deleteVehicle _sterg};

_blow_poz hideObjectGlobal false;
if (_crater_bool) then {[_blow_poz] spawn Root_fnc_SteamerChimney;};
	
_coloana = "#particlesource" createVehicleLocal (getPos _blow_poz);
_coloana setParticleCircle [0, [0, 0, 0]];
_coloana setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_coloana setParticleParams [["\A3\data_f\cl_water", 1, 0, 1], "", "Billboard", 1, 4, [0, 0, 0], [0, 0, 15], 5, 55, 7.9, 0.05, [1.2, 7, 10], [[1, 1, 1, 0.5], [1, 1, 1, 0.2], [1, 1, 1, 0]], [0.1], 1, 0, "", "", _blow_poz];	
_coloana setDropInterval 0.01;
[_coloana] spawn {params ["_sterg"]; uiSleep 1; deleteVehicle _sterg};
_poz_eko = getPos _blow_poz;
[_eko, _poz_eko] spawn {
		params ["_eko", "_blow_poz"];
		uiSleep 1;
		playSound3D ["root_anomalies\main\sounds\eko_01.ogg", "", false, [_blow_poz select 0, _blow_poz select 1, 500], 7, 5, 0];
	};
_dropsX = selectRandom ["drops_01", "drops_02", "drops_03"];
uiSleep 3.3;
_drops = "#particlesource" createVehicleLocal (getPos _blow_poz);
_drops setParticleCircle [3.5, [0, 0, 0]];
_drops setParticleRandom [0.1, [3, 3, 0], [0, 0, 0], 3, 0.1, [0, 0, 0, 0.1], 0, 0];
_drops setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 0.2, [0, 0, 0], [0, 0, 0.15], 11, 12, 7.9, 0.075, [0.3, 2, 1], [[1, 1, 1, 0.3], [1, 1, 1, 0.1], [1, 1, 1, 0]], [1], 1, 0, "", "", _blow_poz, 0, true];
_drops setDropInterval 0.01;	
[_drops] spawn {params ["_sterg"]; uiSleep 1.6; deleteVehicle _sterg};
_blow_poz say3D [_dropsX, 400];

if (player distance _blow_poz < 50) then {playSound "debris"};

uiSleep 60;
deleteVehicle _blow_poz;