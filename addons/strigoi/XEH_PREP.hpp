// Precompiles Strigoi functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(Strigoi3DEN);
PREP(StrigoiFatigue);
PREP(StrigoiMain);
PREP(StrigoiSfx);
PREP(StrigoiSplash);
PREP(StrigoiTgt);
PREP(StrigoiViz);
PREP(StrigoiZeus);
