
private ["_dir","_dist","_pos","_spawned","_numToSpawn","_groupsToSpawn","_numInGroups","_veh","_car","_vehiclesToSpawn"];

if (isServer) then {

    private ["_rad","_cnps","_dist","_dir","_pos","_marker","_armPos","_centPos","_checkVar","_side","_group","_logic","_check1","_check2","_arrayCompare"];


    if (isNil "BIS_functions_mainscope") then
    {
        _side = createCenter sideLogic;
        _group = createGroup _side;
        _logic = _group createUnit ["FunctionsManager", [0,0,0], [], 0, "NONE"];

    };
    waitUntil {!isnil "bis_fnc_init"};


    CVG_spawn_zombies = compile preProcessFileLineNumbers "craigs_scripts\CVG_spawn_zombies.sqf";
    if (isNil ("townlist")) then {
			_rad=20000;
			_cnps = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
			townlist= nearestLocations [_cnps, ["CityCenter"], _rad]
		};

        town = townlist call BIS_fnc_selectRandom;
		
        _marker=createMarker [format ["mar%1",random 100000],(position town)];
        _marker setMarkerType "Dot";
        _marker setMarkerColor "ColorBlue";
        _marker setMarkerSize [2,2];

        _checkVar = 0;
        _armPos = getArray(configFile >> "CfgWorlds" >> worldName >> "Armory" >> "positionStart");
        _centPos = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");

        while {_checkVar == 0} do{
            _dist = 400;
            _dir = random 360;
			dirBackToTown = (_dir - 180);
            _pos = [(getPos town select 0) + (sin _dir) * _dist, (getPos town select 1) + (cos _dir) * _dist, 0];
            _pos = [_pos,0,40,10,0,20,0] call BIS_fnc_findSafePos;
            
            _check1 = [_pos, _armPos] call arrayCompare;
            _check2 = [_pos,_centPos] call arrayCompare;
            if ((!_check1) && (!_check2) && ((_pos distance (getpos town)) > 300)) then { _checkVar = 1};
        };

        //Publish the location:
        startPosition = _pos;
        publicVariable "startPosition";
		publicVariable "dirBackTotown";
		
        _marker=createMarker [format ["mar%1",random 100000],_pos];
        _marker setMarkerType "Dot";
        _marker setMarkerColor "ColorRed";
        _marker setMarkerSize [2,2];
    };
    waitUntil {!isNil "startPosition"};
	
    if (!isDedicated) then {
		player setpos startPosition;

		//Check to make sure player is at that position:
		if (((position player) distance startPosition) > 50) then {
			While {((position player) distance startPosition) > 50} do {
				player setpos startPosition;
				sleep 1;
			};
		};

		// Give player weapons
		diag_Log "picking starting weapon";
		removeAllWeapons player;
		[player] execVM "craigs_scripts\randomUnitWeapons.sqf";

	};

	
	//Spawn all the zombies. (Tons)
	if (isServer) then {	
		[] spawn {
			sleep 1;
			_numToSpawn = 50 + (round (random 50));		//At least 50 + a number between 0 and 50
			_groupsToSpawn = (5 + (round (random 3)));		//How many individual groups of zombies within the town itself.
			_numInGroups = (round (_numToSpawn / _groupsToSpawn));		//How many zombies in groups? The total divided by the number of groups
			
			_spawned = 0;
			while {_spawned <= _groupsToSpawn} do {
				_dir = (random 360);
				_dist = (random 100);
				_pos = [(getPos town select 0) + (sin _dir) * (_dist), (getPos town select 1) + (cos _dir) * (_dist), 0];		
				[_pos,"Array",_numInGroups] spawn CVG_spawn_Zombies;
				_spawned = _spawned + 1;
				sleep 20;
			};
		};
	};
	
	
	if (isServer) then {
		
		if (CVG_TownAttackVehicles == 1) then {
			waitUntil {!isNil "CLY_players"};
			_vehiclesToSpawn = (count CLY_players);
			_spawned = 0;
			while {_spawned < _vehiclesToSpawn} do {
				_veh = MilitaryVehs call BIS_fnc_selectRandom;
				_pos = [(startPosition select 0) + (sin dirBackToTown) * (10), (startPosition select 1) + (cos dirBackToTown) * (10), 0];	
				_car = createVehicle [_veh,_pos,[], 0,"None"]; 	
				_car setDir dirBackToTown;
				_spawned = _spawned + 1;
			};
		};
	};
	
	if (!isDedicated) then {
		player setDir (dirBackToTown);
		player setCaptive true;
	};
	

    if (isServer) then {
		[] spawn {
			private ["_startTime"];
			_startTime = time;
			waitUntil {sleep 1; (({alive _x} count spawned_Zombies) < 5) or ((time - _startTime) > 600)};
			[nil,nil,rHINT,"One town down, here comes another!"] call RE;
			[] execVM "gamemodes\CVG_townattack\townattack.sqf";
		};
	};
