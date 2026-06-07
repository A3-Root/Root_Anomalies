// Precompiles Strigoi functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(Strigoi3DEN);
PREP(StrigoiAttack);
PREP(StrigoiAvoid);
PREP(StrigoiDrain);
PREP(StrigoiFatigue);
PREP(StrigoiFindTarget);
PREP(StrigoiHide);
PREP(StrigoiJump);
PREP(StrigoiLeap);
PREP(StrigoiMain);
PREP(StrigoiPerch);
PREP(StrigoiSfx);
PREP(StrigoiShow);
PREP(StrigoiSpectral);
PREP(StrigoiSplash);
PREP(StrigoiTgt);
PREP(StrigoiViz);
PREP(StrigoiZeus);
