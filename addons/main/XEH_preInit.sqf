#include "script_component.hpp"
/*
 * Author: Root
 * Description: CBA PreInit handler for Root's Anomalies core. Precompiles all
 *              core/capture/API functions and registers CBA settings.
 *
 * Public: No
 */

ADDON = false;

#include "XEH_PREP.hpp"

// Driver + live-instance registries (server authoritative; clients keep a local copy
// of instances for FX/observation wiring).
if (isNil QGVAR(drivers)) then { GVAR(drivers) = createHashMap; };
if (isNil QGVAR(instances)) then { GVAR(instances) = []; };

call FUNC(initSettings);

ADDON = true;
