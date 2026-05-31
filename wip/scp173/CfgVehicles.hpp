#include "\z\root_anomalies\addons\main\module_attributes.hpp"

class CfgVehicles {
	// ---- Zeus (ZEN) module ----
	class zen_modules_moduleBase;
	class ROOT_SCP173_ModuleZeus: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "ROOT_SCP173_ModuleZeus";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_scp173_fnc_moduleZeus";
		displayName = "SCP-173 (The Sculpture)";
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

	class ROOT_SCP173_Module3DEN: Module_F {
		scope = 2;
		displayName = "SCP-173 (The Sculpture)";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_scp173_fnc_module3DEN";
		functionPriority = 1;
		isGlobal = 2;
		isTriggerActivated = 0;
		isDisposable = 1;
		is3DEN = 0;
		icon = "\A3\Modules_F_Curator\Data\portraitEffectsZeus_ca.paa";
		class AttributeValues {};
		class Attributes: AttributesBase {
			class ROOT_SCP173_MODEL: Edit {
				property = "ROOT_SCP173_MODEL";
				displayName = "Model";
				tooltip = "Classname of the unit used as SCP-173 (default: VR soldier).";
				typeName = "STRING";
				defaultValue = """B_VR_Soldier_F""";
			};
			class ROOT_SCP173_RADIUS: Edit {
				property = "ROOT_SCP173_RADIUS";
				displayName = "Territory Radius (m)";
				tooltip = "Radius (up to 5000) within which SCP-173 hunts.";
				typeName = "NUMBER";
				defaultValue = "150";
			};
			class ROOT_SCP173_OBSERVE: Edit {
				property = "ROOT_SCP173_OBSERVE";
				displayName = "Observation Range (m)";
				tooltip = "How close a viewer must be to freeze it (100-5000). Own eyes/binos only; UAV excluded.";
				typeName = "NUMBER";
				defaultValue = "1000";
			};
			class ROOT_SCP173_BLINKINT: Edit {
				property = "ROOT_SCP173_BLINKINT";
				displayName = "Blink Interval (s)";
				tooltip = "Seconds between forced blinks while a player observes SCP-173.";
				typeName = "NUMBER";
				defaultValue = "7";
			};
			class ROOT_SCP173_SPEED: Edit {
				property = "ROOT_SCP173_SPEED";
				displayName = "Speed (m/s)";
				tooltip = "Movement speed while unobserved (abnormally fast, no teleporting).";
				typeName = "NUMBER";
				defaultValue = "7";
			};
			class ROOT_SCP173_KILLDIST: Edit {
				property = "ROOT_SCP173_KILLDIST";
				displayName = "Kill Distance (m)";
				tooltip = "Distance within which SCP-173 snaps a target's neck.";
				typeName = "NUMBER";
				defaultValue = "2.5";
			};
			ROOT_COMMON_MODULE_ATTRIBUTES
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Spawns SCP-173. It cannot move while a player physically sees it (binoculars count, UAV/cameras do not) within the observation range; when unobserved it moves fast toward the nearest victim and snaps their neck.";
		};
	};

	// ---- Player-controlled SCP-173P unit ----
	class Man;
	class CAManBase: Man {};
	class C_man_1: CAManBase {};
	class ROOT_SCP173P: C_man_1 {
		scope = 2;
		scopeCurator = 2;
		displayName = "SCP-173P (The Sculpture - Playable)";
		author = "Root";
		faction = "ROOT_ANOMALIES";
		editorSubcategory = "EdSubcat_Personnel";
	};
};
