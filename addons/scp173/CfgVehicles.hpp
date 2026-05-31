class CfgVehicles {
	// ---- Zeus (ZEN) module ----
	class zen_modules_moduleBase;
	class ROOT_SCP173_ModuleZeus: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "ROOT_SCP173_ModuleZeus";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_SCP173Zeus";
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
		function = "Root_fnc_SCP1733DEN";
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
				tooltip = "Radius in meters within which SCP-173 hunts.";
				typeName = "NUMBER";
				defaultValue = "150";
			};
			class ROOT_SCP173_BLINK: Edit {
				property = "ROOT_SCP173_BLINK";
				displayName = "Blink Distance (m)";
				tooltip = "Maximum distance SCP-173 closes each time it is unobserved.";
				typeName = "NUMBER";
				defaultValue = "8";
			};
			class ROOT_SCP173_KILLDIST: Edit {
				property = "ROOT_SCP173_KILLDIST";
				displayName = "Kill Distance (m)";
				tooltip = "Distance within which SCP-173 snaps a target's neck.";
				typeName = "NUMBER";
				defaultValue = "2.5";
			};
			class ROOT_SCP173_AI: Checkbox {
				property = "ROOT_SCP173_AI";
				displayName = "Affect AI";
				tooltip = "If checked, AI also count as observers and as prey.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Spawns SCP-173 at the module position. It cannot move while observed; the moment no one is looking it blinks toward the nearest victim and snaps their neck.";
		};
	};
};
