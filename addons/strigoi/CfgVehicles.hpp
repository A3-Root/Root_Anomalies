#include "\z\root_anomalies\addons\main\module_attributes.hpp"

class CfgVehicles {
	// ---- Zeus (ZEN) module ----
	class zen_modules_moduleBase;
	class ROOT_Strigoi_ModuleZeus: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "ROOT_Strigoi_ModuleZeus";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_strigoi_fnc_StrigoiZeus";
		displayName = "Strigoi Anomaly";
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

	class ROOT_Strigoi_Module3DEN: Module_F {
		scope = 2;
		displayName = "Strigoi Anomaly";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_strigoi_fnc_Strigoi3DEN";
		functionPriority = 1;
		isGlobal = 2;
		isTriggerActivated = 0;
		isDisposable = 1;
		is3DEN = 0;
		icon = "\A3\Modules_F_Curator\Data\portraitEffectsZeus_ca.paa";
		class AttributeValues {};
		class Attributes: AttributesBase {
			class ROOT_STRIGOI_HEALTH: Edit {
				property = "ROOT_STRIGOI_HEALTH";
				displayName = "Health";
				tooltip = "Damage the Strigoi absorbs before dying.";
				typeName = "NUMBER";
				defaultValue = "400";
			};
			class ROOT_STRIGOI_RADIUS: Edit {
				property = "ROOT_STRIGOI_RADIUS";
				displayName = "Territory Radius (m)";
				tooltip = "Radius in meters of the Strigoi's territory (minimum 75 unless overridden).";
				typeName = "NUMBER";
				defaultValue = "75";
			};
			class ROOT_STRIGOI_OVERRIDE: Checkbox {
				property = "ROOT_STRIGOI_OVERRIDE";
				displayName = "Override Minimum Territory";
				tooltip = "Allow a territory radius below 75m.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ROOT_STRIGOI_DAMAGE: Edit {
				property = "ROOT_STRIGOI_DAMAGE";
				displayName = "Damage (0-1)";
				tooltip = "Fraction of damage dealt to targets per attack.";
				typeName = "NUMBER";
				defaultValue = "0.6";
			};
			class ROOT_STRIGOI_AIPANIC: Checkbox {
				property = "ROOT_STRIGOI_AIPANIC";
				displayName = "AI Panic";
				tooltip = "If checked, AI flee from the Strigoi during attacks.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ROOT_STRIGOI_NIGHTONLY: Checkbox {
				property = "ROOT_STRIGOI_NIGHTONLY";
				displayName = "Night Mode Only";
				tooltip = "If checked, the Strigoi is only active during the night.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			ROOT_GEAR_MODULE_ATTRIBUTES
			ROOT_CAPTURE_MODULE_ATTRIBUTES
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Spawns a Strigoi anomaly at the module position. Configure via the attributes.";
		};
	};
};
