#include "\z\root_anomalies\addons\twins\script_component.hpp"
/*
 * Author: Root, Aliascartoons
 * Description: Local EMP detonation when the Twins dies: flash, shockwave, disables
 *              vehicles/statics, sparks lamps and strips NVGs/optics/radios from units.
 *
 * Arguments:
 * 0: Twins object <OBJECT>
 * 1: Area of effect radius <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_twins", ["_aoe", 100, [0]]];

if (!hasInterface) exitWith {};

private _bangSource = "#particlesource" createVehicleLocal getPosATL _twins;
_bangSource say3D ["earthquake_02", 3500];

private _blast = "#particlesource" createVehicleLocal getPosATL _twins;
_blast setParticleCircle [0, [0, 0, 0]];
_blast setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
_blast setParticleParams [["\A3\data_f\koule", 1, 0, 1], "", "SpaceObject", 1, 0.5, [0, 0, 0], [0, 0, 1], 3, 10, 7.9, 0, [0, 225], [[0.1, 0.1, 0.1, 0.1], [0.1, 0.1, 0.1, 0]], [1], 1, 0, "", "", _twins];
_blast setDropInterval 50;

private _ripple = "#particlesource" createVehicleLocal getPosATL _twins;
_ripple setParticleCircle [0, [0, 0, 0]];
_ripple setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_ripple setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 0.5, [0, 0, 0], [0, 0, 0], 0, 10, 7.9, 0, [5, 0, 250, 500], [[1, 1, 1, 1], [1, 1, 1, 1]], [0.05], 1, 0, "", "", _twins];
_ripple setDropInterval 0.25;

private _light = "#lightpoint" createVehicleLocal getPosATL _twins;
_light lightAttachObject [_twins, [0, 0, 3]];
_light setLightAmbient [0.1, 0.1, 1];
_light setLightColor [0.1, 0.1, 1];
_light setLightBrightness 10;
_light setLightUseFlare true;
_light setLightFlareSize 10;
_light setLightFlareMaxDistance 2000;
_light setLightDayLight true;
_light setLightAttenuation [10, 10, 50, 0, 50, 2000];

uiSleep 0.1;
if !(SENS_LIGHTS_OFF) then {
    private _hndl = ppEffectCreate ["ColorInversion", 1501];
    _hndl ppEffectEnable true;
    _hndl ppEffectAdjust [0.75, 0.75, 0.75];
    _hndl ppEffectCommit 0.5;
    uiSleep 0.5;
    _hndl ppEffectAdjust [0, 0, 0];
    _hndl ppEffectCommit 1.5;

    private _brit = 0;
    while {_brit < 100} do {
        _light setLightBrightness _brit;
        _brit = _brit + 2;
        uiSleep 0.01;
    };
};

uiSleep 0.5;
deleteVehicle _blast;
deleteVehicle _light;
deleteVehicle _ripple;

private _vehicleClasses = ["Car", "Motorcycle", "UAV", "Tank", "Air", "Ship", "Autonomous", "Armored", "StaticWeapon"];

// Disable vehicles and statics.
{
    private _veh = _x;
    {_veh setHitPointDamage [_x, 1]} forEach ["hitturret", "hitcomturret", "hitcomgun", "HitBatteries", "HitLight", "hitEngine", "HitEngine2", "HitAvionics"];
    _veh disableTIEquipment true;
    _veh disableNVGEquipment true;
    _veh setVariable ["A3TI_Disable", true];
    _veh disableAI "LIGHTS";
    _veh setPilotLight false;
    _veh setCollisionLight false;
} forEach (nearestObjects [_twins, _vehicleClasses, _aoe]);

// Spark fire on vehicles/statics.
{
    _x say3D selectRandom ["spark1", "spark11", "spark2", "spark22"];
    private _eStatic = "#particlesource" createVehicleLocal (getPosATL _x);
    _eStatic setParticleFire [0.5, 3, 60];
    _eStatic setParticleCircle [1.5, [0, 0, 0]];
    _eStatic setParticleRandom [0.2, [3.5, 3.5, 0], [0.175, 0.175, 0], 0, 0.2, [0, 0, 0, 1], 1, 0];
    _eStatic setParticleParams [["\A3\data_f\blesk1", 1, 0, 1], "", "SpaceObject", 1, 0.05, [0, 0, 0], [0, 0, 0], 0, 10, 7.9, 0, [0.003, 0.003], [[1, 1, 0.1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _x];
    _eStatic setDropInterval 0.025;
    uiSleep 0.5;
    deleteVehicle _eStatic;
} forEach (nearestObjects [_twins, _vehicleClasses, _aoe]);

// Spark on lamps and power infrastructure.
{
    private _lamp = _x;
    {_lamp setHit [_x, 0.97]} forEach ["light_1_hitpoint", "light_2_hitpoint", "light_3_hitpoint", "light_4_hitpoint"];
    private _bbr = boundingBoxReal vehicle _lamp;
    private _height = abs (((_bbr select 1) select 2) - ((_bbr select 0) select 2));
    private _sparkZ = (_height / 2) - 0.45;
    private _spark = "#particlesource" createVehicleLocal (getPosATL _lamp);
    _spark setParticleCircle [0, [0, 0, 0]];
    _spark setParticleRandom [1, [0.05, 0.05, 0.1], [5, 5, 3], 0, 0.0025, [0, 0, 0, 0], 0, 0];
    _spark setParticleParams [["\A3\data_f\proxies\muzzle_flash\muzzle_flash_silencer.p3d", 1, 0, 1], "", "SpaceObject", 1, 1, [0, 0, _sparkZ], [0, 0, 0], 0, 20, 7.9, 0, [0.5, 0.5, 0.05], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0]], [0.08], 1, 0, "", "", _x, 0, true, 0.3, [[0, 0, 0, 0]]];
    _spark setDropInterval 0.001;
    _spark say3D selectRandom ["spark1", "spark11", "spark2", "spark22"];
    uiSleep (0.4 + random 0.7);
    deleteVehicle _spark;
} forEach (nearestObjects [_twins, ["Lamps_base_F", "PowerLines_base_F", "PowerLines_Small_base_F"], _aoe]);

// Strip electronic gear from units (multiple passes for assignedItems quirks).
private _jammable = [
    "NVGoggles", "NVGoggles_INDEP", "NVGoggles_OPFOR", "Integrated_NVG_F", "NVGoggles_tna_F",
    "O_NVGoggles_grn_F", "O_NVGoggles_ghex_F", "O_NVGoggles_urb_F", "O_NVGoggles_hex_F",
    "NVGogglesB_blk_F", "NVGogglesB_grn_F", "NVGogglesB_gry_F",
    "ACE_NVG_Gen1", "ACE_NVG_Gen2", "ACE_NVG_Gen4", "ACE_NVG_Wide",
    "rhsusf_ANPVS15", "rhsusf_ANPVS14", "rhs_1PN138",
    "CUP_NVG_HMNVS", "CUP_NVG_PVS14", "CUP_NVG_GPNVG_black", "CUP_NVG_GPNVG_tan", "CUP_NVG_GPNVG_green",
    "CUP_NVG_PVS15_black", "CUP_NVG_PVS15_tan", "CUP_NVG_PVS15_green",
    "Rangefinder", "Laserdesignator", "Laserdesignator_02", "Laserdesignator_03",
    "ACE_Vector", "ACE_VectorDay", "ACE_Yardage450", "ACE_MX2A",
    "CUP_Vector21Nite", "CUP_SOFLAM", "CUP_Binocular_Vector", "CUP_Laserdesignator",
    "ItemGPS", "itemcTab", "itemMicroDAGR", "ItemRadio",
    "B_UavTerminal", "O_UavTerminal", "I_UavTerminal", "C_UavTerminal",
    "TFAR_anprc148jem", "TFAR_anprc152", "TFAR_anprc154", "TFAR_fadak", "TFAR_pnr1000a", "TFAR_rf7800str"
];

private _weaponOptics = [
    "optic_nightstalker", "optic_nvs", "optic_tws", "optic_tws_mg", "acc_pointer_IR",
    "rhsusf_acc_anpvs27", "rhsusf_acc_anpas13gv1", "rhsusf_acc_anpeq15", "rhsusf_acc_anpeq15A",
    "rhs_acc_perst3", "rhs_acc_perst1ik_ris", "ace_acc_pointer_green",
    "CUP_optic_AN_PVS_4", "CUP_optic_AN_PVS_10", "CUP_optic_NSPU", "CUP_acc_ANPEQ_15", "CUP_acc_ANPEQ_2"
];

for "_pass" from 1 to 4 do {
    {
        private _unit = _x;
        if (alive _unit) then {
            private _common = (_jammable arrayIntersect assignedItems _unit);
            if (_common isNotEqualTo []) then {
                private _item = _common select 0;
                _unit unassignItem _item;
                _unit removeItem _item;
                _unit removeWeapon _item;
            };
            {_unit removePrimaryWeaponItem _x} forEach (_weaponOptics arrayIntersect (primaryWeaponItems _unit));
        };
    } forEach (nearestObjects [_twins, ["CAManBase"], _aoe]);
    uiSleep 0.5;
};

uiSleep 1;
deleteVehicle _bangSource;
deleteVehicle _twins;
