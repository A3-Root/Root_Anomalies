#include "\z\root_anomalies\addons\flamer\script_component.hpp"
/*
 * Author: Root
 * Description: Client-side notification used to warn a player when their immunity gear fails.
 *              Uses ACE's structured text when ACE is present, otherwise a plain hint, so it
 *              works with and without ACE loaded.
 *
 * Arguments:
 * 0: Message <STRING>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params [["_msg", "", [""]]];

if (isClass (configFile >> "CfgPatches" >> "ace_common")) then {
    [_msg, 1.5, [1, 0.3, 0.1, 1]] call ace_common_fnc_displayTextStructured;
} else {
    hint _msg;
};

playSound "FD_Start_F";
