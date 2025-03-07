class CfgPatches {
	class Root_Smuggler_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {
			"A3_Modules_F_Curator",
			"cba_main",
			"zen_custom_modules",
			"Root_Anomalies"
		};
		units[] = {"Smuggler_Module"};
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
		class RootSmugglerCategory {
			class Smuggler {file = "\z\root_anomalies\addons\smuggler\functions\init_smuggler.sqf";};
			class SmugglerAIVisible {file = "\z\root_anomalies\addons\smuggler\functions\smuggler_ai_avoid_smugg_visible.sqf";};
			class SmugglerAIAvoid {file = "\z\root_anomalies\addons\smuggler\functions\smuggler_ai_avoid_smugg.sqf";};
			class SmugglerMain {file = "\z\root_anomalies\addons\smuggler\functions\smuggler_main.sqf";};
			class SmugglerSfx {file = "\z\root_anomalies\addons\smuggler\functions\smuggler_sfx.sqf";};
			class SmugglerSpawn {file = "\z\root_anomalies\addons\smuggler\functions\smuggler_spawn.sqf";};
			class SmugglerTeleEffect {file = "\z\root_anomalies\addons\smuggler\functions\smuggler_teleport_effect.sqf";};
			class SmugglerTeleport {file = "\z\root_anomalies\addons\smuggler\functions\smuggler_teleport.sqf";};
			class SmugglerVidEffect {file = "\z\root_anomalies\addons\smuggler\functions\smuggler_video_effect.sqf";};
		};
	};
};


class CfgFactionClasses {
	class NO_CATEGORY;
	class ROOT_ANOMALIES : NO_CATEGORY {
		displayName = "Root's Anomalies";
	};
};

class CfgVehicles {
	class zen_modules_moduleBase;
	class Smuggler_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Smuggler_Module";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Smuggler";
		displayName = "Smuggler Anomaly";
	};
};

