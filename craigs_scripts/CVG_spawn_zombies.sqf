
	private ["_spawned","_zombie","_horde","_zombietype","_object","_group","_spawn_number","_class","_locType"];
	_object = _this select 0;
	_locType = _this select 1;
	_zcount = _this select 2;
	
	waitUntil {!isNil "CLY_zombieclasses"};
	if (isNil "_Zcount") then {
		_spawn_number = (round(2 * (random 2)));
	} else {_spawn_number = _zcount};
    _spawned = 0;
 diag_log format ["Spawning %1 zombies",_spawn_number];

    while {_spawned < (_spawn_number)} do {
		_group = createGroup east;
		_class = call CLY_randomzombie;
		_zombietype = "normal";
		_zombie= _group createUnit [_class,getPos zombiespawner,[],50,"NONE"];
		waitUntil {typeOf _zombie == _class};
		if (gameType == 1 or gameType == 2) then {
			spawned_Zombies = spawned_Zombies + [_zombie];
		};
		_zombie enableSimulation false;
		if (CVG_Horde == 1) then {_horde = false} else {_horde = true};

		
		//Initialize zombification
		if (_locType == "Object") then {
			[_zombie,_zombietype,objNull,_horde,0,[(getpos _object select 0) + (random 5),(getpos _object select 1) + (random 5),0],true] exec "zombie_scripts\cly_z_init.sqs";
		};
		if (_locType == "Array") then {
			[_zombie,_zombietype,objNull,_horde,0,[(_object select 0) + (random 5),(_object select 1) + (random 5),0],true] exec "zombie_scripts\cly_z_init.sqs";
		};
        _spawned = _spawned + 1;
		diag_log format ["Zombie %1 spawned at %2",_zombie,_object];
		sleep 0.01;
    };

