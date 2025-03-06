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
		requiredVersion = 2.18;
	};
};

class CfgFunctions {
	class Root {
		class RootWormCategory {
			class Worm {file = "\z\root_anomalies\addons\worm\functions\init_worm.sqf";};
			class WormAttack {file = "\z\root_anomalies\addons\worm\functions\worm_attack.sqf";};
			class WormBump {file = "\z\root_anomalies\addons\worm\functions\worm_bump.sqf";};
			class WormEffect {file = "\z\root_anomalies\addons\worm\functions\worm_effect.sqf";};
			class WormKill {file = "\z\root_anomalies\addons\worm\functions\worm_kill_confirm.sqf";};
			class WormMain {file = "\z\root_anomalies\addons\worm\functions\worm_main.sqf";};
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
