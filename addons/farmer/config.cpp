class CfgPatches {
	class Root_Farmer_Anomaly {
		addonRootClass = "Root_Anomalies";
		requiredAddons[] = {"A3_Modules_F_Curator","cba_main","Root_Anomalies"};
		requiredVersion = 0.1;
		units[] = {"Farmer_Module"};
		weapons[] = {};
	};
};

class CfgFunctions {
	class Root {
		class RootFarmerCategory
		{
			class Farmer {file = "\Root_Anomalies\Root_Farmer\AL_farmer\init_farmer.sqf";};
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
	class Farmer_Module: zen_modules_moduleBase {
		author = "Root";
		_generalMacro = "Farmer_Module";
		category = "ROOT_ANOMALIES";
		function = "Root_fnc_Farmer";
		displayName = "Farmer Anomaly";
	};
};
