// Precompiles Burper functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(Burper3DEN);
PREP(BurperAI);
PREP(BurperBlast);
PREP(BurperDisable);
PREP(BurperFxAnim);
PREP(BurperFxPrimary);
PREP(BurperFxSecondary);
PREP(BurperMain);
PREP(BurperRemove);
PREP(BurperSfx);
PREP(BurperSplash);
PREP(BurperTrap);
PREP(BurperViz);
PREP(BurperZeus);
