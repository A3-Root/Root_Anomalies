class CfgPatches {
	class Root_Strigoi_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {
			"A3_Modules_F_Curator",
			"cba_main",
			"zen_custom_modules",
			"Root_Anomalies"
		};
		units[] = {"Strigoi_Module"};
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
		class RootStrigoiCategory {
			class Strigoi {file = "\z\root_anomalies\addons\strigoi\functions\init_strigoi.sqf";};
		};
	};
};

class CfgVehicles {
	class zen_modules_moduleBase;
	class Strigoi_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Strigoi_Module";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Strigoi";
		displayName = "Strigoi Anomaly";
	};
};
