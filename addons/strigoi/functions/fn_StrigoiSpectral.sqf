#include "\z\root_anomalies\addons\strigoi\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Spawns the Strigoi's glow particle sources on its bone anchors and starts a
 *              loop that swaps the day/night particle params. Returns the source objects.
 *
 * Arguments:
 * 0: Anchor parts <ARRAY of OBJECT>
 * 1: Day/night effect-param arrays <ARRAY>
 *
 * Return Value:
 * Particle source objects <ARRAY of OBJECT>
 *
 * Public: No
 */

params ["_parts", "_effectArrays"];

private _sources = [];
private _arr = _effectArrays select (parseNumber (sunOrMoon >= 0.5));
{
    private _src = "#particlesource" createVehicleLocal (getPosATL _x);
    _src setParticleCircle [0, [0, 0, 0]];
    _src setParticleRandom (_arr select 0);
    _src setParticleParams (_x call (_arr select 1));
    _src setDropInterval 0.05;
    _sources pushBackUnique _src;
} forEach _parts;

[_sources, _effectArrays, _parts] spawn {
    params ["_sources", "_effectArrays", "_parts"];
    while {(_sources isNotEqualTo []) && {!isNull (_parts select 0)}} do {
        uiSleep 3;
        private _arr = _effectArrays select (parseNumber (sunOrMoon >= 0.5));
        {
            _x setParticleRandom (_arr select 0);
            _x setParticleParams ((_parts select (_sources find _x)) call (_arr select 1));
        } forEach _sources;
    };
};
_sources
