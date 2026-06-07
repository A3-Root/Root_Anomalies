#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Returns living targets within the Strigoi's territory (excluding itself).
 *
 * Arguments:
 * 0: Strigoi object <OBJECT>
 * 1: Territory radius <NUMBER>
 *
 * Return Value:
 * Candidate targets <ARRAY of OBJECT>
 *
 * Public: No
 */

params ["_strigoi", "_territoryRadius"];

((ASLToAGL getPosATL _strigoi) nearEntities ["CAManBase", _territoryRadius]) - [_strigoi]
