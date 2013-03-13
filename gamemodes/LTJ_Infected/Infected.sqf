
private ["_side","_group","_logic","_waves","_string","_checkVar","_townPos","_armPos","_centPos","_check1","_check2","_Starttime","_marker"];

CVG_spawn_Setup = {
	private ["_pos","_dist","_dir","_spawncount"];
	_pos = _this select 0;
	_spawncount = 0;
	//while {_spawncount < zcount} do {
		_spawncount = _spawncount + 1;
		_dist = (100 + (floor(random 100)));
		_dir = random 360;
		_pos = [(_pos select 0) + (sin _dir) * _dist, (_pos select 1) + (cos _dir) * _dist, 0];
		Pos = [_Pos,1,30,1,0,20,0] call BIS_fnc_findSafePos;
		CVG_Horde = 2;
		CLY_horde = true;
		[Pos,"Array",zcount] spawn CVG_spawn_Zombies;
		
//	};
};

private ["_side","_group","_logic","_man","_spawn","_startingGun","_startingAmmo"];
if (isNil "BIS_functions_mainscope") then
{
    _side = createCenter sideLogic;
    _group = createGroup _side;
    _logic = _group createUnit ["FunctionsManager", [0,0,0], [], 0, "NONE"];
};
waitUntil {!isnil "bis_fnc_init"};




_checkVar = 0;
_Starttime = time;
while {_checkVar < 1} do {
	_townpos = [newPos, 2, 10, 1, 0,20, 0] call BIS_fnc_findSafePos;

	_armPos = getArray(configFile >> "CfgWorlds" >> worldName >> "Armory" >> "positionStart");
	_centPos = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");

	_check1 = [_townpos, _armPos] call arrayCompare;
	_check2 = [_townpos,_centPos] call arrayCompare;
	
	if ((!_check1) && (!_check2) && ((newPos distance _townpos) < 100)) then {
	_checkVar = 1;
	};
	
	if (time - _startTime > 5) then {_townPos = newPos; _checkVar = 1};
 };
 
mysteryBox = createVehicle ["SpecialWeaponsBox",[_townPos select 0, _townpos select 1, 0],[], 2, "NONE"]; 
mysteryBox setVariable ["item", "mysteryBox" ,true];
clearweaponcargoGlobal mysteryBox;
clearmagazinecargoGlobal mysteryBox;
mysterybox allowdamage false;
publicVariable "mysterybox";
_marker = createMarker ["Mystery Box", position mysteryBox];
_marker setMarkerType "mil_destroy";
_marker setMarkerColor "ColorRed";
_marker setMarkerText "Mystery Box";
_marker setMarkerSize [1,1];
zcount = 0;
_waves = 0;

sleep 5;
while {true} do {
	_startTime = time;
	[nil,nil,rplaySound,"roundintro"] call RE;
	spawned_Zombies = [];
	_waves = _waves + 1;
	
	zcount = zcount + (floor random 3);
	[_townPos] call CVG_spawn_Setup;

    string =  format ["Round %1 begins",_waves];
	[player,nil,rsideChat,string] call RE;

	[] spawn {
		sleep 60;
		{
			if (!isPlayer _x) then {
				[_x] spawn {
					_zombie = _this select 0;
					while {sleep 1; ({alive _x} count spawned_Zombies == 0);} do {
						_zPos = (getpos _zombie);
						sleep 5;
						if ((_zPos distance (getpos _zombie)) > 1) then {} else {
							_zombie setDamage 1; 
						};
					};
				};
			};
		} forEach AllUnits
	};

    waitUntil { sleep 1; (({alive _x} count spawned_Zombies) == 0) or ((time - _startTime) > 150)};
    if ( (time - _startTime) > 149) then {{if (!isPlayer _x) then {deleteVehicle _x};} forEach allUnits;};
	sleep 1;
	[nil,nil,rplaySound,"roundend"] call RE;
	sleep 15;

};


