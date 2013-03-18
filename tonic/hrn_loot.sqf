/*
	Author: Horner
	Description: Code for the loot system
	Heavily modified by Tonic for Wasteland
	Further modified by Craig for Dynamic Zombie Sandbox
*/

// Does not work if you host locally, if you want to host locally just comment this next line out
if (!isServer) exitWith {};

buildingConfig = [
["Land_MilOffices_V1_F",[0,1,2,3,4,6,7]],
["Land_Cargo_Patrol_V1_F",[1]],
["Land_Cargo_House_V1_F",[0]],
["Land_Cargo_HQ_V1_F",[1,4,6,7]],
["Land_Airport_Tower_F",[1,2,5,9,7,14]],
["Land_Cargo_House_V2_F",[0]],
["Land_FuelStation_Shed_F",[0,1,2,3]],
["Land_i_House_Small_03_V1_F",[0,1,1,2,3]],
["Land_u_Addon_02_V1_F",[1,2]],
["Land_FuelStation_Build_F",[0,1]],
["Land_Metal_Shed_F",[2,5]],
["Land_i_House_Big_01_V1_F",[0,1,2,4,5]],
["Land_i_House_Big_02_V1_F",[0,1,2,3,4,5,7,8]],
["Land_i_Shop_01_V1_F",[0,1,3,4,6,7,8]],
["Land_i_Shop_02_V1_F",[0,1,2,3,8,9]],
["Land_i_Stone_HouseBig_V1_F",[0,3,4,5]],
["Land_i_House_Small_01_V2_F",[0,1]],
["Land_i_Garage_V1_F",[0,2]],
["Land_i_Addon_03mid_V1_F",[0,2]],
["Land_Unfinished_Building_01_F",[0,2,5,7,8,9]],
["Land_LightHouse_F",[0,1,2,3]],
["Land_i_Stone_Shed_V1_F",[0,1]],
["Land_Slum_House02_F",[0]],
["Land_u_House_Small_01_V1_F",[0,1,4]],
["Land_Radar_F",[1,3,5]]
];

loot_militaryB = [
"Land_MilOffices_V1_F",
"Land_Radar_F",
"Land_Airport_Tower_F",
"Land_Cargo_Patrol_V1_F",
"Land_Cargo_HQ_V1_F"
];

fnc_index = {
private["_find","_limit","_select","_array","_return"];
_find = _this select 0;
_array = _this select 1;

_limit = (count _array)-1;
for "_i" from 0 to _limit do
{
    _select = _array select _i;
    if((_find in _select) && (isNil {_return})) then
    {
        _return = _i;
    };
};

if(isNil {_return}) then {_return = -1;};
_return;
};

// Alterable Variables - You may alter the values of these to fit your needs

hrn_lootDebug = false;					// Determines whether or not debug information will be on
hrn_initialLootSpawns = 600;				// Initial amount of loot spawns
hrn_lootSpawnPeriod = 300;				// Sleep period between loot spawns

// Do not edit anything below here

hrn_worldCenter = (getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition"));

hrn_fnc_setLoot =
{
//diag_log "setting started";
	private["_holder","_random","_arr","_subArr","_wep","_mag","_modifiers","_magAmount","_rnd","_obj","_m","_tmp","_pick"];
	_holder = _this select 0;
	_type = _this select 1;
	_random = round (random 100);
	if(_type in loot_militaryB) then
	{
		if(_random < 50) then
		{
			_random = round(random 100);
			if(_random < 50) then
			{
				_arr = wl_attachments;
				_tmp = "item";
			}
		else
			{
				_arr = wl_weapons;
				_tmp = "gun";
			};
		}
			else
		{
			_random = round(random 100);
			if(_random < 50) then
			{
				_arr = wl_attachments;
				_tmp = "item";
			}
		else
			{
				_arr = wl_weapons;
				_tmp = "gun";
			};
		};

		_random = round(random 100);
		if(_random < 38) then
		{_pick - wl_miscSpawn call BIS_fnc_selectRandom;};
		if(_random < 30) then 
		{_pick = wl_throw call BIS_fnc_selectRandom;};
		if(_random < 15) then
		{_pick = wl_mines call BIS_fnc_selectRandom;};
		

		if(!isNil {_pick}) then
		{
			_holder addMagazineCargoGlobal [_pick,1];
		};

		if(_tmp == "item") then
		{
			_subArr = _arr call BIS_fnc_selectRandom;
			_holder addItemCargoGlobal [_subArr,1];
		}
	else
		{
		_subArr = _arr select (floor (random (count _arr)));
		_wep = _subArr select 0;
		_mag = _subArr select 1;
		_modifiers = _subArr select 2;
		_magAmount = round ((random (_modifiers select 1)) + (_modifiers select 0));
		if (_wep != "") then
		{
			_holder addWeaponCargoGlobal [_wep, 1];
		};
		if (_mag != "" && _magAmount > 0) then
		{
			_holder addMagazineCargoGlobal [_mag, _magAmount];
		};
		};
	}	
		else
	{
		
		_arr = hrn_commonWepArray;
		if ((_random >= 1) && (_random < 40)) then
		{
			_rnd = Items_WL call BIS_fnc_selectRandom;
			/*switch (_rnd) do
			{
				case "Land_Sack_F": {_obj = _rnd createVehicle (getPos _holder); _obj setPos (getPos _holder);};
				case "Land_BarrelWater_F": {_obj = _rnd createVehicle (getPos _holder); _obj setPos (getPos _holder); _obj setVariable["water",20,true];};
				case "Land_CanisterPlastic_F": {_obj = _rnd createVehicle (getPos _holder); _obj setPos (getPos _holder);};
			};
		*/
			_arr = [];
		};	
		if (_random >= 55) then
		{
			_arr = wl_clothes;
			_tmp = "item";
		};
		if (_random >= 65) then
		{
			_arr = wl_milClothes;
			_tmp = "item";
		};
		if (_random >= 76) then
		{
			_arr = wl_attachments;
			_tmp = "item";
		};
		if (_random >= 90) then
		{
			_arr = wl_weapons;
			_tmp = "gun";
		};
	
		if(count _arr == 0) exitWith {};
		if(_tmp == "item") then
		{
			_subArr = _arr call BIS_fnc_selectRandom;
			_holder addItemCargoGlobal [_subArr,1];
		}
	else
		{
		_subArr = _arr select (floor (random (count _arr)));
		_wep = _subArr select 0;
		_mag = _subArr select 1;
		_modifiers = _subArr select 2;
		_magAmount = round ((random (_modifiers select 1)) + (_modifiers select 0));
		if (_wep != "") then
		{
			_holder addWeaponCargoGlobal [_wep, 1];
		};
		if (_mag != "" && _magAmount > 0) then
		{
			_holder addMagazineCargoGlobal [_mag, _magAmount];
		};
		};
	};
};

hrn_fnc_spawnLoot =
{
	diag_log "spawning loot";
	private["_building","_type","_index","_pos","_h","_buildings","_rnd","_nearHolders","_wepHolder","_sel","_rnd2"];
	_buildings = buildings;
	{
	//diag_log "spawning started2";
		_building = _x;
		_type = typeOf _x;
	
		_index = [_type,buildingConfig] call fnc_index;
		if(_index != -1) then
		{
			//diag_log "spawning started3";
			_sel = ((buildingConfig select _index) select 1);
			
			//Military Loot
			if(_type in loot_militaryB) then
			{
				//diag_log "spawning started4";
				{
					//Let's play dice!
					_rnd = round(random (count _sel));
					_rnd2 = round(random (count _sel));
					if(_rnd >= _rnd2) then
					{
						_pos =  _building buildingPos _x;
						_nearHolders = nearestObjects [_pos, ["GroundWeaponHolder"], 1];
						if(count _nearHolders < 1) then
						{
							_wepHolder = "GroundWeaponHolder" createVehicle _pos;
							_wepHolder setPos _pos;
							[_wepHolder,_type] spawn hrn_fnc_setLoot;
						};
					};
				} foreach _sel;
			}
				else
			{
				//diag_log "spawning started5";
				{
					//Let's play dice!
					_rnd = round(random 100);
					if(_rnd < 50) then
					{
						_pos =  _building buildingPos _x;
						_nearHolders = nearestObjects [_pos, ["GroundWeaponHolder"], 1];
						if(count _nearHolders < 1) then
						{
							_wepHolder = "GroundWeaponHolder" createVehicle _pos;
							_wepHolder setPos _pos;
							[_wepHolder,_type] spawn hrn_fnc_setLoot;
						};
					};
				} foreach _sel;
			};
		};
	} foreach _buildings;
};

/*
hrn_fnc_spawnLoot =
{
lootNum = 0;
	private["_a","_pos","_wepHolder","_mrk","_nearHolders","_rnd"];
	{
		_pos = _x;
		_nearHolders = nearestObjects [_pos, ["weaponholder"], 1];
		if (count _nearHolders < 1) then
		{
			_wepHolder = "GroundGroundGroundGroundGroundGroundWeaponHolder" createVehicle _pos;
			_wepHolder setPos [_pos select 0, _pos select 1, _pos select 2];
		} else {
			_wepHolder = _nearHolders select 0;
		};
		_rnd = round(random 100);
		if(_rnd < 30) then
		{
			_loot = [_wepHolder] spawn hrn_fnc_setLoot;
			if(lootNum > 3000) exitWith {};
			lootNum = lootNum + 1;
		};
	} foreach hrn_allPositionsArray;
};
*/

[] call hrn_fnc_spawnLoot;
