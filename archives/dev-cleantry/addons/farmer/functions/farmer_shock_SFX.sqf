
 

if (!hasInterface) exitWith {};
params ["_farmer", "_damage_farmer"];
enableCamShake true;

_farmer setAnimSpeedCoef 0.1;
_farmer switchMove "ChopperLight_L_Out_H";
_farmer setVelocity [0, 0, 3];
uiSleep 0.4;
_farmer setAnimSpeedCoef 1.8;
_farmer switchMove "AmovPercMstpSnonWnonDnon_AmovPknlMstpSnonWnonDnon";
uiSleep 0.2;

playSound3D ["\z\root_anomalies\addons\main\sounds\explozie_3.ogg", "", false, position _farmer, 20, 5, 0];


_burst = "#particlesource" createVehicleLocal getPosATL _farmer;
_burst setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 0], "", "BillBoard", 1, 1, [0, 0, 0.5], [0, 0, 4], 0, 13, 0.01, 0, [0.5, 8], [[0.1, 0.1, 0.1, 1], [0.1, 0.1, 0.1, 0]], [1000], 1, 0, "", "", _farmer];
_burst setParticleRandom [0, [0, 0, 0], [0, 0, 2], 0, 0, [0, 0, 0, 0], 0, 0, 0];
_burst setDropInterval 0.05;

_blast_wave = "#particlesource" createVehicleLocal getPosATL _farmer;
_blast_wave setParticleRandom [0.1, [0, 0, 2], [10, 10, 0], 0, 1, [0, 0, 0, 0.5], 1, 0];
_blast_wave setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 3, [0, 0, 0], [0, 0, 0], 0, 10, 8, 0, [5, 8], [[0.05, 0.04, 0.03, 0.3], [0.05, 0.04, 0.03, 0]], [1], 1, 0, "", "", _farmer];
_blast_wave setDropInterval 0.01;

_bolovani = "#particlesource" createVehicleLocal getPosATL _farmer;
_bolovani setParticleRandom [0, [0.5, 0.5, 0], [0, 0, 2], 0, 0.5, [0, 0, 0, 1], 1, 0, 90];
_bolovani setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 0.1, 10, [0, 0, 0], [0, 0, 3], 1, 50 + random 100, 5, 0.1, [1, 0.05], [[0, 0, 0, 1], [0, 0, 0, 1]], [1], 1, 0, "", "", _farmer, 0, true, 0.1];
_bolovani setDropInterval 0.005;

_persistent_dust = "#particlesource" createVehicleLocal getPosATL _farmer;
_persistent_dust setParticleCircle [10, [0, 0, 0]];
_persistent_dust setParticleRandom [5, [5, 5, 2], [0, 0, 0], 1, 1, [0, 0, 0, 0.1], 0, 0];
_persistent_dust setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 8, [0, 0, 0], [0, 0, 0], 3, 10.15, 7.9, 0.1, [10, 10, 10], [[0.05, 0.04, 0.03, 0.1], [0.05, 0.04, 0.03, 0.3], [0.05, 0.04, 0.03, 0]], [1], 1, 0, "", "", _farmer];
_persistent_dust setDropInterval 0.01;
[_persistent_dust] spawn {params ["_de_sters"]; uiSleep 1; deleteVehicle _de_sters};

_farmer say3D ["pietre", 5000];
for "_i" from 1 to 20 do {
	_burst setParticleCircle [_i, [0, 0, 0]];
	_bolovani setParticleCircle [_i, [0, 0, 0]];
	_blast_wave setParticleCircle [_i, [0, 0, 0]];
	if ((player distance _farmer) < _i) then {
		_pp = linearConversion [0, 100, _i, 5, 0, true];
		[player, 1] call BIS_fnc_dirtEffect;
		addCamShake [_pp, 2, 30];
		_jump_dir = (getPosATL _farmer vectorFromTo getPosATL player) vectorMultiply 3;
		player setVelocity [_jump_dir select 0, _jump_dir select 1, 3];
		_bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
		_dmgType = selectRandom ["backblast", "bullet", "explosive", "grenade"];
		if !( player isKindOf "VirtualCurator_F") then {
			if (!(isNil "ace_medical_fnc_addDamageToUnit")) then {
				[player, _damage_farmer, _bodyPart, "falling"] remoteExec ["ace_medical_fnc_addDamageToUnit", player];	
			} else {
				player setDamage ((damage player) + _damage_farmer);
			};
		};
	};
	uiSleep 0.05;
};

if ((player distance _farmer) < 20) then {
	_bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
	_dmgType = selectRandom ["backblast", "bullet", "explosive", "grenade"];
	if !(player isKindOf "VirtualCurator_F") then {
		if (!(isNil "ace_medical_fnc_addDamageToUnit")) then {
			[player, _damage_farmer, _bodyPart, "falling"] remoteExec ["ace_medical_fnc_addDamageToUnit", player];	
		} else {
			player setDamage ((damage player) + _damage_farmer);
		};
	};
};
deleteVehicle _bolovani;
deleteVehicle _burst;
deleteVehicle _blast_wave;
uiSleep 1;
_farmer switchMove "";
playSound3D ["\z\root_anomalies\addons\main\sounds\eko.ogg", "", false, [getPos _farmer select 0, getPos _farmer select 1, 100], 20, 5, 0];

