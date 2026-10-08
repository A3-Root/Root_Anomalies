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
			class Combo;
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
		icon = "\a3\Modules_F_Curator\Data\iconLightning_ca.paa";
		class AttributeValues {};
		class Attributes: AttributesBase {
			class ROOT_WRAITH_HEALTH: Edit {
				property = "ROOT_WRAITH_HEALTH";
				displayName = "Health";
				tooltip = "Hits the Wraith takes before it dies.";
				typeName = "NUMBER";
				defaultValue = "400";
			};
			class ROOT_WRAITH_RADIUS: Edit {
				property = "ROOT_WRAITH_RADIUS";
				displayName = "Territory Radius (m)";
				tooltip = "Radius in meters the Wraith hunts in.";
				typeName = "NUMBER";
				defaultValue = "150";
			};
			class ROOT_WRAITH_INTERVAL: Edit {
				property = "ROOT_WRAITH_INTERVAL";
				displayName = "Attack Interval (s)";
				tooltip = "Seconds between claw attacks.";
				typeName = "NUMBER";
				defaultValue = "4";
			};
			class ROOT_WRAITH_DAMAGE: Edit {
				property = "ROOT_WRAITH_DAMAGE";
				displayName = "Damage (0-1)";
				tooltip = "Damage per claw.";
				typeName = "NUMBER";
				defaultValue = "0.3";
			};
			class ROOT_WRAITH_VISION: Combo {
				property = "ROOT_WRAITH_VISION";
				displayName = "Visible Through";
				tooltip = "Which optics reveal the Wraith. To the naked eye it is invisible.";
				typeName = "NUMBER";
				defaultValue = "2";
				class Values {
					class NV {name = "Night vision only"; value = 0;};
					class TI {name = "Thermal only"; value = 1;};
					class Both {name = "Night vision or thermal"; value = 2;};
				};
			};
			class ROOT_WRAITH_SPEED: Edit {
				property = "ROOT_WRAITH_SPEED";
				displayName = "Run Speed";
				tooltip = "Animation speed multiplier while it walks and runs (0.6 - 2).";
				typeName = "NUMBER";
				defaultValue = "1.2";
			};
			ROOT_GEAR_MODULE_ATTRIBUTES
			ROOT_CAPTURE_MODULE_ATTRIBUTES
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Spawns a Wraith at the module position: a ground-bound stalker that walks and runs after the living and claws them. It is invisible to the naked eye and only shows up through night vision and/or thermal optics.";
		};
	};
};
