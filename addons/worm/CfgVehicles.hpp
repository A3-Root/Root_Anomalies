#include "\z\root_anomalies\addons\main\module_attributes.hpp"

class CfgVehicles {
	// ---- Zeus (ZEN) module ----
	class zen_modules_moduleBase;
	class ROOT_Worm_ModuleZeus: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "ROOT_Worm_ModuleZeus";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_worm_fnc_WormZeus";
		displayName = "Worm Anomaly";
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

	class ROOT_Worm_Module3DEN: Module_F {
		scope = 2;
		displayName = "Worm Anomaly";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_worm_fnc_Worm3DEN";
		functionPriority = 1;
		isGlobal = 2;
		isTriggerActivated = 0;
		isDisposable = 1;
		is3DEN = 0;
		icon = "\a3\Modules_F_Curator\Data\iconLightning_ca.paa";
		class AttributeValues {};
		class Attributes: AttributesBase {
			class ROOT_WORM_RADIUS: Edit {
				property = "ROOT_WORM_RADIUS";
				displayName = "Territory Radius (m)";
				tooltip = "Radius in meters of the Worm's territory (minimum 200 unless overridden).";
				typeName = "NUMBER";
				defaultValue = "200";
			};
			class ROOT_WORM_OVERRIDE: Checkbox {
				property = "ROOT_WORM_OVERRIDE";
				displayName = "Override Minimum Territory";
				tooltip = "Allow a territory radius below 200m.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ROOT_WORM_AIPANIC: Checkbox {
				property = "ROOT_WORM_AIPANIC";
				displayName = "AI Panic";
				tooltip = "If checked, AI flee from the Worm during attacks.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ROOT_WORM_DIFFUSER: Edit {
				property = "ROOT_WORM_DIFFUSER";
				displayName = "Worm Diffuser";
				tooltip = "Classname of the throwable used to kill the Worm.";
				typeName = "STRING";
				defaultValue = """SmokeShellGreen""";
			};
			class ROOT_WORM_DAMAGE: Edit {
				property = "ROOT_WORM_DAMAGE";
				displayName = "Damage (0-1)";
				tooltip = "Fraction of damage dealt to targets per strike.";
				typeName = "NUMBER";
				defaultValue = "0.6";
			};
			class ROOT_WORM_FORCETGT: Edit {
				property = "ROOT_WORM_FORCETGT";
				displayName = "Diversion Device";
				tooltip = "Throwable classname (magazine or ammo, e.g. SmokeShellBlue or a chemlight) the Worm fixates on when it lands in its territory. It attacks that spot instead of people for the configured number of attacks, even after the device burns out. Empty = none.";
				typeName = "STRING";
				defaultValue = """""";
			};
			class ROOT_WORM_FORCEN: Edit {
				property = "ROOT_WORM_FORCEN";
				displayName = "Diversion Device Attacks";
				tooltip = "How many attacks the Worm spends on a thrown diversion device before it goes back to hunting people.";
				typeName = "NUMBER";
				defaultValue = "3";
			};
			ROOT_GEAR_MODULE_ATTRIBUTES
			ROOT_CAPTURE_MODULE_ATTRIBUTES
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Spawns a Worm anomaly at the module position. Configure via the attributes.";
		};
	};
};
