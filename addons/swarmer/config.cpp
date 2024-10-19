class CfgPatches {
	class Root_Swarmer_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {"A3_Modules_F_Curator","cba_main","Root_Anomalies"};
		requiredVersion = 0.1;
		units[] = {"Swarmer_Module"};
		weapons[] = {};
	};
};

class CfgFunctions {
	class Root {
		class RootSwarmerCategory {
			class Swarmer {file = "\Root_Anomalies\Root_Swarmer\AL_swarmer\init_swarmer.sqf";};
		};
	};
};


class Extended_PostInit_EventHandlers {
	class RootPostInitSwarmer {
		init = "call compile preprocessFileLineNumbers '\Root_Anomalies\Root_Swarmer\AL_swarmer\postinit_swarmer.sqf'";
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
	class Swarmer_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Swarmer_Module";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Swarmer";
		displayName = "Swarmer Anomaly";
	};
};
