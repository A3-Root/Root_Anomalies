


class CfgPatches {
	class Root_Worm_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {"A3_Modules_F_Curator","cba_main","Root_Anomalies"};
		requiredVersion = 0.1;
		units[] = {"Worm_Module"};
		weapons[] = {};
	};
};



class CfgFunctions {
	class Root {
		class RootWormCategory {
			class Worm {file = "\Root_Anomalies\Root_Worm\AL_worm\init_worm.sqf";};
		};
	};
};

class Extended_PostInit_EventHandlers {
	class RootPostInitWorm {
		init = "call compile preprocessFileLineNumbers '\Root_Anomalies\Root_Worm\AL_worm\postinit_worm.sqf'";
		disableModuload = 1;
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
	class Worm_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Worm_Module";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Worm";
		displayName = "Worm Anomaly";
	};
};
