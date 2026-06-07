// Precompiles Smuggler functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(Smuggler3DEN);
PREP(SmugglerAIAvoid);
PREP(SmugglerAIVisible);
PREP(SmugglerBlink);
PREP(SmugglerHop);
PREP(SmugglerMain);
PREP(SmugglerPpRun);
PREP(SmugglerProtected);
PREP(SmugglerReveal);
PREP(SmugglerSfx);
PREP(SmugglerSpawn);
PREP(SmugglerSuction);
PREP(SmugglerTeleEffect);
PREP(SmugglerTeleport);
PREP(SmugglerVidEffect);
PREP(SmugglerZeus);
