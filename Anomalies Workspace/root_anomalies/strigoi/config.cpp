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
		requiredVersion = 2.18;
	};
};

class CfgFunctions {
	class Root {
		class RootStrigoiCategory {
			class Strigoi {file = "root_anomalies\strigoi\functions\init_strigoi.sqf";};
			class StrigoiViz {file = "root_anomalies\strigoi\functions\strigoi_atk_viz.sqf";};
			class StrigoiFatigue {file = "root_anomalies\strigoi\functions\strigoi_fatigue_p.sqf";};
			class StrigoiMain {file = "root_anomalies\strigoi\functions\strigoi_main.sqf";};
			class StrigoiSfx {file = "root_anomalies\strigoi\functions\strigoi_sfx.sqf";};
			class StrigoiSplash {file = "root_anomalies\strigoi\functions\strigoi_splash_hit.sqf";};
			class StrigoiTgt {file = "root_anomalies\strigoi\functions\strigoi_tgt_attk.sqf";};
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
