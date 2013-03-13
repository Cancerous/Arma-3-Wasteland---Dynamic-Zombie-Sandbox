/*
Player Respawn script 
by Craig
*/

[] execVM "tonic\onRespawn.sqf";

private ["_townnumber","_town","_townpos","_group","_logic","_newPos","_building","_thing","_things","_checkVar","_dist","_dir","_pos","_check1","_check2","_armPos","_centPos","_unit","_towns"];
StartLoadingScreen["Loading Mission Components","RscLoadScreenCustom"];
_unit = _this select 0;
/*
    _towns= townlist;
    if (CVG_playerstart == 50) then {
        if ((count _towns) != 0) then {
            _townnumber = floor (random (count _towns));
            _town = _towns select _townnumber;
            _townpos = (position _town);
            _group = createGroup sideLogic;
            _logic = _group createUnit ["Logic",_townpos, [], 100, "NONE"];  
            _newPos = position _logic;
			if (_newPos select 0 != 0) then {
            _unit setposATL _newPos;
			} else {
			_unit setposATL _townPos
			};
            if (CVG_debug == 2) then {
                _unit sidechat format ["location chosen, %1",_town]
            };
        }
        else
        {
            if ((count buildings) != 0) then {
                _building = (round(random(count buildings)));
                _newpos = position (buildings select _building);
                _newpos = [_newPos,0,50,1,0,20,0] call BIS_fnc_findSafePos;
                _unit setpos _newpos;
            }
            else
            {
                _things = nearestObjects [_unit, [], 200000];
                if ((count _things) != 0) then {
                    _thing = (round(random(count _things)));
                    _newpos = position (_things select _thing);
                    _unit setposATL _newpos;
                }
                else
                {
                    _newpos = [(random 1000),(random 1000),0];
                    _unit setposATL _newpos;
                };
            };
        };
    };
    
    if (CVG_playerstart == 100) then {
        _townnumber = floor (random (count _towns));
        _town = _towns select _townnumber;
        _townpos = getpos _town;
        _checkVar = 0;
        _armPos = getArray(configFile >> "CfgWorlds" >> worldName >> "Armory" >> "positionStart");
        _centPos = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
	
        while {_checkVar < 1} do{
            _dist = 1500;
            _dir = random 360;
            _pos = [(_townpos select 0) + (sin _dir) * _dist, (_townpos select 1) + (cos _dir) * _dist, 0];
            _pos = [_pos,0,40,4,0,20,0] call BIS_fnc_findSafePos;
            _check1 = [_pos, _armPos] call arrayCompare;
            _check2 = [_pos,_centPos] call arrayCompare;
            if ((!_check1) && (!_check2) && ((_pos distance (getpos _town)) > 1000)) then { _checkVar = 1};
        };
        _unit setpos _pos;
        _newpos = _pos;
        if (CVG_debug == 2) then {_unit sidechat format ["location chosen, %1",_pos]};
    };
	
    if (CVG_playerstart == 150) then {
		_unit setpos newPos;
        if (CVG_debug == 2) then {
            _unit sidechat format ["location chosen, %1",_pos];
        };
    };
    
diag_log format ["Respawn: %1 respawned at %2",name _unit, _newpos];


if (CVG_fog == 1) then {
    null=[_unit,100,11,30,3,7,-0.3,0.1,0.5,1,1,1,13,12,15,false,2,2.1,0.1,1,1,0,0,24] execFSM "Fog.fsm";
};




if (CVG_playerItems == 2) then 
{
	_unit removeWeapon "itemMap";
	if (_unit hasWeapon "itemMap") then {
		diag_log "Removing Map Failed, Trying again";
		while {_unit hasWeapon "itemMap"} do {
			_unit addWeapon "itemMap";
			diag_log "Trying to remove Map again";
		};
	};
	diag_log "Map removed successfully";
};
*/
if (CVG_ZombieTowns == 4) then {
	[] execVM "craigs_scripts\zombieGenerator.sqf";
};

endLoadingScreen;
/*
sleep 5;
if (CVG_playerWeapons == 1) then {
    if (CVG_debug == 2) then {
        _unit sidechat "picking starting weapon";
    };
    removeAllWeapons _unit;
    [_unit] execVM "craigs_scripts\randomUnitWeapons.sqf";
};

if (CVG_playerWeapons == 2) then 
{
    removeAllWeapons _unit;
	if (currentWeapon _unit != "") then {
		diag_log "First try at removing weapons failed. Trying again";
		while {currentWeapon _unit != ""} do {
			removeAllWeapons _unit;
			diag_log "Trying to remove weapons again";
		};
	};
	diag_log "Weapons Successfully Removed";
};
*/

player setcaptive true;
/*
	//simple beta Vehicle spawning
	[] spawn {
		while {alive player} do {
		  _buildings = nearestObjects [(getpos (vehicle player)),["house"],500];
		  {
		  _build = _x;
		  _num = round random 100;
			  if (_num < chanceNumber) then {
				  if (isNil {_build getVariable "used"}) then {
					 _pos = getpos _build;
					 [_pos,0] call vehicleinfo;
					 _x setvariable ["used",true,true];
				  };
			  };
			  sleep .1;
		  } forEach _buildings;
		  sleep 5;
		};
	};
	*/
	player execVM "zombie_scripts\cly_z_victim.sqf";


_messages = ["Escape this hellhole!","Survive","Lock and load","Get ready, Zombies are coming","Pillage and steal","The higher, the better","Enjoy your stay!","Like Dead Island, but better in every way","Headshots are better!!","craigvandergalien@gmail.com","Unite or Fight. Play your way"];


	
    if (CVG_ZombieTowns == 4) then {
		_reset = 0;
		usedBuildings = [];
		hint "starting spawning";
		[] execVM "craigs_scripts\zombieGenerator.sqf";
		if (!isDedicated) then {
			while {alive player} do {
				if (count usedBuildings != 0) then {
					{
						if (_x distance player > 500) then {usedBuildings = usedBuildings - [_x]}
					} forEach usedBuildings;
				};
				sleep 5;
				_reset = _reset + 5;
				if (_reset == 100) then {usedBuildings = []; _reset = 0;};
			};
		};
	};