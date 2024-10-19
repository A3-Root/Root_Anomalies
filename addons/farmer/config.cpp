class CfgPatches {
	class Root_Farmer_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {
			"A3_Modules_F_Curator",
			"cba_main",
			"zen_custom_modules",
			"Root_Anomalies"
		};
		units[] = {"Farmer_Module"};
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
		class RootFarmerCategory
		{
			class Farmer {file = "\z\root_anomalies\addons\farmer\functions\init_farmer.sqf";};
		};
	};
};

class CfgVehicles {
	class zen_modules_moduleBase;
	class Farmer_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Farmer_Module";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Farmer";
		displayName = "Farmer Anomaly";
	};
};
