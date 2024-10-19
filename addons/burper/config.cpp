#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = COMPONENT_NAME;
		author = "Root";
		authors[] = {
			"Root",
			"Aliascartoon"
		};
		units[] = {
			"root_AnomalyBurper"
		};
		weapons[] = {};
		requiredAddons[] = {
			"A3_Modules_F_Curator", 
			"cba_main", 
			"zen_custom_modules",
			"root_common",
			"root_main"
		};
		requiredVersion = REQUIRED_VERSION;
		version = 4.0.0;
		versionStr = "4.0.0";
		url = "https://github.com/A3-Root/Root_Anomalies";
	};
};

#include "CfgEventHandlers.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgVehicles.hpp"
