// Precompiles Steamer functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(Steamer3DEN);
PREP(SteamerBurst);
PREP(SteamerChimney);
PREP(SteamerEnd);
PREP(SteamerMain);
PREP(SteamerRagdoll);
PREP(SteamerTravel);
PREP(SteamerVoice);
PREP(SteamerZeus);
