//Zombie behavior routines written by Celery

_zombie = _this select 0;
_aggroradius = _this select 1;
_wait = time + random 35;
_victim = objNull;
_noisewait = time + 5 + random 40;
_despawncheckwait = time + 10;
_armored = _zombie getVariable ["zombietype", ""] in ["armored", "slow armored"] || typeOf _zombie in CLY_armoredzombieclasses;
_damage = 0;

//Aggro radius
_maxradius = if ({[_x, getPosATL _zombie] call BIS_fnc_inTrigger} count CLY_altmaxaggroradiustriggers == 0) then {CVG_maxaggroradius;} else {CVG_maxaggroradius;};

if (_aggroradius == 0) then {_aggroradius = CLY_minaggroradius + random (_maxradius - CLY_minaggroradius)};
if (_zombie getVariable ["zombietype", ""] in ["crawler", "sneaker"]) then {_aggroradius = _maxradius;};
_zombie setVariable ["aggroradius", _aggroradius, true];
//Death gurgle
if (random 1 < 0.4 && _zombie getVariable ["zombietype", ""] != "creeper") then
{
	_zombie addEventHandler
	[
		"Killed", 
		{
			_zombie = _this select 0;
			if (_zombie getVariable "victim" != _zombie && !(_zombie getVariable "despawn")) then
			{
				_sound = CLY_noises_die select floor random count CLY_noises_die;
				_object = "logic" createVehicleLocal [0, 0, 0];
				_object attachTo [_zombie, [0, 0, 1.5]];
				_object say3D _sound;
				_object spawn {sleep 5;deleteVehicle _this};
				CLY_z_attackpv = [_zombie, _sound];
				publicVariable "CLY_z_attackpv";
			};
		}
	];
};

//Bandage
_bandage = false;
if (CLY_zombiebandagechance > 0) then
{
	if (random 1 <= CLY_zombiebandagechance || _armored || typeOf _zombie in ["Doctor", "Assistant"]) then
	{
		_bandages = 1;
		if (typeOf _zombie in ["Doctor", "Assistant"] && random 1 <= CLY_zombiebandagechance) then
		{
			_bandages = 2;
		};
		_zombie setVariable ["CLY_heal_bandages", _bandages, true];
	};
};

//Magazine
if (CLY_zombiemagazinechance > 0) then
{
	if (random 1 <= CLY_zombiemagazinechance || _armored) then
	{
		_mag = CLY_zombiemagazines select floor random count CLY_zombiemagazines;
		while {typeName _mag == "ARRAY"} do
		{
			_mag = _mag select floor random count _mag;
		};
		_zombie addMagazine _mag;
	};
};

sleep random 2;

while {alive _zombie} do
{
	//////////Idle//////////
	while {isNull (_zombie getVariable "victim") && alive _zombie} do
	{
		//Initiate idling
		if (_zombie getVariable ["zombietype", ""] in ["normal", "surprise", "crawler", "sneaker", "walker", "armored", "slow armored"]) then {_zombie lookAt objNull;};
		if (_zombie getVariable ["zombietype", ""] in ["crawler", "passive crawler", "sneaker", "ambusher"]) then {_zombie setUnitPos "DOWN";};
		
		//Noise
		if (_zombie getVariable ["zombietype", ""] in ["normal", "walker"] && time > _noisewait) then
		{
			_sound = CLY_noises_idle select floor random count CLY_noises_idle;
			_zombie say3D _sound;
			CLY_z_noisepv = [_zombie, _sound];
			publicVariable "CLY_z_noisepv";
			_noisewait = time + 5 + random 40;
		};
		
		//Next waypoint
		if (!(_zombie getVariable ["zombietype", ""] in ["passive", "passive crawler", "ambusher"]) && time > _wait) then
		{
			_zombie doMove getPosATL _zombie;
			_movepos = [0, 0, 1000];
			while {surfaceIsWater _movepos || _movepos select 2 == 1000} do
			{
				_movepos = [(getPosATL _zombie select 0) - 30 + random 60, (getPosATL _zombie select 1) - 30 + random 60, 0];
			};
			_zombie doMove _movepos;
			_zombie setSpeedMode "LIMITED";
			_wait = time + 10 + random 35;
		};
		
		//Search nearest victim if horde
		_victim = _zombie getVariable "victim";
		if (_zombie getVariable "horde") then
		{
			_victim = objNull;
			_dist = 10000;
			{
				_distance = _zombie distance vehicle _x;
				if (_distance < _dist) then
				{
					_victim = _x;
					_dist = _distance;
				};
			} forEach CLY_zombievictims;
			if (!isNull _victim) then
			{
				_zombie setVariable ["victim", _victim, true];
			};
		};
		
		//Determine final victim
		if (alive _zombie) then
		{
			if (!isNull (_zombie getVariable "victim") && _damage == damage _zombie) then
			{
				_victims = [_victim];
				if (!isNull _victim) then
				{
					if (CLY_randomvictimradius > 0) then
					{
						_victimradius = if (CLY_randomvictimradius > 1) then {CLY_randomvictimradius;} else {_dist * CLY_randomvictimradius;};
						{
							if (_x distance vehicle _victim < _victimradius && _zombie knowsAbout _x >= CLY_minaggroknowsabout) then {
								_victims set [count _victims, _x];
							}
						} forEach (getPosATL vehicle _victim nearEntities ["Man", _victimradius]);
					};
					_victim = _victims select floor random count _victims;
					_zombie setVariable ["victim", _victim, true];
				};
			};
		};
		_damage = damage _zombie;
		
		//Wait and check distances for despawning
		if (_zombie getVariable "dynamic") then
		{
			if (isNull (_zombie getVariable "victim") && alive _zombie) then
			{
				sleep 1;
				if (time > _despawncheckwait) then
				{
					_despawn = if ({[_zombie, vehicle _x] call BIS_fnc_distance2D < CLY_despawndist} count CLY_players == 0) then {true;} else {false;};
					if (_despawn) then
					{
						_zombie setVariable ["despawn", true];
						_zombie spawn {sleep 5;_this setDamage 1;};
					};
					_despawncheckwait = time + 10;
				};
			};
		};
	};
	
	//////////Aggroed//////////
	_noisewait = (random 3) min _noisewait;
	if (_zombie getVariable ["zombietype", ""] == "ambusher") then {_zombie setUnitPos "UP";};
	while {!isNull (_zombie getVariable "victim") && alive _zombie} do
	{
		_victim = _zombie getVariable "victim";
		_vehicle = vehicle _victim;
		_dist = _zombie distance _vehicle;
		_randomradius = 0;
		_movepos = [(getPosATL _vehicle select 0) - _randomradius + random _randomradius*2, (getPosATL _vehicle select 1) - _randomradius + random _randomradius*2, getPosATL _vehicle select 2];
		_zombie doMove _movepos;
		_zombie lookAt _vehicle;
		
		_newmovedist = CLY_zombieattackdist * _dist * 0.2;
		if (_newmovedist < CLY_zombieattackdist) then {_newmovedist = CLY_zombieattackdist;};
		
		//Give up the chase
		if (!(_zombie getVariable "horde") && _dist > CLY_chasegiveupdist) then
		{
			_zombie setVariable ["victim", objNull, true];
		};
		
		//Gradual check of chase conditions
		_chase = false;
		if (alive _zombie && !isNull _victim) then
		{
			if (_vehicle distance _movepos < _newmovedist) then
			{
				if (_zombie getVariable "horde" || _dist < CLY_chasegiveupdist) then
				{
					_chase = true;
				};
			};
		};
		
		//Chase
		while {_chase} do
		{
			if (_zombie getVariable ["zombietype", ""] in ["walker", "slow armored"]) then {_zombie setSpeedMode "LIMITED";} else {_zombie setSpeedMode "FULL";};
			if (_zombie getVariable ["zombietype", ""] == "sneaker" && (_dist < 25 || damage _zombie > 0)) then {_zombie setUnitPos "UP";};
			
			//Noise
			if (time > _noisewait && _zombie getVariable ["zombietype", ""] != "creeper") then
			{
				if (_zombie getVariable ["zombietype", ""] in ["normal", "walker"] || _dist < 4) then
				{
					_sound = if !(_zombie getVariable ["zombietype", ""] in ["walker", "slow armored"]) then
					{
						CLY_noises_chase select floor random count CLY_noises_chase;
					}
					else
					{
						CLY_noises_idle select floor random count CLY_noises_idle;
					};
					_zombie say3D _sound;
					CLY_z_noisepv = [_zombie, _sound];
					publicVariable "CLY_z_noisepv";
					_noisewait = time + 5 + random 10;
				}
				else
				{
					if (_dist < 12 && unitPos _zombie != "DOWN" && canStand _zombie) then
					{
						_sound = CLY_noises_chase select floor random count CLY_noises_chase;
						_zombie say3D _sound;
						CLY_z_noisepv = [_zombie, _sound];
						publicVariable "CLY_z_noisepv";
						_noisewait = time + 5 + random 10;
					};
				};
			};
			
			if (!alive _victim || !(_victim in CLY_zombievictims)) then {_zombie setVariable ["victim", objNull, true];};
			
			//Attack
			_attack = false;
			if (!CLY_cutscene && alive _victim) then
			{
				if (_vehicle == _victim) then
				{
					_altdiff = (getPosASL _vehicle select 2) - (getPosASL _zombie select 2);
					if (_altdiff < 1.5 && _altdiff > - 1) then
					{
						if ((_zombie modelToWorld (_zombie selectionPosition "launcher") distance _vehicle) min _dist < CLY_zombieattackdist) then
						{
							if (getPosATL _victim select 2 < 0.01) then
							{
								if (getPosATL _zombie select 2 < 0.01) then
								{
									_attack = true;
								};
							};
							if (!_attack) then
							{
								if !(lineIntersects [eyePos _zombie, eyePos _victim]) then
								{
									_attack = true;
								}
								else
								{
									if !(lineIntersects [eyePos _zombie, getPosASL _victim]) then
									{
										_attack = true;
									}
									else
									{
										if (!(_victim isKindOf "Animal") && !(lineIntersects [eyePos _zombie, [getPosASL _victim select 0, getPosASL _victim select 1, (getPosASL _victim select 2) + (_victim selectionPosition "launcher" select 2)]])) then
										{
											_attack = true;
										};
									};
								};
							};
						};
					};
				}
				else
				{
					if (_dist < 5) then
					{
						_attack = true;
					};
				};
			};
			if (_attack) then
			{
				_anim = if (_zombie selectionPosition "launcher" select 2 < 0.5372) then {"awopppnemstpsgthwnondnon_end";} else {"awoppercmstpsgthwnondnon_end";};
				_noises = CLY_noises_attack;
				_sound = _noises select floor random count _noises;
				_object = "logic" createVehicleLocal [0, 0, 0];
				_object attachTo [_zombie, [0, 0, 1.5]];
				_object say3D _sound;
				_object spawn {sleep 2;deleteVehicle _this};
				_zombie switchMove _anim;
				CLY_z_attackpv = [_zombie, _sound, _anim];
				publicVariable "CLY_z_attackpv";
				_zombie setVectorDir [(getPosATL _vehicle select 0) - (getPosATL _zombie select 0), (getPosATL _vehicle select 1) - (getPosATL _zombie select 1), 0];
				
				_claw = 1;
				if (damage _victim > 0.28) then {_claw = 2;};
				if (damage _victim > 0.59) then {_claw = 3;};
				
				if (_vehicle == _victim) then
				{
					_sound = if (_victim isKindOf "Animal") then {if (typeOf _victim in ["Fin", "Pastor"]) then {CLY_noises_yelp select floor random count CLY_noises_yelp;} else {"";}} else {CLY_noises_scream select floor random count CLY_noises_scream;};
					if (_sound != "") then {
						_object = "logic" createVehicleLocal [0, 0, 0];
						_object attachTo [_victim, [0, 0, 1.5]];
						_object say3D _sound;
						_object spawn {sleep 5;deleteVehicle _this;};
					};
					[_victim, _claw] call CLY_z_claw;
					CLY_z_victimpv = [_victim, _sound, _claw];
					publicVariable "CLY_z_victimpv";
					_victim setDamage (damage _victim + 0.31);
				}
				else
				{
					_damage = damage _vehicle + 2 / getNumber (configFile / "CfgVehicles" / (typeOf _vehicle) / "armor");
					if (_damage <= 0.99) then
					{
						_vehicle setDamage _damage;
					}
					else
					{
						_vehicle setDamage 0.99;
						{_x action ["Eject", _vehicle];} forEach crew _vehicle;
					};
				};
				sleep 1.5;
			};
			
			_newmovedist = CLY_zombieattackdist * _dist * 0.2;
			if (_newmovedist < CLY_zombieattackdist) then {_newmovedist = CLY_zombieattackdist;};
			
			sleep 1;
			
			_vehicle = vehicle _victim;
			_dist = _zombie distance _vehicle;
			
			//Gradual check of chase conditions
			_chase = false;
			if (alive _zombie && !isNull (_zombie getVariable "victim")) then
			{
				if (_vehicle distance _movepos < _newmovedist) then
				{
					if (_zombie getVariable "horde" || _dist < CLY_chasegiveupdist) then
					{
						_chase = true;
					};
				};
			};
		};
	};
};

if (_zombie getVariable "victim" == _zombie) then {deleteVehicle _zombie;};