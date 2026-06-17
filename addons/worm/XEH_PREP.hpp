// Precompiles Worm functions.
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(Worm3DEN);
PREP(WormAttack);
PREP(WormAvoid);
PREP(WormBump);
PREP(WormEffect);
PREP(WormForce);
PREP(WormKill);
PREP(WormKillNearby);
PREP(WormMain);
PREP(WormPostInit);
PREP(WormPressDir);
PREP(WormThrown);
PREP(WormVehicleDamage);
PREP(WormZeus);
