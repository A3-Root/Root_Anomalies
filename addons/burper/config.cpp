class CfgPatches {
	class Root_Burper_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {"A3_Modules_F_Curator","cba_main","Root_Anomalies"};
		requiredVersion = 0.1;
		units[] = {"Burper_Module"};
		weapons[] = {};
	};
};

class CfgFunctions {
	class Root {
		class RootBurperCategory
		{
			file = "functions";
			class Burper {file = "\Root_Anomalies\Root_Burper\AL_burper\init_burper.sqf";};
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
	class Burper_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Burper";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Burper";
		displayName = "Burper Anomaly";
	};
};
