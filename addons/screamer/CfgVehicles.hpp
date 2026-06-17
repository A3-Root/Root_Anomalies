#include "\z\root_anomalies\addons\main\module_attributes.hpp"

class CfgVehicles {
	// ---- Zeus (ZEN) module ----
	class zen_modules_moduleBase;
	class ROOT_Screamer_ModuleZeus: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "ROOT_Screamer_ModuleZeus";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_screamer_fnc_ScreamerZeus";
		displayName = "Screamer Anomaly";
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

	class ROOT_Screamer_Module3DEN: Module_F {
		scope = 2;
		displayName = "Screamer Anomaly";
		category = "ROOT_ANOMALIES";
		function = "root_anomalies_screamer_fnc_Screamer3DEN";
		functionPriority = 1;
		isGlobal = 2;
		isTriggerActivated = 0;
		isDisposable = 1;
		is3DEN = 0;
		icon = "\A3\Modules_F_Curator\Data\portraitEffectsZeus_ca.paa";
		class AttributeValues {};
		class Attributes: AttributesBase {
			class ROOT_SCREAMER_MODEL: Edit {
				property = "ROOT_SCREAMER_MODEL";
				displayName = "Screamer Model";
				tooltip = "Classname of the object used as the anomaly (statue, object, or man).";
				typeName = "STRING";
				defaultValue = """Land_AncientStatue_01_F""";
			};
			class ROOT_SCREAMER_HEALTH: Edit {
				property = "ROOT_SCREAMER_HEALTH";
				displayName = "Health";
				tooltip = "Damage the Screamer absorbs before dying.";
				typeName = "NUMBER";
				defaultValue = "400";
			};
			class ROOT_SCREAMER_RADIUS: Edit {
				property = "ROOT_SCREAMER_RADIUS";
				displayName = "Territory Radius (m)";
				tooltip = "Radius in meters of the Screamer's territory.";
				typeName = "NUMBER";
				defaultValue = "100";
			};
			class ROOT_SCREAMER_ATKRADIUS: Edit {
				property = "ROOT_SCREAMER_ATKRADIUS";
				displayName = "Attack Distance (m)";
				tooltip = "Distance in meters of the Screamer's scream. Auto-clamped to half the territory.";
				typeName = "NUMBER";
				defaultValue = "50";
			};
			class ROOT_SCREAMER_HOSTILES: Edit {
				property = "ROOT_SCREAMER_HOSTILES";
				displayName = "Hostile Sides";
				tooltip = "Comma-separated sides the Screamer attacks: EAST, WEST, GUER, CIV. Empty = everyone.";
				typeName = "STRING";
				defaultValue = """EAST,WEST,GUER,CIV""";
			};
			class ROOT_SCREAMER_SPAWNSIDE: Edit {
				property = "ROOT_SCREAMER_SPAWNSIDE";
				displayName = "Spawn Side (AI Engage)";
				tooltip = "Side the Screamer spawns as when AI Engage is on: EAST, WEST, GUER, CIV.";
				typeName = "STRING";
				defaultValue = """EAST""";
			};
			class ROOT_SCREAMER_VEHICLE: Checkbox {
				property = "ROOT_SCREAMER_VEHICLE";
				displayName = "Affect Vehicles";
				tooltip = "If checked, vehicles in the scream path are affected.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class ROOT_SCREAMER_AIENGAGE: Checkbox {
				property = "ROOT_SCREAMER_AIENGAGE";
				displayName = "AI Engages [Experimental]";
				tooltip = "If checked, AI will engage the Screamer (a visible VR soldier is added for static models).";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ROOT_SCREAMER_AIPANIC: Checkbox {
				property = "ROOT_SCREAMER_AIPANIC";
				displayName = "AI Panic";
				tooltip = "If checked, AI flee from the Screamer during attacks.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ROOT_SCREAMER_DMGCLOSE: Edit {
				property = "ROOT_SCREAMER_DMGCLOSE";
				displayName = "Damage Close (0-1)";
				tooltip = "Fraction of damage at close range.";
				typeName = "NUMBER";
				defaultValue = "0.8";
			};
			class ROOT_SCREAMER_DMGMED: Edit {
				property = "ROOT_SCREAMER_DMGMED";
				displayName = "Damage Medium (0-1)";
				tooltip = "Fraction of damage at mid range.";
				typeName = "NUMBER";
				defaultValue = "0.4";
			};
			class ROOT_SCREAMER_DMGFAR: Edit {
				property = "ROOT_SCREAMER_DMGFAR";
				displayName = "Damage Far (0-1)";
				tooltip = "Fraction of damage at far range.";
				typeName = "NUMBER";
				defaultValue = "0.2";
			};
			ROOT_GEAR_MODULE_ATTRIBUTES
			ROOT_CAPTURE_MODULE_ATTRIBUTES
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Spawns a Screamer anomaly at the module position. Configure via the attributes.";
		};
	};
};
