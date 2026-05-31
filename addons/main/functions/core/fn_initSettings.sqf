#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Registers all CBA settings for Root's Anomalies. Runs at preInit
 *              (CfgFunctions preInit = 1) on every machine.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call root_anomalies_main_fnc_initSettings;
 *
 * Public: No
 */

#define SETTING_CATEGORY "Root's Anomalies"

// Verbose debug logging to the RPT file.
[
    SETTING_DEBUG,
    "CHECKBOX",
    ["Verbose Debug Logging", "Log detailed anomaly diagnostics to the RPT file. Enable when troubleshooting; disable for normal play."],
    [SETTING_CATEGORY, "Core"],
    false,
    1,
    {},
    false
] call CBA_fnc_addSetting;

// Affect whitelist - if non-empty, only these classes/kinds may be harmed by anomalies.
[
    SETTING_AFFECT_WHITELIST,
    "EDITBOX",
    ["Affect Whitelist", "Comma-separated classnames/base classes that anomalies MAY damage. Leave empty to allow all (still subject to the blacklist). Uses isKindOf, so base classes like ""Man"" or ""Car"" work."],
    [SETTING_CATEGORY, "Targeting"],
    "",
    1,
    {
        missionNamespace setVariable [SETTING_AFFECT_WHITELIST, _this, true];
    },
    false
] call CBA_fnc_addSetting;

// Immune blacklist - these classes/kinds are never harmed by anomalies.
[
    SETTING_IMMUNE_BLACKLIST,
    "EDITBOX",
    ["Immune Blacklist", "Comma-separated classnames/base classes that anomalies will NEVER damage. Takes priority over the whitelist. Uses isKindOf."],
    [SETTING_CATEGORY, "Targeting"],
    "",
    1,
    {
        missionNamespace setVariable [SETTING_IMMUNE_BLACKLIST, _this, true];
    },
    false
] call CBA_fnc_addSetting;

// Default detection device classname (front-ends may fall back to this).
[
    SETTING_DEFAULT_DETECTOR,
    "EDITBOX",
    ["Default Detection Device", "Fallback classname used as an anomaly detector when a module leaves the field empty."],
    [SETTING_CATEGORY, "Devices"],
    "MineDetector",
    1,
    {
        missionNamespace setVariable [SETTING_DEFAULT_DETECTOR, _this, true];
    },
    false
] call CBA_fnc_addSetting;

// Default protection device classname.
[
    SETTING_DEFAULT_PROTECTOR,
    "EDITBOX",
    ["Default Protection Device", "Fallback classname used as anomaly protection gear when a module leaves the field empty."],
    [SETTING_CATEGORY, "Devices"],
    "B_Kitbag_mcamo",
    1,
    {
        missionNamespace setVariable [SETTING_DEFAULT_PROTECTOR, _this, true];
    },
    false
] call CBA_fnc_addSetting;

// Global seizure-safe override - disables all flashing-light FX when on.
[
    SETTING_SEIZURE_SAFE,
    "CHECKBOX",
    ["Seizure-Safe Mode (Global)", "Force-disable all flashing/strobing light effects from every anomaly, overriding per-module settings. Recommended for players with photosensitivity."],
    [SETTING_CATEGORY, "Accessibility"],
    false,
    1,
    {
        missionNamespace setVariable [SETTING_SEIZURE_SAFE, _this, true];
    },
    false
] call CBA_fnc_addSetting;

LOG_INFO("CBA settings registered");
