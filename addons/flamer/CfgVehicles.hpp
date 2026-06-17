#include "\z\root_anomalies\addons\main\module_attributes.hpp"

class CfgVehicles {
	// ---- Zeus (ZEN) module ----
	class zen_modules_moduleBase;
	class ROOT_Flamer_ModuleZeus: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "ROOT_Flamer_ModuleZeus";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_flamer_fnc_FlamerZeus";
		displayName = "Flamer Anomaly";
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

	class ROOT_Flamer_Module3DEN: Module_F {
		scope = 2;
		displayName = "Flamer Anomaly";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_flamer_fnc_Flamer3DEN";
		functionPriority = 1;
		isGlobal = 2;
		isTriggerActivated = 0;
		isDisposable = 1;
		is3DEN = 0;
		icon = "\A3\Modules_F_Curator\Data\portraitEffectsZeus_ca.paa";
		class AttributeValues {};
		class Attributes: AttributesBase {
			class ROOT_FLAMER_HEALTH: Edit {
				property = "ROOT_FLAMER_HEALTH";
				displayName = "Health";
				tooltip = "Damage the Flamer absorbs before dying.";
				typeName = "NUMBER";
				defaultValue = "400";
			};
			class ROOT_FLAMER_RADIUS: Edit {
				property = "ROOT_FLAMER_RADIUS";
				displayName = "Territory Radius (m)";
				tooltip = "Radius in meters of the Flamer's territory (minimum 75 unless overridden).";
				typeName = "NUMBER";
				defaultValue = "75";
			};
			class ROOT_FLAMER_OVERRIDE: Checkbox {
				property = "ROOT_FLAMER_OVERRIDE";
				displayName = "Override Minimum Territory";
				tooltip = "Allow a territory radius below 75m.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ROOT_FLAMER_DAMAGE: Edit {
				property = "ROOT_FLAMER_DAMAGE";
				displayName = "Damage (0-1)";
				tooltip = "Fraction of damage dealt to targets per attack.";
				typeName = "NUMBER";
				defaultValue = "0.4";
			};
			class ROOT_FLAMER_RECHARGE: Edit {
				property = "ROOT_FLAMER_RECHARGE";
				displayName = "Recharge Delay (s)";
				tooltip = "Seconds between Flamer actions. Lower is more aggressive.";
				typeName = "NUMBER";
				defaultValue = "1";
			};
			class ROOT_FLAMER_DEATHDMG: Edit {
				property = "ROOT_FLAMER_DEATHDMG";
				displayName = "Death Damage (0-1)";
				tooltip = "Fraction of damage dealt to the surroundings when the Flamer dies.";
				typeName = "NUMBER";
				defaultValue = "1";
			};
			class ROOT_FLAMER_AIPANIC: Checkbox {
				property = "ROOT_FLAMER_AIPANIC";
				displayName = "AI Panic";
				tooltip = "If checked, AI flee from the Flamer during attacks.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ROOT_FLAMER_PROTGEAR: Edit {
				property = "ROOT_FLAMER_PROTGEAR";
				displayName = "Protective Gear (CSV)";
				tooltip = "Comma-separated gear classnames that reduce Flamer damage by the protection percentage. Empty = none.";
				typeName = "STRING";
				defaultValue = """""";
			};
			class ROOT_FLAMER_PROTPCT: Edit {
				property = "ROOT_FLAMER_PROTPCT";
				displayName = "Protection (0-1)";
				tooltip = "Fraction of damage removed while wearing protective gear (0.5 = halved).";
				typeName = "NUMBER";
				defaultValue = "0.5";
			};
			class ROOT_FLAMER_IMMGEAR: Edit {
				property = "ROOT_FLAMER_IMMGEAR";
				displayName = "Immunity Gear (CSV)";
				tooltip = "Comma-separated gear classnames that grant full immunity until their durability is spent. Empty = none.";
				typeName = "STRING";
				defaultValue = """""";
			};
			class ROOT_FLAMER_IMMMODE: Edit {
				property = "ROOT_FLAMER_IMMMODE";
				displayName = "Immunity Mode";
				tooltip = "How immunity gear wears out: Infinite (never), Time (seconds), or Damage (total damage absorbed).";
				typeName = "STRING";
				defaultValue = """Infinite""";
			};
			class ROOT_FLAMER_IMMVALUE: Edit {
				property = "ROOT_FLAMER_IMMVALUE";
				displayName = "Immunity Value";
				tooltip = "Seconds (Time) or total damage (Damage) the immunity gear lasts. 0 or Infinite mode = never fails.";
				typeName = "NUMBER";
				defaultValue = "0";
			};
			ROOT_CAPTURE_MODULE_ATTRIBUTES
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Spawns a Flamer anomaly at the module position. Configure via the attributes.";
		};
	};
};
