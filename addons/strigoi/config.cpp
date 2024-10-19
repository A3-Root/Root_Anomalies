class CfgPatches {
	class Root_Strigoi_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {"A3_Modules_F_Curator","cba_main","Root_Anomalies"};
		requiredVersion = 0.1;
		units[] = {"Strigoi_Module"};
		weapons[] = {};
	};
};

class CfgFunctions {
	class Root {
		class RootStrigoiCategory {
			class Strigoi {file = "\Root_Anomalies\Root_Strigoi\AL_strigoi\init_strigoi.sqf";};
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
	class Strigoi_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Strigoi_Module";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Strigoi";
		displayName = "Strigoi Anomaly";
	};
};





