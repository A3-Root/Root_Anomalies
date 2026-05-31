#include "script_version.hpp"

#define MAINPREFIX z
#define PREFIX root_anomalies

#define VERSION     MAJOR.MINOR
#define VERSION_STR MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_AR  MAJOR,MINOR,PATCHLVL,BUILD

// MINIMAL required Arma 3 version for the mod.
#define REQUIRED_VERSION 2.18

// CBA macros
#include "\x\cba\addons\main\script_macros_common.hpp"

#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)
