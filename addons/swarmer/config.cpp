class CfgPatches {
	class Root_Swarmer_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {
			"A3_Modules_F_Curator",
			"cba_main",
			"zen_custom_modules",
			"Root_Anomalies"
		};
		units[] = {"Swarmer_Module"};
		weapons[] = {};
		author = "Root";
		authors[] = {
			"Root",
			"Aliascartoons"
		};
		url = "https://github.com/A3-Root/Root_Anomalies";
		requiredVersion = 0.01;
	};
};

class CfgFunctions {
	class Root {
		class RootSwarmerCategory {
			class Swarmer {file = "\z\root_anomalies\addons\swarmer\functions\init_swarmer.sqf";};
		};
	};
};

class Extended_PostInit_EventHandlers {
	class RootPostInitSwarmer {
		init = "call compile preprocessFileLineNumbers '\z\root_anomalies\addons\swarmer\functions\postinit_swarmer.sqf'";
		disableModuload = 1;
	};
};

class CfgVehicles {
	class zen_modules_moduleBase;
	class Swarmer_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Swarmer_Module";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Swarmer";
		displayName = "Swarmer Anomaly";
	};
};
