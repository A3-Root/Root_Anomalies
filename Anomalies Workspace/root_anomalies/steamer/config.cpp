class CfgPatches {
	class Root_Steamer_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {
			"A3_Modules_F_Curator",
			"cba_main",
			"zen_custom_modules",
			"Root_Anomalies"
		};
		units[] = {"Steamer_Module"};
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
		class RootSteamerCategory {
			class Steamer {file = "root_anomalies\steamer\functions\init_steamer.sqf";};
			class SteamerBurst {file = "root_anomalies\steamer\functions\steamer_burst_SFX.sqf";};
			class SteamerChimney {file = "root_anomalies\steamer\functions\steamer_chimney_SFX.sqf";};
			class SteamerEnd {file = "root_anomalies\steamer\functions\steamer_end.sqf";};
			class SteamerMain {file = "root_anomalies\steamer\functions\steamer_main.sqf";};
			class SteamerRagdoll {file = "root_anomalies\steamer\functions\steamer_ragdoll.sqf";};
			class SteamerTravel {file = "root_anomalies\steamer\functions\steamer_travel_SFX.sqf";};
			class SteamerVoice {file = "root_anomalies\steamer\functions\steamer_voice.sqf";};
		};
	};
};

class CfgVehicles {
	class zen_modules_moduleBase;
	class Steamer_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Steamer_Module";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Steamer";
		displayName = "Steamer Anomaly";
	};
};


