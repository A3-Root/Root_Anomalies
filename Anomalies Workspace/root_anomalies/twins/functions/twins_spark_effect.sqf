
 

if (!hasInterface) exitWith {};

_obj_emit = _this select 0;
_paz_emit = _this select 1;

_sparky_sun = selectRandom ["spark1", "spark11", "spark2", "spark22", "spark5", "spark4"];

_spark_type = selectRandom ["white", "orange"];

_drop = 0.001 + (random 0.05);
_scantei_spark = "#particlesource" createVehicleLocal (getPosATL _obj_emit);

if (_spark_type == "orange") then {
	_scantei_spark setParticleCircle [0, [0, 0, 0]];
	_scantei_spark setParticleRandom [2, [0.1, 0.1, 0.1], [0, 0, 0], 0, 0.25, [0, 0, 0, 0], 0, 0];
	_scantei_spark setParticleParams [["\A3\data_f\proxies\muzzle_flash\muzzle_flash_silencer.p3d", 1, 0, 1], "", "SpaceObject", 1, 1.5, [0, 0, 0], [0, 0, 0], 0, 15, 7.9, 0, [2, 2, 1], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0.5]], [0.08], 1, 0, "", "", _obj_emit];
	_scantei_spark setDropInterval _drop;

	_obj_emit say3D [_sparky_sun, 350];
	uiSleep _paz_emit;
	deleteVehicle _scantei_spark;
} else {
		_scantei_spark setParticleCircle [0, [0, 0, 0]];
		_scantei_spark setParticleRandom [1, [0.05, 0.05, 0.1], [5, 5, 3], 0, 0.0025, [0, 0, 0, 0], 0, 0];
		_scantei_spark setParticleParams [["\A3\data_f\proxies\muzzle_flash\muzzle_flash_silencer.p3d", 1, 0, 1], "", "SpaceObject", 1, 1.5, [0, 0, 0], [0, 0, 0], 0, 20, 7.9, 0, [1, 1, 0.5], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0.5]], [0.08], 1, 0, "", "", _obj_emit];
		_scantei_spark setDropInterval 0.001;	
		
		_obj_emit say3D [_sparky_sun, 350];
		uiSleep 0.1 + (random 0.4);
		deleteVehicle _scantei_spark;
	};