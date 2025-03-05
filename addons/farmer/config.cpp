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
		requiredVersion = 2.18;
	};
};

class CfgFunctions {
	class Root {
		class RootFarmerCategory
		{
			class Farmer {file = "\z\root_anomalies\addons\farmer\functions\init_farmer.sqf";};
			class FarmerMain {file = "\z\root_anomalies\addons\farmer\functions\farmer_main.sqf";};
			class FarmerShock {file = "\z\root_anomalies\addons\farmer\functions\farmer_shock_SFX.sqf";};
			class FarmerSplash {file = "\z\root_anomalies\addons\farmer\functions\farmer_splash_hit.sqf";};
			class FarmerTeleport {file = "\z\root_anomalies\addons\farmer\functions\farmer_teleport.sqf";};
			class FarmerTravel {file = "\z\root_anomalies\addons\farmer\functions\farmer_travel_SFX.sqf";};
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
