class CfgPatches {
	class Root_Steamer_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {"A3_Modules_F_Curator","cba_main","Root_Anomalies"};
		requiredVersion = 0.1;
		units[] = {"Steamer_Module"};
		weapons[] = {};
	};
};

class CfgFunctions {
	class Root {
		class RootSteamerCategory {
			class Steamer {file = "\Root_Anomalies\Root_Steamer\AL_steamer\init_steamer.sqf";};
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
	class Steamer_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Steamer_Module";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Steamer";
		displayName = "Steamer Anomaly";
	};
};


