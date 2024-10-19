class CfgPatches {
	class Root_Screamer_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {"A3_Modules_F_Curator","cba_main","Root_Anomalies"};
		requiredVersion = 0.1;
		units[] = {"Screamer_Module"};
		weapons[] = {};
	};
};

class CfgFunctions {
	class Root {
		class RootScreamerCategory {
			class Screamer {file = "\Root_Anomalies\Root_Screamer\AL_screamer\init_screamer.sqf";};
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
	class Screamer_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Screamer";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Screamer";
		displayName = "Screamer Anomaly";
	};
};