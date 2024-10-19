class CfgPatches {
	class Root_Twins_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {"A3_Modules_F_Curator","cba_main","Root_Anomalies"};
		requiredVersion = 0.1;
		units[] = {"Twins_Module"};
		weapons[] = {};
	};
};

class CfgFunctions {
	class Root {
		class RootTwinsCategory {
			class Twins {file = "\Root_Anomalies\Root_Twins\AL_twins\init_twins.sqf";};
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