/*
Zombie Spawning script, beta testing version 2A [Friday, July 27]
by Craig
*/

CVG_spawn_zombies = compile preProcessFileLineNumbers "craigs_scripts\CVG_spawn_zombies.sqf";

[] execFSM "craigs_scripts\zombieGenerator2.FSM";

