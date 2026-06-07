// Precompiles Farmer functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(Farmer3DEN);
PREP(FarmerAttack);
PREP(FarmerAvoid);
PREP(FarmerFindTarget);
PREP(FarmerHide);
PREP(FarmerMain);
PREP(FarmerShock);
PREP(FarmerShow);
PREP(FarmerSplash);
PREP(FarmerTeleport);
PREP(FarmerTravel);
PREP(FarmerTravelPath);
PREP(FarmerZeus);
