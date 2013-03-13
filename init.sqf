/*
Init.sqf
Author: Craig Vander Galien 
Email: craigvandergalien@gmail.com
ModDB: http://www.moddb.com/mods/bobtoms-arma2-missions
Armaholic: http://www.armaholic.com/page.php?id=15778
BIS forums: http://forums.bistudio.com/showthread.php?128781-TvT-FFA-CO-40-Dynamic-Zombie-Sandbox

Any questions? Contact me at one of the above places.

Thanks,
Craig
*/

#include "setup.sqf"
//if (isnil "RE") then {[] execVM "\ca\Modules\MP\data\scripts\MPframework.sqf"};
//Include Strings for text like side missions.
#include "en_strings.sqf";

//Just some variables being set for if is server, client, jip. 
if(isServer) then { Z_Server = true;} else { Z_Server = false;};
if(!isDedicated) then { Z_Client = true; } else { Z_Client = false};
if(isNull player) then { Z_JIP = true; } else { Z_JIP = false; };

//Init some variables
screendone = 0;
paramsDone = 0;
trigArray = [];

StartProgress = false;
//enableSaving[false,false];

X_Server = false;
X_Client = false;
X_JIP = false;
hitStateVar = false;
versionName = "v1.05 Alpha";

if(isServer) then { X_Server = true;};
if(!isDedicated) then { X_Client = true;};
if(isNull player) then {X_JIP = true;};


//If jip client.. Execute some JIP code.
if(Z_JIP) then { [] execVM "onJip.sqf"; };

true spawn {
	if(!isDedicated) then {
		titleText ["Please wait for your player to setup", "BLACK", 0];
		waitUntil {player == player};
		client_initEH = player addEventHandler ["Respawn", {removeAllWeapons (_this select 0);}];
	};
};

gameType = (paramsArray select 9);



if (gameType == 0) then {
	//Launch the mission
	[] execVM "craigs_scripts\startup.sqf";


	//waitUntil {screendone == 1};

	/*
	if(Z_Server) then {
	"R3F_DZS" addPublicVariableEventHandler {[_this select 1] execVM "server_obj_spawn.sqf"};
	};
	*/

	// sets parameter defaults if the game is in SP

		CLY_friendlyfire= 1;
		CLY_terraingrid= 0;
		CVG_Debug= 1;
		CVG_timeToSkipTo = 18;
		CVG_CityDestruction= 2;
		CVG_bandages=4;
		CVG_Fog = 0;
		CVG_Viewdist = 2500;
		CVG_Weather = 1;
		gameType = 0;
		CVG_playerWeapons = 1; 
		CVG_playerItems= 1; 
		CVG_Aminals= 2; 
		CVG_Horde= 1;
		CVG_maxaggroradius=500;
		CVG_Zdensity = 100;
		CVG_minSpawnDist = 100;
		CVG_weapontype= 1;
		CVG_Zombietowns= 4;
		CVG_taskType = 4;
		CVG_taskoption = 1;
		vehspawntype=0;
		chanceNumber = 10;
		CVG_Fuel = 0;
		CVG_FastTime = 1;
		CVG_Weaponcount  = 1;
		CVG_VehicleStatus = 4;
		CVG_Respawn = 1;
		CVG_backpacks = 1;
		CVG_Caches = 1;
		CVG_survivors = 0;
		CVG_logistics = 0;
		CVG_SideMissions =0;



	if (CVG_logistics == 1) then {
		[] execVM "addons\R3F_ARTY_AND_LOG\init.sqf";
	};

	
	if (CVG_SideMissions == 1) then {
		SMarray = ["SM1","SM2","SM3","SM4"];
		[1] execVM "sideMissions\SMfinder.sqf";
	};	
	[] execVM "craigs_Scripts\hordeSpawner.sqf"; 
};

//init Wasteland Core
[] execVM "config.sqf";
[] execVM "briefing.sqf";

if(X_Client) then {
	waitUntil {player == player};

	//Wipe Group.
	if(count units group player > 1) then
	{  
		diag_log "Player Group Wiped";
		[player] join grpNull;    
	};

	[] execVM "client\init.sqf";
};
if(X_Server) then {
	diag_log format ["############################# %1 #############################", missionName];
	#ifdef __DEBUG__
	diag_log format ["T%1,DT%2,F%3", time, diag_tickTime, diag_frameno];
	#endif
    diag_log format["WASTELAND SERVER - Initilizing Server"];
	[] execVM "server\init.sqf";
};

if (gameType == 1) then {
	[] execVM "gamemodes\LTJ_infected\infected_startUp.sqf";
};

if (gameType == 2) then {
	[] execVM "gamemodes\CVG_TownAttack\townattack_startup.sqf";
	waitUntil {screenDone == 1};
};

//launch celery's scripts

[] execVM  "craigs_scripts\zombiesinit.sqf";
[] exec "craigs_scripts\zombiesinit.sqs";

/*	
//init keypress get-in system
if (!isdedicated) then {
	waitUntil {!isNil "CVG_E"};
	if (CVG_E == 1) then {
	onKeyPress = compile preprocessFile "craigs_scripts\onKeyPress.sqf";
	waituntil {!(IsNull (findDisplay 46))};
	(findDisplay 46) displayAddEventHandler ["KeyDown", "nul = [_this select 0, _this select 1] execVM 'craigs_scripts\onKeyPress.sqf' "];
	};
};
*/
//init 3rd Party Scripts
[] execVM "addons\R3F_ARTY_AND_LOG\init.sqf";
[] execVM "addons\proving_Ground\init.sqf";
//[0.1, 0.5, 0.5] execVM "addons\scripts\DynamicWeatherEffects.sqf";

//runs player connect script
onPlayerConnected "Z_JIP_Time = date; publicVariable ""Z_JIP_Time""";

sleep 3;
_messages = ["Escape this hellhole!","Survive","Lock and load","Get ready, Zombies are coming","Pillage and steal","The higher, the better","Enjoy your stay!","Headshots are better!!","craigvandergalien@gmail.com","Unite or Fight","Kill some Zs!","By Craig Vander Galien","Help: Luke Jansen"];


/*
// words at start, dedicated can't run it
if (!isDedicated) then {
	_pos = (getPosATL player);
	_words = _messages call BIS_fnc_selectRandom;
	waitUntil {_pos distance (getPosATL player) > .1};
    [str ("DZS:Dynamic Zombie Sandbox") ,  str (format ["%1", name player]),_words] spawn BIS_fnc_infoText;
};
*/


