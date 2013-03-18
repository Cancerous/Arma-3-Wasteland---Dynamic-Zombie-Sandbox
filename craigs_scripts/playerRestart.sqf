/*
Player Respawn script 
by Craig
*/

[] execVM "tonic\onRespawn.sqf";

//player setcaptive true;

if (!isDedicated) then
 {
	player execVM "zombie_scripts\cly_z_victim.sqf";
	sleep 3;
	if (CVG_ZombieTowns == 4) then {
		[] spawn zedLoop; //call (compile (preprocessFileLineNumbers "craigs_scripts\zombieRespawner.sqf"));
	};
};