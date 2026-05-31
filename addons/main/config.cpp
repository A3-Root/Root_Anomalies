#include "script_mod.hpp"

class CfgPatches {
	class ROOT_Anomalies {
		name = "Root's Anomalies";
		units[] = {};
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

#include "CfgFactionClasses.hpp"
#include "CfgFunctions.hpp"
#include "CfgSounds.hpp"
