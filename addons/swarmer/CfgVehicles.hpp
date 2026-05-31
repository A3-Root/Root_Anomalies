class CfgVehicles {
	// ---- Zeus (ZEN) module ----
	class zen_modules_moduleBase;
	class ROOT_Swarmer_ModuleZeus: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "ROOT_Swarmer_ModuleZeus";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_swarmer_fnc_SwarmerZeus";
		displayName = "Swarmer Anomaly";
		curatorCanAttach = 1;
	};

	// ---- 3DEN Editor module ----
	class Logic;
	class Module_F: Logic {
		class AttributesBase {
			class Edit;
			class Checkbox;
			class ModuleDescription;
		};
		class ModuleDescription;
	};

	class ROOT_Swarmer_Module3DEN: Module_F {
		scope = 2;
		displayName = "Swarmer Anomaly";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_swarmer_fnc_Swarmer3DEN";
		functionPriority = 1;
		isGlobal = 2;
		isTriggerActivated = 0;
		isDisposable = 1;
		is3DEN = 0;
		icon = "\A3\Modules_F_Curator\Data\portraitEffectsZeus_ca.paa";
		class AttributeValues {};
		class Attributes: AttributesBase {
			class ROOT_SWARMER_HIVE: Edit {
				property = "ROOT_SWARMER_HIVE";
				displayName = "Hive Object";
				tooltip = "Classname of the object used to spawn the Swarmer.";
				typeName = "STRING";
				defaultValue = """Land_GarbageBags_F""";
			};
			class ROOT_SWARMER_RADIUS: Edit {
				property = "ROOT_SWARMER_RADIUS";
				displayName = "Territory Radius (m)";
				tooltip = "Radius in meters of the Swarmer's territory (minimum 75 unless overridden).";
				typeName = "NUMBER";
				defaultValue = "75";
			};
			class ROOT_SWARMER_OVERRIDE: Checkbox {
				property = "ROOT_SWARMER_OVERRIDE";
				displayName = "Override Minimum Territory";
				tooltip = "Allow a territory radius below 75m.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ROOT_SWARMER_DISABLEPEST: Checkbox {
				property = "ROOT_SWARMER_DISABLEPEST";
				displayName = "Disable Pesticide";
				tooltip = "If checked, the Swarmer cannot be killed with pesticide.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ROOT_SWARMER_PESTICIDE: Edit {
				property = "ROOT_SWARMER_PESTICIDE";
				displayName = "Pesticide";
				tooltip = "Classname of the throwable (grenade/smoke) used to kill the Swarmer.";
				typeName = "STRING";
				defaultValue = """SmokeShellGreen""";
			};
			class ROOT_SWARMER_DAMAGE: Edit {
				property = "ROOT_SWARMER_DAMAGE";
				displayName = "Damage (0-1)";
				tooltip = "Fraction of damage dealt to targets per bite.";
				typeName = "NUMBER";
				defaultValue = "0.6";
			};
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Spawns a Swarmer anomaly (insect hive) at the module position. Configure via the attributes.";
		};
	};
};
