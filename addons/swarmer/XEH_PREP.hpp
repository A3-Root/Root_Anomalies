// Precompiles Swarmer functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(Swarmer3DEN);
PREP(SwarmerAvoid);
PREP(SwarmerBlood);
PREP(SwarmerDead);
PREP(SwarmerEating);
PREP(SwarmerFindTarget);
PREP(SwarmerFlies);
PREP(SwarmerKill);
PREP(SwarmerKillNearby);
PREP(SwarmerMain);
PREP(SwarmerPostInit);
PREP(SwarmerSfx);
PREP(SwarmerVoice);
PREP(SwarmerZeus);
