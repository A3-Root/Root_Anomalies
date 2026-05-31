#include "\z\root_anomalies\addons\swarmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local hive/insect ambience for the Swarmer.
 *
 * Arguments:
 * 0: Swarmer agent <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_swarmer"];

enableCamShake true;
uiSleep 5;

while {alive _swarmer} do {
    if (player distance _swarmer < 500) then {_swarmer say3D [selectRandom ["hive_queen_01", "hive_queen_02"], 2000]};
    if (player distance _swarmer < 200) then {_swarmer say3D ["roi_02", 300]};
    if (player distance _swarmer < 15) then {playSound (selectRandom ["insect_01", "insect_03", "insect_04", "insect_05", "insect_07", "insect_08"])};
    if ((player == (_swarmer getVariable [QGVAR(tgt), objNull])) && {player distance _swarmer < 5}) then {addCamShake [5, 2, 5]; [60] call BIS_fnc_bloodEffect};
    uiSleep 11;
};
