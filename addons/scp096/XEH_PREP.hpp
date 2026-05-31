// Precompiles SCP-096 functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(main);
PREP(watch);
PREP(report);
PREP(module3DEN);
PREP(moduleZeus);
PREP(playerInit);
PREP(playerObserveEval);
