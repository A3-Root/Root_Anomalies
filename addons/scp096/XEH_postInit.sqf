#include "script_component.hpp"
/*
 * Author: Root
 * Description: PostInit handler for SCP-096. Registers the anomaly driver with the
 *              unified API.
 *
 * Public: No
 */

private _defaults = createHashMapFromArray [
    ["model", ROOT_ANOMALIES_VR_BASE],
    ["triggerRange", 200],
    ["viewTime", 5],
    ["speed", 11],
    ["cooldown", 20],
    ["damage", 1],
    ["affectAI", true],
    ["enrageOnDamage", true],
    ["health", ROOT_ANOMALIES_DEFAULT_HEALTH],
    ["damageMult", ROOT_ANOMALIES_DEFAULT_DMGMULT],
    ["captureEnabled", true],
    ["captureTime", ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME],
    ["captureRadius", 15],
    ["hostileSides", []]
];

["scp096", FUNC(main), _defaults] call API(registerDriver);
