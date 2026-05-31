// Precompiles Swarmer functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(Swarmer3DEN);
PREP(SwarmerDead);
PREP(SwarmerEating);
PREP(SwarmerFlies);
PREP(SwarmerKill);
PREP(SwarmerMain);
PREP(SwarmerPostInit);
PREP(SwarmerSfx);
PREP(SwarmerVoice);
PREP(SwarmerZeus);
