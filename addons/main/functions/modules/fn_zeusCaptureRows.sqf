#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Shared capture/sedation rows appended to the end of every anomaly's Zeus
 *              dialog, so Zeus-spawned anomalies get the same sedation and capture options
 *              as their 3DEN modules. Read back with zeusCaptureApply.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * ZEN dialog rows <ARRAY>
 *
 * Example:
 * _rows = _rows + ([] call root_anomalies_main_fnc_zeusCaptureRows);
 *
 * Public: No
 */

[
    ["TOOLBOX:YESNO", ["Capturable", "Allow the sedation + capture interaction on this anomaly."], true],
    ["SLIDER", ["Capture Time (s)", "Seconds of interaction required to capture while sedated."], [5, 120, ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME, 0]],
    ["EDIT", ["Sedation Classes (CSV)", "Smoke/throwable classnames (magazine or ammo) that sedate this anomaly. Empty = default sedative smoke."], [""]],
    ["SLIDER", ["Sedation Time (s)", "Seconds the anomaly stays sedated (visible, frozen, harmless) after the last sedative smoke clears."], [5, 180, ROOT_ANOMALIES_DEFAULT_SEDATION_TIME, 0]],
    ["SLIDER", ["Post-Sedation Cooldown (s)", "Seconds the anomaly stays docile and cannot attack after waking up."], [0, 120, ROOT_ANOMALIES_DEFAULT_SEDATION_COOLDOWN, 0]]
]
