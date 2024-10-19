class CfgPatches {
	class Root_Screamer_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {
			"A3_Modules_F_Curator",
			"cba_main",
			"zen_custom_modules",
			"Root_Anomalies"
		};
		units[] = {"Screamer_Module"};
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
		class RootScreamerCategory {
			class Screamer {file = "\z\root_anomalies\addons\screamer\functions\init_screamer.sqf";};
		};
	};
};

class CfgVehicles {
	class zen_modules_moduleBase;
	class Screamer_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Screamer";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Screamer";
		displayName = "Screamer Anomaly";
	};
};