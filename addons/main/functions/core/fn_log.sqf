#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Writes one diagnostics line to the RPT. Used by the LOG_DEBUG_n macros,
 *              so every line carries the source function, the machine it ran on (host,
 *              dedicated server, headless client or client with its owner id), mission
 *              time and the local player, e.g.
 *              [ROOT_ANOMALIES][farmer\fn_FarmerMain][SERVER t=812.4] FarmerMain spawned ...
 *              With the "Debug Chat" setting on, Zeus users also see it in system chat,
 *              including lines relayed from the server and headless clients.
 *
 * Arguments:
 * 0: Source file (__FILE__) <STRING>
 * 1: Message <STRING>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_file", "", [""]], ["_message", "", [""]]];

// "z\root_anomalies\addons\farmer\functions\fn_FarmerMain.sqf" -> "farmer\fn_FarmerMain"
private _parts = _file splitString "\/";
private _addonIdx = _parts findIf {_x == "addons"};
private _component = _parts param [_addonIdx + 1, "?"];
private _function = _parts param [count _parts - 1, "?"];
if ((_function select [count _function - 4]) == ".sqf") then {_function = _function select [0, count _function - 4]};
private _source = format ["%1\%2", _component, _function];

private _machine = switch (true) do {
    case (isServer && hasInterface): {"HOST"};
    case (isServer): {"SERVER"};
    case (!hasInterface): {format ["HC#%1", clientOwner]};
    default {format ["CLIENT#%1", clientOwner]};
};
private _who = ["", format [" %1", profileName]] select hasInterface;
private _line = format ["[ROOT_ANOMALIES][%1][%2%3 t=%4] %5", _source, _machine, _who, CBA_missionTime toFixed 1, _message];

diag_log text _line;

if !(missionNamespace getVariable ["ROOT_ANOMALIES_DEBUG_CHAT", false]) exitWith {};

if (hasInterface && {!isNull getAssignedCuratorLogic player}) then {systemChat _line};
if (!hasInterface || {isServer}) then {
    private _curators = (allCurators apply {getAssignedCuratorUnit _x}) select {!isNull _x && {_x != player}};
    if (_curators isNotEqualTo []) then {
        ["root_anomalies_logRelay", [_line], _curators] call CBA_fnc_targetEvent;
    };
};
