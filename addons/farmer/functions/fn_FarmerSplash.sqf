#include "\z\root_anomalies\addons\farmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local debris burst when the Farmer is hit.
 *
 * Arguments:
 * 0: Position reference <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_posHit"];

drop [["\a3\Data_f\ParticleEffects\Universal\WoodParts_03.p3d", 8, 1, 8], "", "SpaceObject", 1, 3, [0, 0, 1], [0, 0, 0], 5, 20, 7.9, 0, [4, 2, 1], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [1], 0, 0, "", "", _posHit];
drop [["\A3\data_f\cl_leaf3", 8, 1, 8], "", "SpaceObject", 1, 1, [0, 0, 1], [0, 0, 3], 4, 15, 8, 0, [3, 3, 2], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [1], 0, 0, "", "", _posHit];
