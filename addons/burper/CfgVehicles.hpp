class CfgVehicles {
	// ---- Zeus (ZEN) module ----
	class zen_modules_moduleBase;
	class ROOT_Burper_ModuleZeus: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "ROOT_Burper_ModuleZeus";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_BurperZeus";
		displayName = "Burper Anomaly";
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

	class ROOT_Burper_Module3DEN: Module_F {
		scope = 2;
		displayName = "Burper Anomaly";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Burper3DEN";
		functionPriority = 1;
		isGlobal = 2;
		isTriggerActivated = 0;
		isDisposable = 1;
		is3DEN = 0;
		icon = "\A3\Modules_F_Curator\Data\portraitEffectsZeus_ca.paa";
		class AttributeValues {};
		class Attributes: AttributesBase {
			class ROOT_BURPER_RADIUS: Edit {
				property = "ROOT_BURPER_RADIUS";
				displayName = "Territory Radius (m)";
				tooltip = "Radius in meters of the Burper's effective destruction range.";
				typeName = "NUMBER";
				defaultValue = "10";
			};
			class ROOT_BURPER_VEHICLE: Checkbox {
				property = "ROOT_BURPER_VEHICLE";
				displayName = "Affect Vehicles";
				tooltip = "If checked, land vehicles are also affected by the Burper.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class ROOT_BURPER_ROAMING: Checkbox {
				property = "ROOT_BURPER_ROAMING";
				displayName = "Roaming Burper";
				tooltip = "If checked, the Burper teleports to random nearby positions over time.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ROOT_BURPER_DETECTABLE: Checkbox {
				property = "ROOT_BURPER_DETECTABLE";
				displayName = "Require Detection Device";
				tooltip = "If checked, the Burper is invisible unless a unit carries the detection device.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class ROOT_BURPER_PROTECTABLE: Checkbox {
				property = "ROOT_BURPER_PROTECTABLE";
				displayName = "Enable Protection Device";
				tooltip = "If checked, units carrying the protection device are not harmed.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class ROOT_BURPER_KILLABLE: Checkbox {
				property = "ROOT_BURPER_KILLABLE";
				displayName = "Enable Killswitch";
				tooltip = "If checked, the Burper is destroyed when the killswitch object is within range.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class ROOT_BURPER_AIPANIC: Checkbox {
				property = "ROOT_BURPER_AIPANIC";
				displayName = "AI Panic";
				tooltip = "If checked, AI flee to a safe distance when the Burper is visible.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class ROOT_BURPER_KILLRANGE: Edit {
				property = "ROOT_BURPER_KILLRANGE";
				displayName = "Killswitch Range (m)";
				tooltip = "Range in meters at which the killswitch device triggers. Keep at least 5m above Territory Radius.";
				typeName = "NUMBER";
				defaultValue = "20";
			};
			class ROOT_BURPER_DETECTOR: Edit {
				property = "ROOT_BURPER_DETECTOR";
				displayName = "Detection Device";
				tooltip = "Classname of the detection device.";
				typeName = "STRING";
				defaultValue = """MineDetector""";
			};
			class ROOT_BURPER_PROTECTOR: Edit {
				property = "ROOT_BURPER_PROTECTOR";
				displayName = "Protection Device";
				tooltip = "Classname of the protection device.";
				typeName = "STRING";
				defaultValue = """B_Kitbag_mcamo""";
			};
			class ROOT_BURPER_KILLDEVICE: Edit {
				property = "ROOT_BURPER_KILLDEVICE";
				displayName = "Killswitch Device";
				tooltip = "Classname of the killswitch device (default: CSAT Typhoon Device).";
				typeName = "STRING";
				defaultValue = """O_Truck_03_device_F""";
			};
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Spawns a Burper anomaly at the module position. Place in 3DEN; configure via the attributes.";
		};
	};
};
