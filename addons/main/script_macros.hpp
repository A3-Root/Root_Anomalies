/*
 * Author: Root
 * Description: Shared macro definitions for Root's Anomalies.
 *              Included by every component via \z\root_anomalies\main\script_macros.hpp
 *
 * Notes:
 * - CBA macros (QUOTE, QGVAR, GVAR, FUNC, PREP, PATHTOF...) come from CBA via script_mod.hpp.
 * - All settings/state live in missionNamespace under the ROOT_ANOMALIES_ prefix.
 *
 * Public: No
 */

// ============================================================================
// CBA Settings Keys
// ============================================================================
#ifndef SETTING_DEBUG
    #define SETTING_DEBUG "ROOT_ANOMALIES_DEBUG"
#endif
#ifndef SETTING_AFFECT_WHITELIST
    #define SETTING_AFFECT_WHITELIST "ROOT_ANOMALIES_AFFECT_WHITELIST"
#endif
#ifndef SETTING_IMMUNE_BLACKLIST
    #define SETTING_IMMUNE_BLACKLIST "ROOT_ANOMALIES_IMMUNE_BLACKLIST"
#endif
#ifndef SETTING_DEFAULT_DETECTOR
    #define SETTING_DEFAULT_DETECTOR "ROOT_ANOMALIES_DEFAULT_DETECTOR"
#endif
#ifndef SETTING_DEFAULT_PROTECTOR
    #define SETTING_DEFAULT_PROTECTOR "ROOT_ANOMALIES_DEFAULT_PROTECTOR"
#endif
// Client-side (per-player, NOT global) toggle for flashing/strobing light FX.
#ifndef SETTING_SENS_LIGHTS
    #define SETTING_SENS_LIGHTS "ROOT_ANOMALIES_SENS_LIGHTS_OFF"
#endif

// Default base model for spawned humanoid creatures.
#ifndef ROOT_ANOMALIES_VR_BASE
    #define ROOT_ANOMALIES_VR_BASE "B_VR_Soldier_F"
#endif

// ============================================================================
// Debug / Logging
// ============================================================================
// Runtime debug flag, controlled by CBA setting SETTING_DEBUG.
#ifndef DEBUG_MODE
    #define DEBUG_MODE (missionNamespace getVariable [SETTING_DEBUG, false])
#endif

#ifndef LOG_DEBUG
    #define LOG_DEBUG(msg) if (DEBUG_MODE) then { diag_log text format ["[ROOT_ANOMALIES] (%1) %2", __FILE__, msg] }
#endif
#ifndef LOG_DEBUG_1
    #define LOG_DEBUG_1(msg,a1) if (DEBUG_MODE) then { diag_log text format ["[ROOT_ANOMALIES] (%1) " + msg, __FILE__, a1] }
#endif
#ifndef LOG_DEBUG_2
    #define LOG_DEBUG_2(msg,a1,a2) if (DEBUG_MODE) then { diag_log text format ["[ROOT_ANOMALIES] (%1) " + msg, __FILE__, a1, a2] }
#endif
#ifndef LOG_DEBUG_3
    #define LOG_DEBUG_3(msg,a1,a2,a3) if (DEBUG_MODE) then { diag_log text format ["[ROOT_ANOMALIES] (%1) " + msg, __FILE__, a1, a2, a3] }
#endif

#ifndef LOG_ERROR
    #define LOG_ERROR(msg) diag_log text format ["[ROOT_ANOMALIES][ERROR] (%1) %2", __FILE__, msg]
#endif
#ifndef LOG_INFO
    #define LOG_INFO(msg) diag_log text format ["[ROOT_ANOMALIES] %1", msg]
#endif

// ============================================================================
// Sensitivity-lights helper
// ============================================================================
// True when flashing/strobing light FX must be suppressed. Purely client-side:
// each player controls it locally via the SETTING_SENS_LIGHTS CBA setting.
#ifndef SENS_LIGHTS_OFF
    #define SENS_LIGHTS_OFF (missionNamespace getVariable [SETTING_SENS_LIGHTS, false])
#endif

// ============================================================================
// Function precompilation (XEH_PREP)
// ============================================================================
// CBA's default PREP expects a flat functions\ dir and fnc_ file naming. This mod
// keeps functions in sub-folders (core\, api\, capture\, ...) with fn_ naming, so we
// override PREP to the Warlords-style form and redefine it per sub-folder inside each
// component's XEH_PREP.hpp (e.g. #define PREP(f) ...functions\core\fn_##f.sqf...).
#ifdef PREP
    #undef PREP
#endif
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

// PREP_API compiles a function from main\functions\api\ straight into the clean public
// namespace root_anomalies_fnc_<name> (no component segment) — the documented API surface.
#define PREP_API(fncName) [QPATHTOF(functions\api\DOUBLES(fn,fncName).sqf),QUOTE(TRIPLES(PREFIX,fnc,fncName))] call CBA_fnc_compileFunction

// Quoted public-API function name, e.g. QAPI(spawn) -> "root_anomalies_fnc_spawn".
#define API(fncName) TRIPLES(PREFIX,fnc,fncName)
#define QAPI(fncName) QUOTE(API(fncName))

// ============================================================================
// Additional debug logging arities
// ============================================================================
#ifndef LOG_DEBUG_4
    #define LOG_DEBUG_4(msg,a1,a2,a3,a4) if (DEBUG_MODE) then { diag_log text format ["[ROOT_ANOMALIES] (%1) " + msg, __FILE__, a1, a2, a3, a4] }
#endif

// ============================================================================
// Anomaly framework constants
// ============================================================================
// Default sedative throwable honoured by every anomaly's capture system.
#ifndef ROOT_ANOMALIES_SEDATIVE_SMOKE
    #define ROOT_ANOMALIES_SEDATIVE_SMOKE "ROOT_SmokeShell_Sedative"
#endif

// Tanky-by-default durability: high max HP, low incoming-damage multiplier.
#ifndef ROOT_ANOMALIES_DEFAULT_HEALTH
    #define ROOT_ANOMALIES_DEFAULT_HEALTH 25
#endif
#ifndef ROOT_ANOMALIES_DEFAULT_DMGMULT
    #define ROOT_ANOMALIES_DEFAULT_DMGMULT 0.15
#endif
#ifndef ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME
    #define ROOT_ANOMALIES_DEFAULT_CAPTURE_TIME 30
#endif

// Default activation range (m): players within this distance wake the anomaly's routine.
#ifndef ROOT_ANOMALIES_DEFAULT_ACTIVATION
    #define ROOT_ANOMALIES_DEFAULT_ACTIVATION 1000
#endif

// CBA event raised (global) when an anomaly instance is captured: args [anomaly].
#ifndef ROOT_ANOMALIES_EVENT_CAPTURED
    #define ROOT_ANOMALIES_EVENT_CAPTURED "root_anomalies_captured"
#endif
// CBA event raised (global) when an anomaly instance is killed/disabled: args [anomaly].
#ifndef ROOT_ANOMALIES_EVENT_KILLED
    #define ROOT_ANOMALIES_EVENT_KILLED "root_anomalies_killed"
#endif
