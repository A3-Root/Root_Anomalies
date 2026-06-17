#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Client-side anticipation cue for fn_deathBlast: a brief charge-up light,
 *              rising rumble and camera shake for players near the dying anomaly, just
 *              before the explosion lands. Honours the client sensitivity-lights toggle.
 *
 * Arguments:
 * 0: Blast position (ATL) <ARRAY>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params [["_pos", [0, 0, 0], [[]], 3]];

private _obj = createVehicle ["#particlesource", _pos, [], 0, "CAN_COLLIDE"];
_obj setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 1.2, [0, 0, 1], [0, 0, 4], 1, 1.275, 1, 0.06, [1, 3], [[1, 0.7, 0.3, 0.7], [0.6, 0.2, 0, 0]], [1], 1, 0, "", "", _obj];
_obj setParticleRandom [0.4, [1, 1, 1], [0, 0, 1], 0, 0.2, [0, 0, 0, 0.1], 0, 0];
_obj setDropInterval 0.02;

private _light = "#lightpoint" createVehicleLocal _pos;
_light setLightColor [1, 0.6, 0.2];
_light setLightAmbient [0.6, 0.3, 0.1];
_light setLightAttenuation [0, 0, 50, 200];

if (player distance _pos < 120) then {
    [_pos] spawn {
        params ["_pos"];
        private _t = time + 1.1;
        while {time < _t} do {
            if (!SENS_LIGHTS_OFF) then {addCamShake [4 + random 3, 0.3, 25]};
            uiSleep 0.1;
        };
    };
};

[{
    params ["_obj", "_light"];
    deleteVehicle _obj;
    deleteVehicle _light;
}, [_obj, _light], 1.3] call CBA_fnc_waitAndExecute;
