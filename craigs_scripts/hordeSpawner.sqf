//random horde by Spam_One, using celery cly_z_horde.sqf - By Spam_One --------------------------------------
// check every 5 minutes ------------------------------------------------------------------------------------
// 10% of random horde spawn on player ----------------------------------------------------------------------
// simply as that -------------------------------------------------------------------------------------------
if (!isServer) exitWith {};

private ["_proba","_PosPlayer","_randomNum", "_victim", "_sleepTime"];

waitUntil {sleep 30; diag_log "Random Hordes wait 30 sec"; count playableUnits > 0};

_sleepTime = count playableUnits;
_sleepTime = 30 * _sleepTime;
_sleepTime = 1200 - _sleepTime;
_sleepTime = 120 + _sleepTime;

diag_log format ["Horde Spawning starts in %1", str(_sleepTime)];
sleep _sleepTime;

_victim = playableUnits select (floor random count playableUnits);

_proba = floor random 100;

while {_proba < 10} do {
    sleep 30;
    _proba = floor random 100;
};
	
_randomNum = (10 + (floor random 25)); // allow randomness for zombies in hordes

_position = [_victim, 50, 50 , 75] call WF_FNCT_getRandomSafePos;

_randomPosP = "logic" createVehicleLocal (_position);
_randomPosP setDir (random 360);
				
trigger = createTrigger ["EmptyDetector", _position];
trigger setTriggerArea [10, 10, 0, false];

[trigger, _randomNum, CLY_hordetrigger, "normal", _victim] execVM "zombie_scripts\cly_z_horde.sqf";

deleteVehicle _randomPosP;		
	
[] execVM "craigs_Scripts\RandomHwithCLY.sqf";
	
// End ------------------------------------------------------------------------------------------------------