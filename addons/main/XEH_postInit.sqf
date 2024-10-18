#include "script_component.hpp"

if (!hasInterface) exitWith {};


#include "modules\module_behaviourCrew.inc.sqf"
#include "modules\module_captive.inc.sqf"
#include "modules\module_carBomb.inc.sqf"
#include "modules\module_channelVisibility.inc.sqf"
#include "modules\module_configureDoors.inc.sqf"
#include "modules\module_createResupply.inc.sqf"
#include "modules\module_deleteObjectForced.inc.sqf"
#include "modules\module_deleteZeus.inc.sqf"
#include "modules\module_dogAttack.inc.sqf"
#include "modules\module_dustStorm.inc.sqf"
#include "modules\module_garrisonBuilding.inc.sqf"
#include "modules\module_gearScript.inc.sqf"
#include "modules\module_grassRender.inc.sqf"
#include "modules\module_mapMarkers.inc.sqf"
#include "modules\module_missionEndModifier.inc.sqf"
#include "modules\module_missionObjectCounter.inc.sqf"
#include "modules\module_pauseTime.inc.sqf"
#include "modules\module_removeGrenades.inc.sqf"
#include "modules\module_suicideBomber.inc.sqf"
#include "modules\module_switchUnit.inc.sqf"
#include "modules\module_toggleConsciousnessForced.inc.sqf"
#include "modules\module_trackUnitDeath.inc.sqf"
#include "modules\module_unitParadrop.inc.sqf"
#include "modules\module_unitParadropAction.inc.sqf"
#include "modules\module_vehicleExplosionPrevention.inc.sqf"

// Optionals
private _cfgPatches = configFile >> "CfgPatches";
GVAR(ACEClipboardLoaded) = if (getNumber (_cfgPatches >> "ace_main" >> "version") >= 3.18) then {
    [0, 2] select (("ace" callExtension ["version", []]) params [["_versionEx", "", [""]], ["_returnCode", -1, [-1]]])
} else {
    parseNumber (isClass (configFile >> "ACE_Extensions" >> "ace_clipboard"))
};

// Check if ACE Dragging is loaded
if (!isNil "ace_dragging") then {
    #include "modules\module_dragAndCarry.inc.sqf"
};

// Check if ACE Medical components are loaded
if (!isNil "ace_medical_damage") then {
    #include "modules\module_createInjuries.inc.sqf"
};

if (zen_common_aceMedicalTreatment) then {
    #include "modules\module_createResupplyMedical.inc.sqf"
};

// Check if TFAR is loaded
if (isClass (_cfgPatches >> "tfar_core") || {isClass (_cfgPatches >> "task_force_radio")}) then {
    #include "modules\module_tfarRadioRange.inc.sqf"
};

// Check if RHS AFRF is loaded
if (isClass (_cfgPatches >> "rhs_main_loadorder")) then {
    #include "modules\module_rhsAps.inc.sqf"
};
// Optionals finished

// Hint what is missing once CBA settings have been loaded
["CBA_settingsInitialized", {
    private _cfgPatches = configFile >> "CfgPatches";
    private _notificationArray = [];

    // Check if ACE Dragging is loaded
    if (isNil "ace_dragging") then {
        private _string = LLSTRING(aceDraggingMissing);
        INFO(_string);

        if (GVAR(enableACEDragHint)) then {
            _notificationArray pushBack _string;
        };
    };

    // Check if ACE Medical is loaded
    if !(GETMVAR("ace_medical_enabled",zen_common_aceMedical)) then {
        private _string = LLSTRING(aceMedicalMissing);
        INFO(_string);

        if (GVAR(enableACEMedicalHint)) then {
            _notificationArray pushBack _string;
        };
    };

    // Check if TFAR is loaded
    if (!isClass (_cfgPatches >> "tfar_core") && {!isClass (_cfgPatches >> "task_force_radio")}) then {
        private _string = LLSTRING(tfarMissing);
        INFO(_string);

        if (GVAR(enableTFARHint)) then {
            _notificationArray pushBack _string;
        };
    };

    // Check if RHS AFRF is loaded
    if (!isClass (_cfgPatches >> "rhs_main_loadorder")) then {
        private _string = LLSTRING(rhsMissing);
        INFO(_string);

        if (GVAR(enableRHSHint)) then {
            _notificationArray pushBack _string;
        };
    };

    // Hint what is missing if wanted
    if (_notificationArray isEqualTo []) exitWith {};

    _notificationArray insert [0, ["[Zeus Additions]:"]];

    {
        systemChat _x;
    } forEach _notificationArray;
}] call CBA_fnc_addEventHandler;
