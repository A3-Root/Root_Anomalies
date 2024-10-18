// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!isServer) exitWith {};

#include "farmer_functions.hpp"

private ["_pozitie_noua", "_tgt_farmer", "_list_unit_range_farm"];
params ["_marker_farmer", "_territory", "_damage_inflicted", "_recharge_delay", "_health_points", "_isaipanic"];
_soundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimstring;
explozie = "..\sounds\punch_7.ogg";
pietre = "..\sounds\pietre.ogg";
travel_ground = "..\sounds\travel_ground.ogg";
eko = "..\sounds\eko.ogg";
publicVariable "explozie";
publicVariable "pietre";
publicVariable "travel_ground";
publicVariable "eko";
_ck_pl = false;

while {!_ck_pl} do {
    {
        if (_x distance getMarkerPos _marker_farmer < _territory) then {
            _ck_pl = true
        }
    } forEach allPlayers;
    uiSleep 5; // uiSleep 10;
};

_farmer = createAgent ["C_Soldier_VR_F", getMarkerPos _marker_farmer, [], 0, "NONE"];
_farmer setVariable ["BIS_fnc_animalbehaviour_disable", true];
_farmer setSpeaker "NoVoice";
_farmer disableConversation true;_farmer addRating -10000; _farmer setBehaviour "CARELESS";
_farmer enableFatigue false;
_farmer setSkill ["courage", 1];_farmer setUnitPos "UP"; _farmer disableAI "ALL"; _farmer setMass 7000;

{
    _farmer enableAI _x
} forEach ["move", "ANIM", "teamSwitch", "PATH"];

_hp_curr_farmer = 1/_health_points;
_farmer setVariable ["al_dam_total", 0];
_farmer setVariable ["al_dam_incr", _hp_curr_farmer];
_farmer removeAllEventHandlers "Hit";

_farmer addEventHandler ["Hit", {
    _unit=_this#0;
    _curr_dam = (_unit getVariable "al_dam_total")+(_unit getVariable "al_dam_incr"); _unit setVariable ["al_dam_total", _curr_dam];if ((_unit getVariable "al_dam_total")>1) then {
        _unit setDamage 1
    };
    [[_unit], "farmer_splash_hit.sqf"] remoteExec ["execVM"]
}];

_farmer removeAllEventHandlers "HandleDamage";

_farmer addEventHandler ["HandleDamage", {
    0
}];

_farmer addEventHandler ["Killed", {
    (_this select 0) hideObjectGlobal true;
    (_this select 1) addRating 2000
}];

for "_i" from 0 to 5 do {
    _farmer setObjectMaterialGlobal [_i, "\a3\data_f\default.rvmat"]
};

for "_i" from 0 to 5 do {
    _farmer setObjectTextureGlobal [_i, "#(argb, 8, 8, 3)color(0, 0.5, 0, 0.5)"]
};

for "_i" from 0 to 5 do {
    _farmer setObjectTextureGlobal [_i, "a3\structures_f_mark\training\data\shootingmat_01_opfor_co.paa"]
};

_farmer call fnc_hide_farmer;
_farmer enableSimulationGlobal false;

while {alive _farmer} do {
    _ck_pl = false;
    _farmer setUnitPos "UP";
    while {!_ck_pl} do {
        {
            if (_x distance getMarkerPos _marker_farmer < _territory) then {
                _ck_pl = true
            }
        } forEach allPlayers;
        uiSleep 5; // uiSleep 30
    };
    _list_unit_range_farm = [_farmer, _territory] call fnc_find_target_farm;
    _tgt_farmer = selectRandom (_list_unit_range_farm select {
        (typeOf _x != "VirtualCurator_F") && (lifeState _x != "INCAPACITATED")
    });
    _farmer setUnitPos "UP";
    _farmer enableSimulationGlobal true;
    _farmer setUnitPos "UP";
    [_farmer, getMarkerPos _marker_farmer] call fnc_show_farmer;
    while {
        (!isNil "_tgt_farmer")&&{
            (alive _farmer)&&((_farmer distance getMarkerPos _marker_farmer) < _territory)
        }
    } do
    {
        _farmer setDir (_farmer getRelDir _tgt_farmer);
        if ((_farmer distance _tgt_farmer)>20) then {
            _farmer call fnc_hide_farmer;
            [_farmer, _tgt_farmer] call fnc_travel_farmer;
            _pozitie_noua = _farmer getVariable "pozitie_noua";
            [_farmer, _pozitie_noua] call fnc_show_farmer;
            if (_isaipanic) then 
            {
                {
                    [_farmer, _x] spawn fnc_avoid_farmer
                } forEach _list_unit_range_farm;
            };
            uiSleep 1;
        };
        _farmer setUnitPos "UP";
        if ((_farmer distance _tgt_farmer)<20) then {
            uiSleep 1;
            [_farmer, _damage_inflicted] call fnc_attk_farmer;
            if (_isaipanic) then 
            {
                {
                    [_farmer, _x] spawn fnc_avoid_farmer
                } forEach _list_unit_range_farm;
            };
            uiSleep _recharge_delay;
        } else {
            uiSleep 1+random 2;
            _farmer call fnc_hide_farmer
        };
        _farmer setUnitPos "UP";
        if ((!alive _tgt_farmer)or(_tgt_farmer distance getMarkerPos _marker_farmer > _territory)) then {
            _list_unit_range_farm = [_farmer, _territory] call fnc_find_target_farm;
            if !(count _list_unit_range_farm isEqualTo 0) then {
                _tgt_farmer = selectRandom (_list_unit_range_farm select { (typeOf _x != "VirtualCurator_F") && (lifeState _x != "INCAPACITATED") });
            } else {
                _tgt_farmer = nil
            };
        };
    };
    _farmer setUnitPos "UP";
    uiSleep 1;
    _farmer call fnc_hide_farmer;
    	_farmer enableSimulationGlobal false;
    _list_unit_range_farm =[];
    _farmer setUnitPos "UP";
};

playSound3D ["..\sounds\eko.ogg", "", false, [getPos _farmer select 0, getPos _farmer select 1, 100], 20, 5, 0];

deleteVehicle _farmer;