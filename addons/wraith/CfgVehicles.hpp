#include "\z\root_anomalies\addons\main\module_attributes.hpp"

class CfgVehicles {
	// ---- Zeus (ZEN) module ----
	class zen_modules_moduleBase;
	class ROOT_Wraith_ModuleZeus: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "ROOT_Wraith_ModuleZeus";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_wraith_fnc_WraithZeus";
		displayName = "Wraith Anomaly";
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

	class ROOT_Wraith_Module3DEN: Module_F {
		scope = 2;
		displayName = "Wraith Anomaly";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_wraith_fnc_Wraith3DEN";
		functionPriority = 1;
		isGlobal = 2;
		isTriggerActivated = 0;
		isDisposable = 1;
		is3DEN = 0;
		icon = "\A3\Modules_F_Curator\Data\portraitEffectsZeus_ca.paa";
		class AttributeValues {};
		class Attributes: AttributesBase {
			class ROOT_WRAITH_MODEL: Edit {
				property = "ROOT_WRAITH_MODEL";
				displayName = "Model";
				tooltip = "Classname of the unit used as the Wraith (default: VR soldier).";
				typeName = "STRING";
				defaultValue = """B_VR_Soldier_F""";
			};
			class ROOT_WRAITH_HEALTH: Edit {
				property = "ROOT_WRAITH_HEALTH";
				displayName = "Health";
				tooltip = "Damage the Wraith absorbs before dying.";
				typeName = "NUMBER";
				defaultValue = "400";
			};
			class ROOT_WRAITH_RADIUS: Edit {
				property = "ROOT_WRAITH_RADIUS";
				displayName = "Territory Radius (m)";
				tooltip = "Radius in meters within which the Wraith stalks.";
				typeName = "NUMBER";
				defaultValue = "150";
			};
			class ROOT_WRAITH_INTERVAL: Edit {
				property = "ROOT_WRAITH_INTERVAL";
				displayName = "Attack Interval (s)";
				tooltip = "Seconds between the Wraith's teleport strikes.";
				typeName = "NUMBER";
				defaultValue = "8";
			};
			class ROOT_WRAITH_DAMAGE: Edit {
				property = "ROOT_WRAITH_DAMAGE";
				displayName = "Damage (0-1)";
				tooltip = "Fraction of fire damage dealt to victims per strike.";
				typeName = "NUMBER";
				defaultValue = "0.4";
			};
			class ROOT_WRAITH_FEAR: Edit {
				property = "ROOT_WRAITH_FEAR";
				displayName = "Fear Radius (m)";
				tooltip = "Radius in meters within which the Wraith inflicts dread effects.";
				typeName = "NUMBER";
				defaultValue = "25";
			};
			class ROOT_WRAITH_SEIZURESAFE: Checkbox {
				property = "ROOT_WRAITH_SEIZURESAFE";
				displayName = "Disable Sensitive Lights";
				tooltip = "If checked, the Wraith's flickering light/dread visuals are disabled.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			ROOT_CAPTURE_MODULE_ATTRIBUTES
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Spawns a floating Wraith at the module position that teleport-stalks the living, burning them and radiating dread.";
		};
	};
};
