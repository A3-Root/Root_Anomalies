// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if ((!alive swarmer_public)or(player distance swarmer_public > 1000)) exitWith {};

if (isNil{swarmer_public getVariable "tgt"}) then 
{flow_back = (_this vectorFromTo [(getPosASL swarmer_public # 0)+random (selectRandom [1,-1]),(getPosASL swarmer_public # 1)+random (selectRandom [1,-1]),random 2])}
else {
	if (atak_swarmer) then {
		_tgt_sw = swarmer_public getVariable "tgt";
		flow_back = (_this vectorFromTo [getPosASL _tgt_sw # 0,getPosASL _tgt_sw # 1,0.5+random 1]) vectorMultiply (3+random 5);
		if (_this vectorDistance (getPosASL _tgt_sw) < 1) then {atinge=true;};
	} 
	else {flow_back = (_this vectorFromTo [(getPosASL swarmer_public # 0)+random 2,(getPosASL swarmer_public # 1)+random 2,0.5+random 1]) vectorMultiply (3+random 5)};
};
drop [["\A3\animals_f\fly.p3d",1,0,1,1],"","SpaceObject",1,0.5,_this,flow_back,0,10,7.9,0,[6],[[1,1,1,1]],[1],1,1,"","\Root_Anomalies\Root_Swarmer\AL_swarmer\swarmer_flies.sqf",_this];
drop [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",8,0,40,0],"","Billboard",1,0.5,_this,[0,0,0],0,10,8,0,[5,5,5],[[0,0,0,0],[0,0,0,0.01],[0,0,0,0]],[1],0,0,"","",_this];