#include "script_component.hpp"
/*
 * Author: Root
 * Description: PostInit handler for SCP-173. Registers the anomaly driver with the
 *              unified API and binds the manual "Blink" keybind.
 *
 * Public: No
 */

private _defaults = createHashMapFromArray [
    ["model", ROOT_ANOMALIES_VR_BASE],
    ["radius", 150],
    ["observeDist", 1000],
    ["blinkInterval", 7],
    ["killDist", 2.5],
    ["speed", 7],
    ["affectAI", true],
    ["health", ROOT_ANOMALIES_DEFAULT_HEALTH],
    ["damageMult", ROOT_ANOMALIES_DEFAULT_DMGMULT],
    ["captureEnabled", true],
    ["captureTime", ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME],
    ["captureRadius", 15],
    ["hostileSides", []]
];

["scp173", FUNC(main), _defaults] call API(registerDriver);

if (hasInterface) then {
    [
        "root_anomalies",
        "scp173_blink",
        ["Blink (SCP-173)", "Blink now to refresh the blink timer while watching SCP-173."],
        { [7] call FUNC(blink); true },
        {false},
        [48, [false, false, false]]
    ] call CBA_fnc_addKeybind;
};
