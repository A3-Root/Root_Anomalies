class CfgPatches {
	class Root_Flamer_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {"A3_Modules_F_Curator","cba_main","Root_Anomalies"};
		requiredVersion = 0.1;
		units[] = {"Flamer_Module"};
		weapons[] = {};
	};
};

class CfgFunctions {
	class Root {
		class RootFlamerCategory {
			class Flamer {file = "\Root_Anomalies\Root_Flamer\AL_flamer\init_flamer.sqf";};
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
	class Flamer_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Flamer_Module";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Flamer";
		displayName = "Flamer Anomaly";
	};
};
