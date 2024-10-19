class CfgPatches {
	class Root_Burper_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {
			"A3_Modules_F_Curator",
			"cba_main",
			"zen_custom_modules",
			"Root_Anomalies"
		};
		units[] = {"Burper_Module"};
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
		class RootBurperCategory {
			file = "functions";
			class Burper {file = "\z\Root_Anomalies\addons\burper\functions\init_burper.sqf";};
		};
	};
};

class CfgVehicles {
	class zen_modules_moduleBase;
	class Burper_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Burper";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Burper";
		displayName = "Burper Anomaly";
	};
};
