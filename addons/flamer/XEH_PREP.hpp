// Precompiles Flamer functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(Flamer3DEN);
PREP(FlamerAtk);
PREP(FlamerEnd);
PREP(FlamerEndSfx);
PREP(FlamerJump);
PREP(FlamerMain);
PREP(FlamerPlasma);
PREP(FlamerSfx);
PREP(FlamerSplash);
PREP(FlamerZeus);
