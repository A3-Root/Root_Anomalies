class CfgPatches {
	class Root_Flamer_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {
			"A3_Modules_F_Curator",
			"cba_main",
			"zen_custom_modules",
			"Root_Anomalies"
		};
		units[] = {"Flamer_Module"};
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
		class RootFlamerCategory {
			class Flamer {file = "\z\root_anomalies\addons\flamer\functions\init_flamer.sqf";};
			class FlamerAtk {file = "\z\root_anomalies\addons\flamer\functions\flamer_atk_SFX.sqf";};
			class FlamerEndSfx {file = "\z\root_anomalies\addons\flamer\functions\flamer_end_SFX.sqf";};
			class FlamerEnd {file = "\z\root_anomalies\addons\flamer\functions\flamer_end.sqf";};
			class FlamerJump {file = "\z\root_anomalies\addons\flamer\functions\flamer_jump_SFX.sqf";};
			class FlamerMain {file = "\z\root_anomalies\addons\flamer\functions\flamer_main.sqf";};
			class FlamerPlasma {file = "\z\root_anomalies\addons\flamer\functions\flamer_plasma_SFX.sqf";};
			class FlamerSfx {file = "\z\root_anomalies\addons\flamer\functions\flamer_sfx.sqf";};
			class FlamerSplash {file = "\z\root_anomalies\addons\flamer\functions\flamer_splash_hit.sqf";};
		};
	};
};

class CfgVehicles {
	class zen_modules_moduleBase;
	class Flamer_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Flamer_Module";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Flamer";
		displayName = "Flamer Anomaly";
	};
};
