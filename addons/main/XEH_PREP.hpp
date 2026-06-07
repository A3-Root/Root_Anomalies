// Precompiles every Root's Anomalies core/capture function and the public API.
// PREP is redefined per sub-folder; PREP_API compiles into root_anomalies_fnc_*.

// ---- core
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\core\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(initSettings);
PREP(parseClassList);
PREP(isAffectable);
PREP(isDamageable);
PREP(applyDamage);
PREP(isObserving);
PREP(mergeConfig);
PREP(idleTarget);
PREP(parseSides);
PREP(cfgFromLogic);
PREP(cfgCapture);
PREP(finalizeInstance);

// ---- capture
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\capture\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(initDamage);
PREP(handleDamage);
PREP(matchDamageType);
PREP(sedationWatch);
PREP(addCaptureInteraction);
PREP(doCapture);

// ---- api
PREP_API(registerDriver);
PREP_API(spawn);
PREP_API(configure);
PREP_API(getCfg);
PREP_API(setCfg);
PREP_API(getInstances);
PREP_API(setWaypoints);
PREP_API(addWaypoint);
PREP_API(setHostileSides);
PREP_API(setTargetUnits);
PREP_API(setTargetGroups);
PREP_API(setExcludeUnits);
PREP_API(setExcludeGroups);
PREP_API(setTargets);
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
