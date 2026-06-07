#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Returns targets (men and land vehicles) within the Flamer's territory.
 *
 * Arguments:
 * 0: Flamer object <OBJECT>
 * 1: Territory radius <NUMBER>
 *
 * Return Value:
 * Candidate targets <ARRAY of OBJECT>
 *
 * Public: No
 */

params ["_flamer", "_territoryRadius"];

((ASLToAGL getPosATL _flamer) nearEntities [["CAManBase", "LandVehicle"], _territoryRadius]) - [_flamer]
