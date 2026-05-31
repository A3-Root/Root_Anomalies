#include "\z\root_anomalies\addons\scp173\script_component.hpp"
/*
 * Author: Root
 * Description: Triggers a blink for the local player: opens a ~1s "eyes closed" window
 *              (during which SCP-173 watchers report not-seeing) and plays the vertical
 *              screen-cut FX. Resets the automatic blink timer, so blinking early via the
 *              keybind refreshes the 7s cycle. Called by the watcher (auto) and the
 *              "Blink" keybind (manual).
 *
 * Arguments:
 * 0: Blink interval to re-arm (s) <NUMBER> (default 7)
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params [["_interval", 7, [0]]];

private _dur = missionNamespace getVariable [QGVAR(blinkDuration), 1];

// Already blinking? Don't stack FX, but still re-arm the timer (manual refresh).
private _now = time;
player setVariable [QGVAR(nextBlink), _now + _interval];

if (_now < (player getVariable [QGVAR(blinkEnd), 0])) exitWith {};

player setVariable [QGVAR(blinkEnd), _now + _dur];
[_dur] call FUNC(blinkFX);
