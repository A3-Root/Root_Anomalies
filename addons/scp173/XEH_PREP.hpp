// Precompiles SCP-173 functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(main);
PREP(watch);
PREP(report);
PREP(blink);
PREP(blinkFX);
PREP(module3DEN);
PREP(moduleZeus);
PREP(playerInit);
PREP(playerObserveEval);
