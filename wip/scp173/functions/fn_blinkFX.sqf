#include "\z\root_anomalies\addons\scp173\script_component.hpp"
/*
 * Author: Root
 * Description: Plays the SCP-173 "blink" effect: two black bars sweep in from the top and
 *              bottom of the screen to meet in the middle (eyelids closing), hold briefly,
 *              then sweep back out. Purely cosmetic; the not-seeing window is timed
 *              independently in fn_blink.
 *
 * Arguments:
 * 0: Total blink duration (s) <NUMBER> (default 1)
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface || {isNull (findDisplay 46)}) exitWith {};

disableSerialization;

params [["_dur", 1, [0]]];

private _d = findDisplay 46;
private _top = _d ctrlCreate ["RscText", -1];
private _bot = _d ctrlCreate ["RscText", -1];
{
    _x ctrlSetBackgroundColor [0, 0, 0, 1];
    _x ctrlSetText "";
} forEach [_top, _bot];

private _half = (_dur / 2) max 0.05;

// Start fully open (zero-height bars at the screen edges).
_top ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW, 0];
_bot ctrlSetPosition [safeZoneX, safeZoneY + safeZoneH, safeZoneW, 0];
{_x ctrlCommit 0} forEach [_top, _bot];

// Close: bars grow to cover the whole screen.
_top ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW, safeZoneH / 2];
_bot ctrlSetPosition [safeZoneX, safeZoneY + (safeZoneH / 2), safeZoneW, safeZoneH / 2];
{_x ctrlCommit _half} forEach [_top, _bot];

// Re-open, then delete the controls.
[{
    params ["_ctrls", "_half"];
    _ctrls params ["_top", "_bot"];
    _top ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW, 0];
    _bot ctrlSetPosition [safeZoneX, safeZoneY + safeZoneH, safeZoneW, 0];
    {_x ctrlCommit _half} forEach _ctrls;
    [{ {ctrlDelete _x} forEach _this; }, _ctrls, _half] call CBA_fnc_waitAndExecute;
}, [[_top, _bot], _half], _half] call CBA_fnc_waitAndExecute;
