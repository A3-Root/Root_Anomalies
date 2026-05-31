class CfgVehicles {
	// ---- Zeus (ZEN) module ----
	class zen_modules_moduleBase;
	class ROOT_Steamer_ModuleZeus: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "ROOT_Steamer_ModuleZeus";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_SteamerZeus";
		displayName = "Steamer Anomaly";
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

	class ROOT_Steamer_Module3DEN: Module_F {
		scope = 2;
		displayName = "Steamer Anomaly";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Steamer3DEN";
		functionPriority = 1;
		isGlobal = 2;
		isTriggerActivated = 0;
		isDisposable = 1;
		is3DEN = 0;
		icon = "\A3\Modules_F_Curator\Data\portraitEffectsZeus_ca.paa";
		class AttributeValues {};
		class Attributes: AttributesBase {
			class ROOT_STEAMER_RADIUS: Edit {
				property = "ROOT_STEAMER_RADIUS";
				displayName = "Territory Radius (m)";
				tooltip = "Radius in meters of the Steamer's territory (minimum 75 unless overridden).";
				typeName = "NUMBER";
				defaultValue = "75";
			};
			class ROOT_STEAMER_OVERRIDE: Checkbox {
				property = "ROOT_STEAMER_OVERRIDE";
				displayName = "Override Minimum Territory";
				tooltip = "Allow a territory radius below 75m.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ROOT_STEAMER_DAMAGE: Edit {
				property = "ROOT_STEAMER_DAMAGE";
				displayName = "Damage (0-1)";
				tooltip = "Fraction of damage dealt to targets per burst.";
				typeName = "NUMBER";
				defaultValue = "0.2";
			};
			class ROOT_STEAMER_RECHARGE: Edit {
				property = "ROOT_STEAMER_RECHARGE";
				displayName = "Recharge Delay (s)";
				tooltip = "Seconds between Steamer bursts.";
				typeName = "NUMBER";
				defaultValue = "10";
			};
			class ROOT_STEAMER_DEATHDMG: Edit {
				property = "ROOT_STEAMER_DEATHDMG";
				displayName = "Death Damage (0-1)";
				tooltip = "Fraction of damage dealt to the surroundings when the Steamer dies.";
				typeName = "NUMBER";
				defaultValue = "0.6";
			};
			class ROOT_STEAMER_TRAVELPATH: Checkbox {
				property = "ROOT_STEAMER_TRAVELPATH";
				displayName = "Show Travel Path";
				tooltip = "If checked, the Steamer digs a visible mud trail toward its target.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Spawns a Steamer anomaly at the module position. Configure via the attributes.";
		};
	};
};
