//	@file Version: 1.0
//	@file Name: onRespawn.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

private["_player","_corpse","_town","_spawn","_temp"];
playerSetupComplete = false;

_player = (_this select 0) select 0;
_corpse = (_this select 0) select 1;
_corpse removeAction playerMenuId;
{
	_corpse removeAction _x;
} forEach aActionsIDs;

player call playerSetup;
waitUntil {playerSetupComplete};

[] execVM "client\clientEvents\onMouseWheel.sqf";

true spawn playerSpawn;

[] spawn {
	waitUntil{respawnDialogActive};
	waitUntil{sleep 0.1; !respawnDialogActive};

	if(!isNull pvar_PlayerTeamKiller) then {
		pDialogTeamkiller = pvar_PlayerTeamKiller;
		pvar_PlayerTeamKiller = objNull;

		[] execVM "client\functions\createTeamKillDialog.sqf";
	};
};

//[] execVM "tonic\onRespawn.sqf";

//player setcaptive true;

if (!isDedicated) then
 {
	player execVM "zombie_scripts\cly_z_victim.sqf";
	if (CVG_ZombieTowns == 4) then {
		[] spawn zedLoop; //[] execVM
	};
};