#include "script_component.hpp"

class CfgPatches {
	class ROOT_Anomalies_Flamer {
		name = "Root's Anomalies - Flamer";
		units[] = {"ROOT_Flamer_ModuleZeus", "ROOT_Flamer_Module3DEN"};
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

#include "CfgFunctions.hpp"
#include "CfgVehicles.hpp"
