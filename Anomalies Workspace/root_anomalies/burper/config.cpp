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
		requiredVersion = 2.18;
	};
};

class CfgFunctions {
	class Root {
		class RootBurperCategory {
			file = "functions";
			class Burper {file = "root_anomalies\burper\functions\init_burper.sqf";};
			class BurperViz {file = "root_anomalies\burper\functions\burper_ai_avoid_vizible.sqf";};
			class BurperAI {file = "root_anomalies\burper\functions\burper_ai_avoid.sqf";};
			class BurperBlast {file = "root_anomalies\burper\functions\burper_blast.sqf";};
			class BurperTrap {file = "root_anomalies\burper\functions\burper_damage_trap.sqf";};
			class BurperDisable {file = "root_anomalies\burper\functions\burper_disable.sqf";};
			class BurperMain {file = "root_anomalies\burper\functions\burper_main.sqf";};
			class BurperRemove {file = "root_anomalies\burper\functions\burper_remove.sqf";};
			class BurperSfx {file = "root_anomalies\burper\functions\burper_sfx.sqf";};
			class BurperSplash {file = "root_anomalies\burper\functions\burper_splash_damage.sqf";};
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
