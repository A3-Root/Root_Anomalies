#define COMPONENT main
#include "script_mod.hpp"

#define DEBUG_SYNCHRONOUS

#ifdef DEBUG_ENABLED_ROOT_ANOMALIES
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_ROOT_ANOMALIES
    #define DEBUG_SETTINGS DEBUG_SETTINGS_ROOT_ANOMALIES
#endif

#include "script_macros.hpp"

