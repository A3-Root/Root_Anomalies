#include "\z\root_anomalies\addons\main\module_attributes.hpp"

class CfgVehicles {
	// ---- Zeus (ZEN) module ----
	class zen_modules_moduleBase;
	class ROOT_Twins_ModuleZeus: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "ROOT_Twins_ModuleZeus";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_twins_fnc_TwinsZeus";
		displayName = "Twins Anomaly";
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

	class ROOT_Twins_Module3DEN: Module_F {
		scope = 2;
		displayName = "Twins Anomaly";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_twins_fnc_Twins3DEN";
		functionPriority = 1;
		isGlobal = 2;
		isTriggerActivated = 0;
		isDisposable = 1;
		is3DEN = 0;
		icon = "\A3\Modules_F_Curator\Data\portraitEffectsZeus_ca.paa";
		class AttributeValues {};
		class Attributes: AttributesBase {
			class ROOT_TWINS_OBJECT: Edit {
				property = "ROOT_TWINS_OBJECT";
				displayName = "Twins Object";
				tooltip = "Classname of the object used as the Twins.";
				typeName = "STRING";
				defaultValue = """Land_HighVoltageTower_large_F""";
			};
			class ROOT_TWINS_HEART: Edit {
				property = "ROOT_TWINS_HEART";
				displayName = "Twins Heart";
				tooltip = "Classname of the object used as the 'Heart' that must be destroyed to kill the Twins.";
				typeName = "STRING";
				defaultValue = """B_UAV_06_F""";
			};
			class ROOT_TWINS_TRACKDIST: Edit {
				property = "ROOT_TWINS_TRACKDIST";
				displayName = "Tracking Distance (m)";
				tooltip = "Radius in meters within which the Twins tracks and chases entities.";
				typeName = "NUMBER";
				defaultValue = "100";
			};
			class ROOT_TWINS_DMGRANGE: Edit {
				property = "ROOT_TWINS_DMGRANGE";
				displayName = "Damage Range (m)";
				tooltip = "Radius in meters within which the Twins damages and disorients entities.";
				typeName = "NUMBER";
				defaultValue = "75";
			};
			class ROOT_TWINS_SPARKS: Checkbox {
				property = "ROOT_TWINS_SPARKS";
				displayName = "Electric Sparks";
				tooltip = "If checked, the Twins emits random electric sparks.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class ROOT_TWINS_AI: Checkbox {
				property = "ROOT_TWINS_AI";
				displayName = "Affect AI";
				tooltip = "If checked, AI entities are also affected.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class ROOT_TWINS_EMP: Checkbox {
				property = "ROOT_TWINS_EMP";
				displayName = "EMP on Death";
				tooltip = "If checked, the Twins emits an EMP when killed.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class ROOT_TWINS_SEIZURESAFE: Checkbox {
				property = "ROOT_TWINS_SEIZURESAFE";
				displayName = "Disable Sensitive Lights";
				tooltip = "If checked, the Twins' flashing/seizure visuals are disabled.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			ROOT_CAPTURE_MODULE_ATTRIBUTES
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Spawns a Twins (electric) anomaly at the module position. Configure via the attributes.";
		};
	};
};
