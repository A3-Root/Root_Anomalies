#include "\z\root_anomalies\addons\farmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Returns targets (men and land vehicles) within the Farmer's territory.
 *
 * Arguments:
 * 0: Farmer object <OBJECT>
 * 1: Territory radius <NUMBER>
 *
 * Return Value:
 * Candidate targets <ARRAY of OBJECT>
 *
 * Public: No
 */

params ["_farmer", "_territoryRadius"];

((ASLToAGL getPosATL _farmer) nearEntities [["CAManBase", "LandVehicle"], _territoryRadius]) - [_farmer]
