#include "script_component.hpp"
/*
 * Author: Root
 * Description: CBA PostInit handler for Root's Anomalies core. Anomaly components
 *              register their drivers in their own postInit; this file only ensures
 *              the registries exist on every machine for late wiring.
 *
 * Public: No
 */

if (isNil QGVAR(drivers)) then { GVAR(drivers) = createHashMap; };
if (isNil QGVAR(instances)) then { GVAR(instances) = []; };
