#include "\z\root_anomalies\addons\main\module_attributes.hpp"

class CfgVehicles {
	// ---- Zeus (ZEN) module ----
	class zen_modules_moduleBase;
	class ROOT_SCP096_ModuleZeus: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "ROOT_SCP096_ModuleZeus";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_scp096_fnc_moduleZeus";
		displayName = "SCP-096 (The Shy Guy)";
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

	class ROOT_SCP096_Module3DEN: Module_F {
		scope = 2;
		displayName = "SCP-096 (The Shy Guy)";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_scp096_fnc_module3DEN";
		functionPriority = 1;
		isGlobal = 2;
		isTriggerActivated = 0;
		isDisposable = 1;
		is3DEN = 0;
		icon = "\A3\Modules_F_Curator\Data\portraitEffectsZeus_ca.paa";
		class AttributeValues {};
		class Attributes: AttributesBase {
			class ROOT_SCP096_MODEL: Edit {
				property = "ROOT_SCP096_MODEL";
				displayName = "Model";
				tooltip = "Classname of the unit used as SCP-096 (default: VR soldier).";
				typeName = "STRING";
				defaultValue = """B_VR_Soldier_F""";
			};
			class ROOT_SCP096_TRIGGER: Edit {
				property = "ROOT_SCP096_TRIGGER";
				displayName = "Trigger Range (m)";
				tooltip = "Distance within which viewing SCP-096 counts (any means: eyes, binos, UAV, cameras).";
				typeName = "NUMBER";
				defaultValue = "200";
			};
			class ROOT_SCP096_VIEWTIME: Edit {
				property = "ROOT_SCP096_VIEWTIME";
				displayName = "View Time (s)";
				tooltip = "Seconds of continuous viewing before a viewer becomes a target and it enrages.";
				typeName = "NUMBER";
				defaultValue = "5";
			};
			class ROOT_SCP096_SPEED: Edit {
				property = "ROOT_SCP096_SPEED";
				displayName = "Rage Speed (m/s)";
				tooltip = "How fast SCP-096 sprints (real pathfinding) toward its victims while enraged.";
				typeName = "NUMBER";
				defaultValue = "11";
			};
			class ROOT_SCP096_COOLDOWN: Edit {
				property = "ROOT_SCP096_COOLDOWN";
				displayName = "Calm Cooldown (s)";
				tooltip = "Seconds SCP-096 stays enraged after its last victim before calming.";
				typeName = "NUMBER";
				defaultValue = "20";
			};
			class ROOT_SCP096_DAMAGE: Edit {
				property = "ROOT_SCP096_DAMAGE";
				displayName = "Damage (0-1)";
				tooltip = "Fraction of damage dealt to a victim on contact (1 = instant kill).";
				typeName = "NUMBER";
				defaultValue = "1";
			};
			ROOT_COMMON_MODULE_ATTRIBUTES
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Spawns SCP-096. It cowers harmlessly until a unit views it for the set time (by any means), then sprints to that unit (and anyone else who looks) and kills them before calming down.";
		};
	};

	// ---- Player-controlled SCP-096P unit ----
	class Man;
	class CAManBase: Man {};
	class C_man_1: CAManBase {};
	class ROOT_SCP096P: C_man_1 {
		scope = 2;
		scopeCurator = 2;
		displayName = "SCP-096P (The Shy Guy - Playable)";
		author = "Root";
		faction = "ROOT_ANOMALIES";
		editorSubcategory = "EdSubcat_Personnel";
	};
};
