// Precompiles Wraith functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(Wraith3DEN);
PREP(WraithMain);
PREP(WraithSfx);
PREP(WraithZeus);
