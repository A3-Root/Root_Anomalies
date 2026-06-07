#include "\z\root_anomalies\addons\swarmer\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Returns living targets within the hive's territory (excluding the agent).
 *
 * Arguments:
 * 0: Swarmer agent <OBJECT>
 * 1: Territory radius <NUMBER>
 * 2: Hive object <OBJECT>
 *
 * Return Value:
 * Candidate targets <ARRAY of OBJECT>
 *
 * Public: No
 */

params ["_agent", "_territoryRadius", "_hiveObj"];

((getPosATL _hiveObj) nearEntities ["CAManBase", _territoryRadius]) - [_agent]
