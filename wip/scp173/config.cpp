#include "script_component.hpp"

class CfgPatches {
	class ROOT_Anomalies_SCP173 {
		name = "Root's Anomalies - SCP-173";
		units[] = {"ROOT_SCP173_ModuleZeus", "ROOT_SCP173_Module3DEN", "ROOT_SCP173P"};
		weapons[] = {};
		requiredAddons[] = {
			"ROOT_Anomalies",
			"A3_Modules_F_Curator",
			"3DEN",
			"cba_main",
			"zen_custom_modules"
		};
		author = "Root";
		authors[] = {"Root"};
		url = "https://github.com/A3-Root/Root_Anomalies";
		requiredVersion = REQUIRED_VERSION;
	};
};

class Extended_PreInit_EventHandlers {
	class ROOT_Anomalies_SCP173 {
		init = QUOTE(call COMPILE_FILE(XEH_preInit));
	};
};

class Extended_PostInit_EventHandlers {
	class ROOT_Anomalies_SCP173 {
		init = QUOTE(call COMPILE_FILE(XEH_postInit));
	};
};

class Extended_Init_EventHandlers {
	class ROOT_SCP173P {
		init = QUOTE(call FUNC(playerInit));
	};
};

#include "CfgVehicles.hpp"
