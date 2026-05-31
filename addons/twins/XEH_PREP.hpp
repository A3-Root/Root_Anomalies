// Precompiles Twins functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(Twins3DEN);
PREP(TwinsDamage);
PREP(TwinsEffect);
PREP(TwinsEmp);
PREP(TwinsInima);
PREP(TwinsMain);
PREP(TwinsViz);
PREP(TwinsZeus);
