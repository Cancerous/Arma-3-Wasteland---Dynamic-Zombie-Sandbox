//	@file Version: 1.0
//	@file Name: onKilled.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:


_player = (_this select 0) select 0;
_killer = (_this select 0) select 1;
if(isnil {_player getVariable "cmoney"}) then {_player setVariable["cmoney",0,true];};

PlayerCDeath = [_player];
publicVariable "PlayerCDeath";
if (isServer) then {
	_id = PlayerCDeath spawn serverPlayerDied; 
};

if(!local _player) exitwith {};

if((_player != _killer) && (vehicle _player != vehicle _killer) && (playerSide == side _killer) && (str(playerSide) in ["WEST", "EAST"])) then {
	pvar_PlayerTeamKiller = objNull;
	if(_killer isKindOf "CAManBase") then {
		pvar_PlayerTeamKiller = _killer;
	} else {
		_veh = (_killer);
		_trts = configFile >> "CfgVehicles" >> typeof _veh >> "turrets";
		_paths = [[-1]];
		if (count _trts > 0) then {
			for "_i" from 0 to (count _trts - 1) do {
				_trt = _trts select _i;
				_trts2 = _trt >> "turrets";
				_paths = _paths + [[_i]];
				for "_j" from 0 to (count _trts2 - 1) do {
					_trt2 = _trts2 select _j;
					_paths = _paths + [[_i, _j]];
				};
			};
		};
		_ignore = ["SmokeLauncher", "FlareLauncher", "CMFlareLauncher", "CarHorn", "BikeHorn", "TruckHorn", "TruckHorn2", "SportCarHorn", "MiniCarHorn", "Laserdesignator_mounted"];
		_suspects = [];
		{
			_weps = (_veh weaponsTurret _x) - _ignore;
			if(count _weps > 0) then {
				_unt = objNull;
				if(_x select 0 == -1) then {_unt = driver _veh;}
				else {_unt = _veh turretUnit _x;};
				if(!isNull _unt) then {
					_suspects = _suspects + [_unt];
				};
			};
		} forEach _paths;

		if(count _suspects == 1) then {
			pvar_PlayerTeamKiller = _suspects select 0;
		};
	};
};

if(!isNull(pvar_PlayerTeamKiller)) then {
	publicVar_teamkillMessage = pvar_PlayerTeamKiller;
	publicVariable "publicVar_teamkillMessage";
};

private["_a","_b","_c","_d","_e","_f","_m","_player","_killer","_buildings","_h","_pos","_unit","_x","_to_delete"];

_unit = _this select 0;

if (!isNil {_unit getVariable "zombietype"}) then {
	if ((count magazines _unit) > 0) then {
		_h=getPosATL _unit nearObjects ["logic",0.1];
		if (count _h>0) then {deleteVehicle (_h select 0)};
		_pos = getPos _unit;
		_buildings = nearestObjects [_pos, ["house"], 1000];
		{
			usedBuildings = usedBuildings - [_x];
		} forEach _buildings;
		sleep 120;
		hideBody _unit;
		sleep 10;
		deleteVehicle _unit;
	};
};

if ((isNil {_unit getVariable "zombietype"}) && (!(_unit isKindOf "Man"))) then {

	_h=getPosATL _unit nearObjects ["logic",0.1];
	if (count _h>0) then {deleteVehicle (_h select 0)};
	sleep 500;
	deleteVehicle _unit;
};

_to_delete = [];
_to_delete_quick = [];

if((_player getVariable "cmoney") > 0) then {
	_m = "Land_Sack_F" createVehicle (position _player);
	_m setVariable["money", (_player getVariable "cmoney"), true];
	_m setVariable ["owner", "world", true];
	_to_delete = _to_delete + [_m];
};

if((_player getVariable "medkits") > 0) then {
	for "_a" from 1 to (_player getVariable "medkits") do {	
		_m = "CZ_VestPouch_EP1" createVehicle (position _player);
		_to_delete = _to_delete + [_m];
	};
};

if((_player getVariable "repairkits") > 0) then {
	for "_b" from 1 to (_player getVariable "repairkits") do {	
		_m = "Suitcase" createVehicle (position _player);
		_to_delete = _to_delete + [_m];
	};
};

true spawn {
	waitUntil {playerRespawnTime < 2};
	titleText ["", "BLACK OUT", 1];
};