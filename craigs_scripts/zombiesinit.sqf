//Zombie mission init script by Celery
diag_log "Zombie .sqf init executed";
private ["_array","_index","_forEachIndex","_mag","_anim","_guntype","_gun","_muzzles","_muzzle","_damage","_bandages","_magazines","_weapons","_items","_newmagazines","_group"];


//Wait for JIP to load
waitUntil {(isDedicated) or (!isNull player)};

diag_log "Zombie .sqf init started";
if (CVG_Debug == 2) then {
    player sidechat "loading celery scripts";
    CLY_debug=true;
}else{
    CLY_debug = false;
};



//Random zombie classname
CLY_randomzombie =
{
	_zombieclass = "";
	_selected = false;
	while {!_selected} do
	{
		_zombieclass = CLY_zombieclasses select floor random count CLY_zombieclasses;
		while {typeName _zombieclass == "ARRAY"} do
		{
			_zombieclass = _zombieclass select floor random count _zombieclass;
		};
		if (isClass (configFile / "CfgVehicles" / _zombieclass)) then
		{
			_selected = true;
		};
	};
	_zombieclass;
};

//Random armored zombie classname
CLY_randomarmoredzombie =
{
	_zombieclass = "";
	_selected = false;
	while {!_selected} do
	{
		_zombieclass = CLY_armoredzombieclasses select floor random count CLY_armoredzombieclasses;
		while {typeName _zombieclass == "ARRAY"} do
		{
			_zombieclass = _zombieclass select floor random count _zombieclass;
		};
		if (isClass (configFile / "CfgVehicles" / _zombieclass)) then
		{
			_selected = true;
		};
	};
	_zombieclass;
};
CLY_zombiehandledamage =
{
	_zombie = _this;
	_zombietype = _zombie getVariable "zombietype";
	_armored = _zombietype in ["armored", "slow armored"] || typeOf _zombie in CLY_armoredzombieclasses;
	if (!_armored) then
	{
		if (_zombietype != "walker") then
		{
			//Normal
			_zombie addEventHandler
			[
				"HandleDamage", 
				{
					_unit = _this select 0;
					_selection = _this select 1;
					_damage = _this select 2;
					if (count (_unit getVariable ["selections", []]) == 0) then
					{
						_unit setVariable ["selections", []];
						_unit setVariable ["gethit", []];
					};
					_selections = _unit getVariable ["selections", []];
					_gethit = _unit getVariable ["gethit", []];
					if !(_selection in _selections) then
					{
						_selections set [count _selections, _selection];
						_gethit set [count _gethit, 0];
					};
					_i = _selections find _selection;
					_olddamage = _gethit select _i;
					_newdamage = _damage - _olddamage;
					switch (_this select 1) do
					{
						case "" : {_damage = _olddamage + _newdamage * 0.05;};
						case "head_hit" : {_damage = _olddamage + _newdamage * 0.3;};
						case "body" : {_damage = _olddamage + _newdamage * 0.1;};
						case "legs" : {_damage = 0.1;};
					};
					if (_this select 3 != _unit) then
					{
						_unit setVariable ["victim", _this select 3];
					};
					_gethit set [_i, _damage];
					_damage;
				}
			];
		}
		else
		{
			//Walker
			_zombie addEventHandler
			[
				"HandleDamage", 
				{
					_unit = _this select 0;
					_selection = _this select 1;
					_damage = _this select 2;
					if (count (_unit getVariable ["selections", []]) == 0) then
					{
						_unit setVariable ["selections", []];
						_unit setVariable ["gethit", []];
					};
					_selections = _unit getVariable ["selections", []];
					_gethit = _unit getVariable ["gethit", []];
					if !(_selection in _selections) then
					{
						_selections set [count _selections, _selection];
						_gethit set [count _gethit, 0];
					};
					_i = _selections find _selection;
					_olddamage = _gethit select _i;
					_newdamage = _damage - _olddamage;
					switch (_this select 1) do
					{
						case "" : {_damage = _olddamage + _newdamage * 0.05;};
						case "head_hit" : {_damage = _olddamage + _newdamage * 0.3;};
						case "body" : {_damage = _olddamage + _newdamage * 0.1;};
						case "legs" : {_damage = 0.1;};
					};
					if (_this select 3 != _unit) then
					{
						_unit setVariable ["victim", _this select 3];
					};
					_gethit set [_i, _damage];
					_damage;
				}
			];
		};
	}
	else
	{
		//Armored
		_zombie addEventHandler
		[
			"HandleDamage", 
			{
				_unit = _this select 0;
				_selection = _this select 1;
				_damage = _this select 2;
				if (count (_unit getVariable ["selections", []]) == 0) then
				{
					_unit setVariable ["selections", []];
					_unit setVariable ["gethit", []];
				};
				_selections = _unit getVariable ["selections", []];
				_gethit = _unit getVariable ["gethit", []];
				if !(_selection in _selections) then
				{
					_selections set [count _selections, _selection];
					_gethit set [count _gethit, 0];
				};
				_i = _selections find _selection;
				_olddamage = _gethit select _i;
				_newdamage = _damage - _olddamage;
				switch (_this select 1) do
				{
					case "" : {_damage = _olddamage + _newdamage * 0.05;};
					case "head_hit" : {_damage = _olddamage + _newdamage * 0.3;};
					case "body" : {_damage = _olddamage + _newdamage * 0.1;};
					case "legs" : {_damage = 0.1;};
				};
				if (_this select 3 != _unit) then
				{
					_unit setVariable ["victim", _this select 3];
				};
				_gethit set [_i, _damage];
				_damage;
			}
		];
	};
};

//Disable saving
enableSaving [true,true];

//Weather
setWind [2,-2,true];

//CLY Remove Dead
[45,0] execVM "cly_removedead.sqf";
player setVariable ["CLY_removedead",false,true];


/////No dedicated after this/////
if (isDedicated) exitWith {};
/////No dedicated after this/////



//Put player in proper start position
[] spawn {
    sleep 1;
    //JIP
    player enableSimulation true;
    player setVelocity [0,0,0];
    player setPos [getPos player select 0,getPos player select 1,(getPosATL player select 2)-(getPos player select 2)];
    if (!isNil "CLY_jipresumepos" and !(typeOf player in CLY_deadcharacters)) then {
        player setPosATL CLY_jipresumepos;
    };
    if !(typeOf player in CLY_deadcharacters) then {
        sleep 0.5;
        cutText ["","BLACK IN",2];
        player setVariable ["CLY_addweapon",nil];
        player setVariable ["CLY_playerstates",true,true];
        sleep 15;
        player setVariable ["victim",nil,true];
        
    } else {
        player setPos [(getMarkerPos "respawn_civilian" select 0)-20+random 40,(getMarkerPos "respawn_civilian" select 1)-20+random 40,0];
    };
};
if (CVG_Respawn == 0) then {
    //Trigger spectator script when player is dead or already dead
    [] spawn {
        waitUntil {!alive player or typeOf player in CLY_deadcharacters};
        [[],true] execVM "cly_spectate.sqf";
        if !(typeOf player in CLY_deadcharacters) then {
            CLY_deadcharacters set [count CLY_deadcharacters,typeOf player];
            publicVariable "CLY_deadcharacters";
        } else {
            titleText ["\n\nYour character is already dead.\nIf you wish to play, try another slot.","PLAIN",0.5];
        };
    };
};


//---Accuracy boost---
//Activate accuracy boost
//Designed and recommended only for sidearms with a high spread.
CLY_accuracy = true;

//Minimum dispersion value in config before a handgun receives accuracy boost
CLY_mindispersion = 0.002;

//Weapons that receive an accuracy boost regardless of type and dispersion
CLY_accuracyarray = [];

//Load the script
CLY_accuracyscript = compile preProcessFile "cly_accuracy.sqf";

//Event handler
player addEventHandler ["Fired", {_this call CLY_accuracyscript}];

//Update weapon direction
if (CLY_accuracy) then
{
	[] spawn {
		_lasttime = 0;
		while {true} do
		{
			sleep 0.02;
			CLY_weapondir = [player weaponDirection currentWeapon player, time, _lasttime];
			_lasttime = time;
		};
	};
};
//////////////////////

if (CVG_Mochilla != 1) then {
    //Disable ACE stamina
    ACE_NoStaminaEffects=true;
    publicVariable "ACE_NoStaminaEffects";
};
//Leave group


"colorCorrections" ppEffectEnable true;
"colorCorrections" ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [0.3, 0.3, 0.3, 1.3], [1, 1, 1, 0]];
"colorCorrections" ppEffectCommit 0;

//Friendly fire damage modifier
if (CLY_friendlyfire!=1) then {
    player addEventHandler ["HandleDamage",{if (isPlayer (_this select 3) and (_this select 3)!=(_this select 0)) then {damage (_this select 0)+(_this select 2)*(CLY_friendlyfire*0.1)} else {_this select 2}}];
};

//Zombie face update for clients
[] exec "zombie_scripts\cly_z_textures.sqs";

//GPS markers
[] exec "cly_gps.sqs";

//CLY Jukebox

//Claw script
CLY_z_claw =
{
	_victim = _this select 0;
	_claw = _this select 1;
	if (player getVariable ["spectating", player] == _victim) then
	{
		addCamShake [20, 0.3, 20];
		4 cutRsc [format ["claw%1", _claw], "PLAIN"];
	};
};

//Claw mark HUD
[] execVM "zombie_scripts\cly_hud.sqf";

//Public variable event handlers
"CLY_z_noisepv" addPublicVariableEventHandler
{
	_var = _this select 1;
	_zombie = _var select 0;
	_zombie say3D (_var select 1);
};
"CLY_z_attackpv" addPublicVariableEventHandler
{
	_var = _this select 1;
	_zombie = _var select 0;
	_sound = _var select 1;
	_anim = if (count _var > 2) then {_var select 2;} else {"";};
	if (_sound != "") then
	{
		_object = "logic" createVehicleLocal [0, 0, 0];
		_object attachTo [_zombie, [0, 0, 1.5]];
		_object say3D _sound;
		_object spawn {sleep 10;deleteVehicle _this};
	};
	if (_anim != "") then {_zombie switchMove _anim;};
};
"CLY_z_victimpv" addPublicVariableEventHandler
{
	_var = _this select 1;
	_victim = _var select 0;
	_sound = _var select 1;
	_claw = _var select 2;
	if (_sound != "") then
	{
		_object = "logic" createVehicleLocal [0, 0, 0];
		_object attachTo [_victim, [0, 0, 1.5]];
		_object say3D _sound;
		_object spawn {sleep 5;deleteVehicle _this};
	};
	if (_claw > 0) then {[_victim, _claw] call CLY_z_claw;};
};
"CLY_z_radiopv" addPublicVariableEventHandler
{
	_unit = if (isNil {player getVariable "spectating"}) then {player;} else {player getVariable "spectating";};
	_var = _this select 1;
	_talker = _var select 0;
	_radio = _var select 1;
	_say = if (count _var > 2) then {_var select 2;} else {"";};
	if (isPlayer _talker) then
	{
		_talker commandRadio _radio;
	}
	else
	{
		if (_unit distance _talker < 40) then
		{
			_talker directSay _radio;
		}
		else
		{
			_talker globalRadio _radio;
		};
	};
	if (_say != "") then {_talker say _say;};
};

sleep 3;

_bandages=CVG_bandages;

//Load player state
if !(typeOf player in CLY_deadcharacters) then {
    _array=[];
    _index=0;
    {
        if (typeOf player in _x) then {_array=_x;_index=_forEachIndex};
    } forEach CLY_playerstates;
    if (count _array>0) then {
        _damage=_array select 2;
        _bandages=_array select 3;
        _magazines=_array select 4;
        _weapons=_array select 5;
        _items=_array select 6;
        
        //2/3 of the original magazines
        _newmagazines=[];
        {
            if !(_x in _newmagazines) then {
                _mag=_x;
                for "_x" from 1 to round (({_x==_mag} count _magazines)*0.66) do {
                    _newmagazines set [count _newmagazines,_mag];
                };
            };
        } forEach _magazines;
        
        
        player setDamage _damage;
        {player addMagazine _x} forEach _newmagazines;
        {player addWeapon _x} forEach _weapons;
        if (count _weapons>0) then {
            _gun=_weapons select 0;
            _muzzles=getArray (configFile/"CfgWeapons"/_gun/"muzzles");
            _muzzle=if !("this" in _muzzles) then {_muzzles select 0} else {_gun};
            player selectWeapon _muzzle;
            if (vehicle player==player) then {
                _anim="";
                _guntype=getNumber (configFile/"CfgWeapons"/_gun/"type");
                if (_guntype in [1,5]) then {_anim="amovpercmstpsraswrfldnon"};
                if (_guntype==2) then {_anim="amovpercmstpsraswpstdnon"};
                if (_guntype==4) then {_anim="amovpercmstpsraswlnrdnon"};
                if (_anim!="") then {player switchMove _anim};
            };
        };
        {player addWeapon _x} forEach _items;
        CLY_playerstates set [_index,[player,typeOf player,_damage,_bandages,_newmagazines,_weapons,_items]];
        publicVariable "CLY_playerstates";
    };
};

//CLY Heal continued
[player,0.1,0,_bandages,false] execVM "zombie_scripts\cly_heal.sqf";

//CLY Spectate cameraView script (spectator sees aiming mode when player aims)
[] spawn {
    player setVariable ["cameraview","INTERNAL",true];
    while {true} do {
        if (alive player and cameraView!=(player getVariable "cameraview")) then {player setVariable ["cameraview",cameraView,true]};
        sleep 0.1;
    };
};

//Loot sparkle
if (!isDedicated) then {
    [] spawn {
        
        private ["_x","_unit","_zombies"];
        while {true} do {
            sleep 3;
            waitUntil {!CLY_cutscene};
            _zombies=[];
            {
                if (_x distance player<50 and (count magazines _x>0 or count weapons _x>0 or count items _x>0 or count (getPosATL _x nearObjects ["logic",0.1])>0)) then {
                    _zombies set [count _zombies,_x];
                };
            } forEach allDead;
            {
                [_x] spawn {
                    
                    private ["_zombie"];
                    _zombie=_this select 0;
                    for "_x" from 1 to 10 do {
                        if (count magazines _zombie>0 or count weapons _zombie>0 or count items _zombie>0) then {
                            drop ["\ca\data\koulesvetlo","","Billboard",3,3,[-0.25+random 0.5,-0.25+random 0.5,0.1],[0,0,0],0,1.26,1,0,[0,0.015,0.01,0.005,0],[[1,1,0.5,1]],[0],0,0,"","",_zombie];
                        };
                        if (count (getPosATL _zombie nearObjects ["logic",0.1])>0) then {
                            drop ["\ca\data\koulesvetlo","","Billboard",3,3,[-0.25+random 0.5,-0.25+random 0.5,0.1],[0,0,0],0,1.26,1,0,[0,0.015,0.01,0.005,0],[[1,0.25,0.25,1]],[0],0,0,"","",_zombie];
                        };
                        sleep 0.1;
                    };
                };
            } forEach _zombies;
        };
    };
};

//Set players captive - prevents zombies from fleeing in MP
player setCaptive true;

if (CVG_Debug == 2) then {
    player sidechat "celery scripts loaded";
};

diag_log "Zombie .sqf init finished";
