#include "script_component.hpp"

class CfgPatches {
	class ROOT_Anomalies {
		name = "Root's Anomalies";
		units[] = {
			"ROOT_Terminate_ModuleZeus",
			"ROOT_Terminate_Module3DEN",
			"ROOT_Configure_ModuleZeus",
			"ROOT_Configure_Module3DEN"
		};
		weapons[] = {};
		requiredAddons[] = {
			"A3_Modules_F_Curator",
			"3DEN",
			"cba_main",
			"zen_custom_modules"
		};
		author = "Root";
		authors[] = {
			"Root",
			"Aliascartoons"
		};
		url = "https://github.com/A3-Root/Root_Anomalies";
		requiredVersion = REQUIRED_VERSION;
	};
};

class Extended_PreInit_EventHandlers {
	class ROOT_Anomalies {
		init = QUOTE(call COMPILE_FILE(XEH_preInit));
	};
};

class Extended_PostInit_EventHandlers {
	class ROOT_Anomalies {
		init = QUOTE(call COMPILE_FILE(XEH_postInit));
	};
};

#include "CfgFactionClasses.hpp"
#include "CfgSounds.hpp"
#include "CfgAmmo.hpp"
#include "CfgMagazines.hpp"
#include "CfgVehicles.hpp"
