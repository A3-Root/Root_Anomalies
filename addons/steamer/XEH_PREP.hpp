// Precompiles Steamer functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(Steamer3DEN);
PREP(SteamerAvoid);
PREP(SteamerBurst);
PREP(SteamerChimney);
PREP(SteamerEnd);
PREP(SteamerFindTarget);
PREP(SteamerKillVehicle);
PREP(SteamerMain);
PREP(SteamerRagdoll);
PREP(SteamerTravel);
PREP(SteamerTravelPath);
PREP(SteamerVoice);
PREP(SteamerZeus);
