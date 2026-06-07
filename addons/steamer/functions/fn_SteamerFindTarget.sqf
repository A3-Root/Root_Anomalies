#include "\z\root_anomalies\addons\steamer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Returns living targets within the Steamer's territory (excluding itself).
 *
 * Arguments:
 * 0: Steamer object <OBJECT>
 * 1: Territory radius <NUMBER>
 *
 * Return Value:
 * Candidate targets <ARRAY of OBJECT>
 *
 * Public: No
 */

params ["_steamer", "_territoryRadius"];

((ASLToAGL getPosATL _steamer) nearEntities ["CAManBase", _territoryRadius]) - [_steamer]
