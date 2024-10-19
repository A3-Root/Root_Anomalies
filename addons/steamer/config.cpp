class CfgPatches {
	class Root_Steamer_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {
			"A3_Modules_F_Curator",
			"cba_main",
			"zen_custom_modules",
			"Root_Anomalies"
		};
		units[] = {"Steamer_Module"};
		weapons[] = {};
		author = "Root";
		authors[] = {
			"Root",
			"Aliascartoons"
		};
		url = "https://github.com/A3-Root/Root_Anomalies";
		requiredVersion = 2.18;
	};
};

class CfgFunctions {
	class Root {
		class RootSteamerCategory {
			class Steamer {file = "\Root_Anomalies\Root_Steamer\AL_steamer\init_steamer.sqf";};
		};
	};
};

class CfgVehicles {
	class zen_modules_moduleBase;
	class Steamer_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Steamer_Module";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Steamer";
		displayName = "Steamer Anomaly";
	};
};


