class CfgAmmo {
	class SmokeShell;
	// Sedative smoke cloud. Functionally a green smoke; the anomaly capture system
	// detects this ammo (or any per-instance custom classname) inside an anomaly's
	// radius to open a sedation/capture window.
	class ROOT_Ammo_SmokeShell_Sedative: SmokeShell {
		smokeColor[] = {0.4, 0.9, 0.4, 1};
	};
};
