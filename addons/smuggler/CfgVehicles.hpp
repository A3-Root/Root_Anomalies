class CfgVehicles {
	// ---- Zeus (ZEN) module ----
	class zen_modules_moduleBase;
	class ROOT_Smuggler_ModuleZeus: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "ROOT_Smuggler_ModuleZeus";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_smuggler_fnc_SmugglerZeus";
		displayName = "Smuggler Anomaly";
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

	class ROOT_Smuggler_Module3DEN: Module_F {
		scope = 2;
		displayName = "Smuggler Anomaly";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_smuggler_fnc_Smuggler3DEN";
		functionPriority = 1;
		isGlobal = 2;
		isTriggerActivated = 0;
		isDisposable = 1;
		is3DEN = 0;
		icon = "\A3\Modules_F_Curator\Data\portraitEffectsZeus_ca.paa";
		class AttributeValues {};
		class Attributes: AttributesBase {
			class ROOT_SMUGGLER_ROAMING: Checkbox {
				property = "ROOT_SMUGGLER_ROAMING";
				displayName = "Roaming Smuggler";
				tooltip = "If checked, the Smuggler teleports to random nearby positions over time.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ROOT_SMUGGLER_DETECTABLE: Checkbox {
				property = "ROOT_SMUGGLER_DETECTABLE";
				displayName = "Require Detection Device";
				tooltip = "If checked, the Smuggler is invisible unless a unit carries the detection device.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class ROOT_SMUGGLER_PROTECTABLE: Checkbox {
				property = "ROOT_SMUGGLER_PROTECTABLE";
				displayName = "Enable Teleport Protection";
				tooltip = "If checked, units carrying the protection device are not teleported.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class ROOT_SMUGGLER_DISABLESPAWN: Checkbox {
				property = "ROOT_SMUGGLER_DISABLESPAWN";
				displayName = "Disable Object Spawning";
				tooltip = "If checked, the Smuggler will not spawn random objects/entities.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ROOT_SMUGGLER_DETECTOR: Edit {
				property = "ROOT_SMUGGLER_DETECTOR";
				displayName = "Detection Device";
				tooltip = "Classname of the detection device.";
				typeName = "STRING";
				defaultValue = """MineDetector""";
			};
			class ROOT_SMUGGLER_PROTECTOR: Edit {
				property = "ROOT_SMUGGLER_PROTECTOR";
				displayName = "Protection Device";
				tooltip = "Classname of the protection device.";
				typeName = "STRING";
				defaultValue = """B_Kitbag_mcamo""";
			};
			class ROOT_SMUGGLER_SPAWNLIST: Edit {
				property = "ROOT_SMUGGLER_SPAWNLIST";
				displayName = "Spawn Objects";
				tooltip = "Comma-separated classnames the Smuggler may spawn at random.";
				typeName = "STRING";
				defaultValue = """Land_OfficeCabinet_01_F,Land_ArmChair_01_F,B_G_Soldier_AR_F,C_man_1,O_Soldier_GL_F""";
			};
			class ROOT_SMUGGLER_SPAWNDELAY: Edit {
				property = "ROOT_SMUGGLER_SPAWNDELAY";
				displayName = "Spawn Delay (s)";
				tooltip = "Additional delay in seconds between spawns (minimum 10s base is always added).";
				typeName = "NUMBER";
				defaultValue = "10";
			};
			class ROOT_SMUGGLER_DAMAGE: Edit {
				property = "ROOT_SMUGGLER_DAMAGE";
				displayName = "Teleport Damage (0-1)";
				tooltip = "Fraction of damage dealt per teleport. 0 = no damage.";
				typeName = "NUMBER";
				defaultValue = "0.1";
			};
			class ROOT_SMUGGLER_SEIZURESAFE: Checkbox {
				property = "ROOT_SMUGGLER_SEIZURESAFE";
				displayName = "Disable Sensitive Lights";
				tooltip = "If checked, the bright screen effects during teleport are disabled.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Spawns a Smuggler teleporter anomaly at the module position. Configure via the attributes.";
		};
	};
};
