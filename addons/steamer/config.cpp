#include "script_component.hpp"

class CfgPatches {
	class ROOT_Anomalies_Steamer {
		name = "Root's Anomalies - Steamer";
		units[] = {"ROOT_Steamer_ModuleZeus", "ROOT_Steamer_Module3DEN"};
		weapons[] = {};
		requiredAddons[] = {
			"ROOT_Anomalies",
			"A3_Modules_F_Curator",
			"3DEN",
			"cba_main",
			"zen_custom_modules"
		};
		author = "Root";
		authors[] = {"Root", "Aliascartoons"};
		url = "https://github.com/A3-Root/Root_Anomalies";
		requiredVersion = REQUIRED_VERSION;
	};
};

class Extended_PreInit_EventHandlers {
	class ROOT_Anomalies_Steamer {
		init = QUOTE(call COMPILE_FILE(XEH_preInit));
	};
};

class Extended_PostInit_EventHandlers {
	class ROOT_Anomalies_Steamer {
		init = QUOTE(call COMPILE_FILE(XEH_postInit));
	};
};
#include "CfgVehicles.hpp"
