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
#ifndef SETTING_SEIZURE_SAFE
    #define SETTING_SEIZURE_SAFE "ROOT_ANOMALIES_SEIZURE_SAFE"
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
// Seizure-safe helper
// ============================================================================
// True when flashing-light FX must be suppressed (global override or per-call flag).
#ifndef SEIZURE_SAFE
    #define SEIZURE_SAFE (missionNamespace getVariable [SETTING_SEIZURE_SAFE, false])
#endif
