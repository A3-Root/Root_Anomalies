class CfgPatches {
	class Root_Worm_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {
			"A3_Modules_F_Curator",
			"cba_main",
			"zen_custom_modules",
			"Root_Anomalies"
		};
		units[] = {"Worm_Module"};
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
		class RootWormCategory {
			class Worm {file = "\z\root_anomalies\addons\worm\functions\init_worm.sqf";};
		};
	};
};

class Extended_PostInit_EventHandlers {
	class RootPostInitWorm {
		init = "call compile preprocessFileLineNumbers '\z\root_anomalies\addons\worm\functions\postinit_worm.sqf'";
		disableModuload = 1;
	};
};

class CfgVehicles {
	class zen_modules_moduleBase;
	class Worm_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Worm_Module";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Worm";
		displayName = "Worm Anomaly";
	};
};
