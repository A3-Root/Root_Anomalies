class CfgPatches {
	class Root_Twins_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {
			"A3_Modules_F_Curator",
			"cba_main",
			"zen_custom_modules",
			"Root_Anomalies"
		};
		units[] = {"Twins_Module"};
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
		class RootTwinsCategory {
			class Twins {file = "\z\root_anomalies\addons\twins\functions\init_twins.sqf";};
		};
	};
};

class CfgVehicles {
	class zen_modules_moduleBase;
	class Twins_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Twins";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Twins";
		displayName = "Twins Anomaly";
	};
};