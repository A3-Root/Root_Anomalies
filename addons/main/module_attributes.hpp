// Shared 3DEN module attributes common to every Root's Anomalies module.
// Include inside a Module_F "Attributes" block via ROOT_COMMON_MODULE_ATTRIBUTES.
// Read back in module handlers via EFUNC(main,cfgFromLogic).

#define ROOT_COMMON_MODULE_ATTRIBUTES \
    class ROOT_AFFECTAI: Checkbox { \
        property = "ROOT_AFFECTAI"; \
        displayName = "Affect AI"; \
        tooltip = "If checked, AI (not just players) count as observers/prey/targets."; \
        typeName = "BOOL"; \
        defaultValue = "true"; \
    }; \
    class ROOT_HEALTH: Edit { \
        property = "ROOT_HEALTH"; \
        displayName = "Health"; \
        tooltip = "Hit points the anomaly absorbs before being killed/disabled. High = tanky."; \
        typeName = "NUMBER"; \
        defaultValue = "25"; \
    }; \
    class ROOT_DMGMULT: Edit { \
        property = "ROOT_DMGMULT"; \
        displayName = "Damage Multiplier"; \
        tooltip = "Incoming-damage scale. 0 = invulnerable, 1 = full damage. Low = tanky."; \
        typeName = "NUMBER"; \
        defaultValue = "0.15"; \
    }; \
    class ROOT_SIDES: Edit { \
        property = "ROOT_SIDES"; \
        displayName = "Hostile Sides (CSV)"; \
        tooltip = "Comma-separated sides to attack: WEST,EAST,INDEPENDENT,CIVILIAN. Empty = all."; \
        typeName = "STRING"; \
        defaultValue = """"""; \
    }; \
    class ROOT_CAPTURE: Checkbox { \
        property = "ROOT_CAPTURE"; \
        displayName = "Capturable"; \
        tooltip = "Allow the sedation + capture interaction on this anomaly."; \
        typeName = "BOOL"; \
        defaultValue = "true"; \
    }; \
    class ROOT_CAPTURETIME: Edit { \
        property = "ROOT_CAPTURETIME"; \
        displayName = "Capture Time (s)"; \
        tooltip = "Seconds of interaction required to capture while sedated."; \
        typeName = "NUMBER"; \
        defaultValue = "30"; \
    }; \
    class ROOT_SEDATION: Edit { \
        property = "ROOT_SEDATION"; \
        displayName = "Sedation Classes (CSV)"; \
        tooltip = "Custom smoke/throwable classnames that sedate this anomaly. Empty = default sedative smoke."; \
        typeName = "STRING"; \
        defaultValue = """"""; \
    }; \
    class ROOT_KILLSWITCH: Edit { \
        property = "ROOT_KILLSWITCH"; \
        displayName = "Killswitch Classes (CSV)"; \
        tooltip = "Ammo/explosive classnames that instantly kill this anomaly. Empty = none."; \
        typeName = "STRING"; \
        defaultValue = """"""; \
    };

// Capture-only subset for the legacy creatures (they keep their own health/damage model
// and targeting, so only the sedation/capture options are exposed).
#define ROOT_CAPTURE_MODULE_ATTRIBUTES \
    class ROOT_CAPTURE: Checkbox { \
        property = "ROOT_CAPTURE"; \
        displayName = "Capturable"; \
        tooltip = "Allow the sedation + 30s capture interaction (removes the anomaly)."; \
        typeName = "BOOL"; \
        defaultValue = "true"; \
    }; \
    class ROOT_CAPTURETIME: Edit { \
        property = "ROOT_CAPTURETIME"; \
        displayName = "Capture Time (s)"; \
        tooltip = "Seconds of interaction required to capture while sedated."; \
        typeName = "NUMBER"; \
        defaultValue = "30"; \
    }; \
    class ROOT_SEDATION: Edit { \
        property = "ROOT_SEDATION"; \
        displayName = "Sedation Classes (CSV)"; \
        tooltip = "Custom smoke/throwable classnames that sedate this anomaly. Empty = default sedative smoke."; \
        typeName = "STRING"; \
        defaultValue = """"""; \
    };
