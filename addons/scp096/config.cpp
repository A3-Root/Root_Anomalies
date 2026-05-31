#include "script_component.hpp"

class CfgPatches {
	class ROOT_Anomalies_SCP096 {
		name = "Root's Anomalies - SCP-096";
		units[] = {"ROOT_SCP096_ModuleZeus", "ROOT_SCP096_Module3DEN"};
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

#include "CfgFunctions.hpp"
#include "CfgVehicles.hpp"
