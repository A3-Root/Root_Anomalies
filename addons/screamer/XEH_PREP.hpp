// Precompiles Screamer functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(Screamer3DEN);
PREP(ScreamerAvoid);
PREP(ScreamerEffect);
PREP(ScreamerMain);
PREP(ScreamerVehicleDamage);
PREP(ScreamerSplash);
PREP(ScreamerTeleport);
PREP(ScreamerZeus);
