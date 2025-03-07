class CfgPatches {
	class Root_Twins_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {
			"A3_Modules_F_Curator",
			"cba_main",
			"zen_custom_modules",
			"Root_Anomalies"
		};
		units[] = {"Twins_Module"};
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
		class RootTwinsCategory {
			class Twins {file = "root_anomalies\twins\functions\init_twins.sqf";};
			class TwinsDamage {file = "root_anomalies\twins\functions\twins_damage_AI.sqf";};
			class TwinsEmp {file = "root_anomalies\twins\functions\twins_emp_starter.sqf";};
			class TwinsInima {file = "root_anomalies\twins\functions\twins_inima.sqf";};
			class TwinsMain {file = "root_anomalies\twins\functions\twins_main.sqf";};
			class TwinsEffect {file = "root_anomalies\twins\functions\twins_spark_effect.sqf";};
			class TwinsViz {file = "root_anomalies\twins\functions\twins_spark_viz.sqf";};
		};
	};
};

class CfgVehicles {
	class zen_modules_moduleBase;
	class Twins_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Twins";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Twins";
		displayName = "Twins Anomaly";
	};
};