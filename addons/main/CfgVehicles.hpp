class CfgVehicles {
    // ---- Zeus (ZEN) modules ----
    class zen_modules_moduleBase;

    class ROOT_Terminate_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Terminate_ModuleZeus";
        category = "ROOT_ANOMALIES";
        function = "root_anomalies_main_fnc_TerminateZeus";
        displayName = "Terminate Anomaly";
        curatorCanAttach = 1;
    };

    class ROOT_Configure_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Configure_ModuleZeus";
        category = "ROOT_ANOMALIES";
        function = "root_anomalies_main_fnc_ConfigureZeus";
        displayName = "Reconfigure Anomaly";
        curatorCanAttach = 1;
    };

    // ---- 3DEN Editor modules ----
    class Logic;
    class Module_F: Logic {
        class AttributesBase {
            class Edit;
            class Checkbox;
            class ModuleDescription;
        };
        class ModuleDescription;
    };

    class ROOT_Terminate_Module3DEN: Module_F {
        scope = 2;
        displayName = "Terminate Anomaly";
        category = "ROOT_ANOMALIES";
        function = "root_anomalies_main_fnc_Terminate3DEN";
        functionPriority = 1;
        isGlobal = 2;
        isTriggerActivated = 0;
        isDisposable = 1;
        is3DEN = 0;
        icon = "\A3\Modules_F_Curator\Data\portraitEffectsZeus_ca.paa";
        class AttributeValues {};
        class Attributes: AttributesBase {
            class ROOT_TERM_RADIUS: Edit {
                property = "ROOT_TERM_RADIUS";
                displayName = "Radius (m)";
                tooltip = "Terminate every anomaly within this radius of the module (or the one it is placed on).";
                typeName = "NUMBER";
                defaultValue = "100";
            };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Permanently removes anomalies (including Smuggler/Steamer) within the radius. Fires once at mission start; use the Zeus version for runtime removal.";
        };
    };

    class ROOT_Configure_Module3DEN: Module_F {
        scope = 2;
        displayName = "Reconfigure Anomaly";
        category = "ROOT_ANOMALIES";
        function = "root_anomalies_main_fnc_Configure3DEN";
        functionPriority = 1;
        isGlobal = 2;
        isTriggerActivated = 0;
        isDisposable = 1;
        is3DEN = 0;
        icon = "\A3\Modules_F_Curator\Data\portraitEffectsZeus_ca.paa";
        class AttributeValues {};
        class Attributes: AttributesBase {
            class ROOT_CFG_RADIUS: Edit {
                property = "ROOT_CFG_RADIUS";
                displayName = "Radius (m)";
                tooltip = "Apply to every anomaly within this radius (or the one it is placed on).";
                typeName = "NUMBER";
                defaultValue = "100";
            };
            class ROOT_SIDES: Edit {
                property = "ROOT_SIDES";
                displayName = "Hostile Sides (CSV)";
                tooltip = "Comma-separated sides to attack: WEST,EAST,INDEPENDENT,CIVILIAN. Empty = all.";
                typeName = "STRING";
                defaultValue = """""";
            };
            class ROOT_ACTIVATION: Edit {
                property = "ROOT_ACTIVATION";
                displayName = "Activation Range (m)";
                tooltip = "Players within this distance wake the anomaly's routine.";
                typeName = "NUMBER";
                defaultValue = "1000";
            };
            class ROOT_CFG_DAMAGE: Edit {
                property = "ROOT_CFG_DAMAGE";
                displayName = "Damage (0-1)";
                tooltip = "Fraction of damage the anomaly deals per hit.";
                typeName = "NUMBER";
                defaultValue = "0.4";
            };
            class ROOT_CAPTURE: Checkbox {
                property = "ROOT_CAPTURE";
                displayName = "Capturable";
                tooltip = "Allow the sedation + capture interaction.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Retunes placed anomalies (sides, activation range, damage, capturability) within the radius. Fires once at mission start; use the Zeus version for runtime retuning.";
        };
    };
};
