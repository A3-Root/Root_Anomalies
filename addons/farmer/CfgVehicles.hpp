class CfgVehicles {
	// ---- Zeus (ZEN) module ----
	class zen_modules_moduleBase;
	class ROOT_Farmer_ModuleZeus: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "ROOT_Farmer_ModuleZeus";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_farmer_fnc_FarmerZeus";
		displayName = "Farmer Anomaly";
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

	class ROOT_Farmer_Module3DEN: Module_F {
		scope = 2;
		displayName = "Farmer Anomaly";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_farmer_fnc_Farmer3DEN";
		functionPriority = 1;
		isGlobal = 2;
		isTriggerActivated = 0;
		isDisposable = 1;
		is3DEN = 0;
		icon = "\A3\Modules_F_Curator\Data\portraitEffectsZeus_ca.paa";
		class AttributeValues {};
		class Attributes: AttributesBase {
			class ROOT_FARMER_HEALTH: Edit {
				property = "ROOT_FARMER_HEALTH";
				displayName = "Health";
				tooltip = "Damage the Farmer absorbs before dying.";
				typeName = "NUMBER";
				defaultValue = "400";
			};
			class ROOT_FARMER_RADIUS: Edit {
				property = "ROOT_FARMER_RADIUS";
				displayName = "Territory Radius (m)";
				tooltip = "Radius in meters of the Farmer's territory (minimum 75 unless overridden).";
				typeName = "NUMBER";
				defaultValue = "75";
			};
			class ROOT_FARMER_OVERRIDE: Checkbox {
				property = "ROOT_FARMER_OVERRIDE";
				displayName = "Override Minimum Territory";
				tooltip = "Allow a territory radius below 75m.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ROOT_FARMER_DAMAGE: Edit {
				property = "ROOT_FARMER_DAMAGE";
				displayName = "Damage (0-1)";
				tooltip = "Fraction of damage dealt to targets per shockwave.";
				typeName = "NUMBER";
				defaultValue = "0.6";
			};
			class ROOT_FARMER_RECHARGE: Edit {
				property = "ROOT_FARMER_RECHARGE";
				displayName = "Recharge Delay (s)";
				tooltip = "Seconds between Farmer attacks.";
				typeName = "NUMBER";
				defaultValue = "5";
			};
			class ROOT_FARMER_AIPANIC: Checkbox {
				property = "ROOT_FARMER_AIPANIC";
				displayName = "AI Panic";
				tooltip = "If checked, AI flee from the Farmer during attacks.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Spawns a Farmer anomaly at the module position. Configure via the attributes.";
		};
	};
};
