// Precompiles every Root's Anomalies core/capture function and the public API.
// PREP is redefined per sub-folder; PREP_API compiles into root_anomalies_fnc_*.

// ---- core\ (internal helpers: root_anomalies_main_fnc_*) ----
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\core\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(initSettings);
PREP(parseClassList);
PREP(isAffectable);
PREP(applyDamage);
PREP(isObserving);
PREP(mergeConfig);
PREP(idleTarget);
PREP(parseSides);
PREP(cfgFromLogic);

// ---- capture\ (internal: root_anomalies_main_fnc_*) ----
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\capture\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(initDamage);
PREP(handleDamage);
PREP(sedationWatch);
PREP(addCaptureInteraction);
PREP(doCapture);

// ---- api\ (public surface: root_anomalies_fnc_*) ----
PREP_API(registerDriver);
PREP_API(spawn);
PREP_API(configure);
PREP_API(getCfg);
PREP_API(setCfg);
PREP_API(getInstances);
PREP_API(setWaypoints);
PREP_API(addWaypoint);
PREP_API(setHostileSides);
PREP_API(setState);
PREP_API(setHealth);
PREP_API(setDamageMult);
PREP_API(setDamageFilter);
PREP_API(setKillswitch);
PREP_API(setSedationClasses);
PREP_API(capture);
PREP_API(uncapture);
PREP_API(addBait);
PREP_API(addTrap);
