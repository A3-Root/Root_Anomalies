#include "script_component.hpp"

class CfgPatches {
	class ROOT_Anomalies_Screamer {
		name = "Root's Anomalies - Screamer";
		units[] = {"ROOT_Screamer_ModuleZeus", "ROOT_Screamer_Module3DEN"};
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
