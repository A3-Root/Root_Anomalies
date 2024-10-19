class CfgPatches {
	class Root_Smuggler_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {
			"A3_Modules_F_Curator",
			"cba_main",
			"zen_custom_modules",
			"Root_Anomalies"
		};
		units[] = {"Smuggler_Module"};
		weapons[] = {};
		author = "Root";
		authors[] = {
			"Root",
			"Aliascartoons"
		};
		url = "https://github.com/A3-Root/Root_Anomalies";
	};
};

class CfgFunctions {
	class Root {
		class RootSmugglerCategory {
			class Smuggler {file = "\Root_Anomalies\Root_Smuggler\AL_smuggler\init_smuggler.sqf";};
		};
	};
};




class CfgFactionClasses {
	class NO_CATEGORY;
	class ROOT_ANOMALIES : NO_CATEGORY {
		displayName = "Root's Anomalies";
	};
};

class CfgVehicles {
	class zen_modules_moduleBase;
	class Smuggler_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Smuggler_Module";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Smuggler";
		displayName = "Smuggler Anomaly";
	};
};