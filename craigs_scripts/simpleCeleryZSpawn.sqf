/* 
Celery Zombie spawning script
Author: Craig

How to use:
place the following into the init of any object or unit (not triggers or markers), or put it in a script and use any objects name

0=[any object on the map, besides tiggers and markers,number of zombies to spawn,spawntype] execVM "simpleZombieSpawn.sqf";

Example:

0=[Jim,20] execVM "simpleCeleryZSpawn.sqf";
*/


private ["_trig","_group","_newpos","_inftype","_spawned","_number","_rnd","_CLY_zombieclasses","_spawnnumb","_spawngroup"]; // privatizes variables

_trig = _this select 0; //takes trigger from parameters that are stated in the [] before execVM in the trigger
_number = _this select 1; // this is the number of new zombies
_newpos = getpos _trig; // sets the spawnpos as the trigger position
_spawned = 0; // obviously no zombies have been spawned yet so its zero
_spawngroup = _this select 2;
_spawnnumb = 0;
horde = [];

_CLY_zombieclasses=["Citizen1","Citizen2","Citizen3","Citizen4","Profiteer1","Profiteer2","Profiteer3","Profiteer4","Rocker1","Rocker2","Rocker3","Rocker4","Villager1","Villager2","Villager3","Villager4","Woodlander1","Woodlander2","Woodlander3","Woodlander4","Worker1","Worker2","Worker3","Worker4","Ins_Lopotev","Assistant","Doctor","Pilot_EP1","Policeman","Priest","TK_CIV_Worker01_EP1","TK_CIV_Worker02_EP1","Functionary1","Functionary2","Ins_Soldier_1","Ins_Soldier_Crew","Ins_Soldier_CO","Ins_Bardak","Ins_Lopotev","CDF_Soldier_Militia","CDF_Soldier_TL","CDF_Soldier_Crew","CDF_Soldier_Light","USMC_Soldier","USMC_Soldier_Officer","USMC_Soldier_TL","USMC_Soldier_Crew","USMC_Soldier_Light","FR_TL","FR_Marksman","FR_GL","FR_Sapper","FR_Light","BAF_Soldier_W","BAF_Soldier_Officer_W","BAF_crewman_W","BAF_Soldier_AR_W","BAF_Soldier_TL_W","BAF_Soldier_L_W","RU_Soldier","RU_Soldier_Officer","RU_Soldier_Crew","RU_Soldier_Light","RUS_Soldier3","RUS_Commander","Soldier_PMC","Soldier_GL_PMC","Soldier_Engineer_PMC","Soldier_TL_PMC"];
//All the possible classes to spawn, can be any man, women don't work, sillly arma
while {_spawnnumb < _spawngroup} do {
    _group = createGroup east; //Creates a group
    while {_spawned < _number} do {
        _rnd = random floor (count _CLY_zombieclasses); //Picks a random class
        _inftype = _CLY_zombieclasses select _rnd; //Sets the variable to the class
        // _newPos = [_newpos, 0, 100, 1, 0, 60 * (pi / 180), 0] call BIS_fnc_findSafePos; //finds a usable spawning position from
        unit = _group createUnit [_inftype,_newpos, [], 25, "None"]; 	// creates people
        [unit,"normal",objNull,true,20,_newpos] exec "zombie_scripts\cly_z_init.sqs"; //turns them into zombies
        _spawned = _spawned + 1; 
        // adds another zombie to the amount of zomibes spawned
        sleep 0.1; //waits
        
        horde = horde + [unit];
    };
    sleep 3;
    _spawnnumb = _spawnnumb + 1;
};
if (CVG_Debug == 2) then {	
    player sidechat "zombie group complete";//Gives a message saying that the spawning is done
};
_spawned = 0; //If we wanted to spawn some more, the spawncount should be set to 0 again
horde



