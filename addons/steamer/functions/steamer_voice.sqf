
 

if (!hasInterface) exitWith {};

params ["_steamer_dud"];
private ["_steamer_dud"];

_soundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;
voice_01 = _soundPath + "\z\root_anomalies\addons\main\sounds\steamer_01.ogg";
voice_02 = _soundPath + "\z\root_anomalies\addons\main\sounds\steamer_02.ogg";

while {alive _steamer_dud} do 
{
	_steamer_dud say3D ["boil_mic", 300];
	_voice = selectRandom [voice_01,voice_02];
	playSound3D [_voice, "", false, [getPosATL _steamer_dud select 0, getPosATL _steamer_dud select 1, 100], 0.2, 5, 1];
	uiSleep 10; /* uiSleep 40; */
};