// Precompiles Flamer functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(Flamer3DEN);
PREP(FlamerAtk);
PREP(FlamerAttack);
PREP(FlamerAvoid);
PREP(FlamerBurn);
PREP(FlamerEnd);
PREP(FlamerEndSfx);
PREP(FlamerFindTarget);
PREP(FlamerFlames);
PREP(FlamerHide);
PREP(FlamerJump);
PREP(FlamerLeap);
PREP(FlamerMain);
PREP(FlamerPlasma);
PREP(FlamerSfx);
PREP(FlamerShow);
PREP(FlamerSplash);
PREP(FlamerZeus);
