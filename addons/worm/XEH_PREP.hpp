// Precompiles Worm functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(Worm3DEN);
PREP(WormAttack);
PREP(WormBump);
PREP(WormEffect);
PREP(WormKill);
PREP(WormMain);
PREP(WormPostInit);
PREP(WormZeus);
