
 

if (!hasInterface) exitWith {};

params ["_swarmer"];
private ["_swarmer"];
enableCamShake true;
uiSleep 5;
while {alive _swarmer} do 
{
	if (player distance _swarmer < 500) then {_queen_call = selectRandom ["hive_queen_01", "hive_queen_02"]; _swarmer say3D [_queen_call, 2000]};
	if (player distance _swarmer < 200) then {_swarmer say3D ["roi_02", 300]};
	if (player distance _swarmer < 15) then {_baz_c = selectRandom ["insect_01", "insect_03", "insect_04", "insect_05", "insect_07", "insect_08"]; playSound _baz_c};
	if ((player == _swarmer getVariable "tgt") && (player distance _swarmer < 5)) then {addCamShake [5, 2, 5]; [60] call BIS_fnc_bloodEffect};	
	uiSleep 11;
};