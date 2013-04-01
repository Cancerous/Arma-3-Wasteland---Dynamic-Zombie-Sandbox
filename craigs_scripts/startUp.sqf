/*
startUp.sqf
Author: Craig Vander Galien feat. M&M
Email: craigvandergalien@gmail.com
ModDB: http://www.moddb.com/mods/bobtoms-arma2-missions
Armaholic: http://www.armaholic.com/page.php?id=15778
BIS forums: http://forums.bistudio.com/showthread.php?128781-TvT-FFA-CO-40-Dynamic-Zombie-Sandbox

Any questions? Contact me at one of the above places.

Thanks,
Craig
*/
//TODO: fix the cows/nightstalker error
private ["_options","_value","_side","_group","_logic","_type","_weap_type","_cur_type","_display_name","_no_pack","_optics","_weapon","_cfgweapons","_item_type","_marker","_pos","_trig","_building","_xaxis","_yaxis","_working","_allaxiss","_newPos","_townnumber","_town","_townpos","_rad","_cnps","_towns","_playerRespawn","_check2","_check1","_thing","_things","_checkVar","_dist","_dir","_armPos","_centPos","_kindOf","_filter","_res","_veh","_types","_veh_type","_vehicle","_typeNumbers","_cfgvehicles","_turret","_weapons","_magazines","_subturrets","_turrets","_EHkilled"];
//Starts the loading screen that was defined in the description.ext
//StartLoadingScreen["Loading Mission Components","RscLoadScreenCustom"];
/*
This part declares all the variables for the mission. It gets the values from the chosen parameters
*/
private ["_options","_value","_num"];

//progressLoadingScreen 0.1;
// This part, if random was chosen, executes the randomness
if (CVG_timeToSkipTo == 25) then {
	CVG_timeToSkipTo = floor (random 24);
};
if (CVG_playerWeapons == 3) then {
	_options = [1,2];
	_value = floor (random (count _options));
	CVG_playerWeapons= _value;
}; 
if (CVG_playerItems == 3) then {
	_options = [1,2];
	_value = floor (random (count _options));
	CVG_playerItems= _value;
};
if (CVG_maxaggroradius == 9999) then {
	CVG_maxaggroriadius=floor (random 1000);
};
if (CVG_Zdensity == 99) then {
	CVG_Zdensity = floor (random 98);
};
if (CVG_minSpawnDist == 999) then {
	CVG_minSpawnDist = floor (random 100);
};
if (CVG_Weapontype == 7) then {
	CVG_weapontype= floor (random 6);
};
if (chanceNumber == 99) then {
	chanceNumber = floor (random 30);
};
if (CVG_Fuel == 3) then {
	CVG_Fuel = floor (random 1);
};
if (CVG_Weaponcount == 99) then {
	_options = [20,50,75,101];
	_value = floor (random (count _options));
	CVG_Weaponcount= _value;
};
if (CVG_VehicleStatus == 4) then {
	_options = [1,2,3,4];
	_value = floor (random (count _options));
	CVG_VehicleStatus= _value;
};
//delares that  variable assigning is complete, needed in init.sqf
paramsdone = 1;
// if there is no functions module, it creates one
if (isNil "BIS_functions_mainscope") then
{
	_side = createCenter sideLogic;
	_group = createGroup _side;
	_logic = _group createUnit ["FunctionsManager", [0,0,0], [], 0, "NONE"];
};
waitUntil {!isnil "bis_fnc_init"};
//////////////////////////////////
//Section 1 Done!
//progressLoadingScreen 0.2;
//////////////////////////////////
//Towns
_rad=20000;
_cnps = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
townlist= nearestLocations [_cnps, ["nameCity","nameVillage"], _rad];
//this part goes into the cfgWeapons and grabs all the useable weapons and vehicle classnames and puts them into arrays based on type
CVG_Rifles = [];
CVG_scoped = [];
CVG_heavy = [];
CVG_launchers = [];
CVG_pistols = [];
CVG_Explosives = [];
CVG_Binoculars = [];
CVG_SmallItems = [];
{
	_cfgweapons = configFile >> "cfgWeapons";
	_type = 1;
	_item_type = _x;
	switch (_item_type) do {
		case 0: {_type = [1];};//CVG_Rifles
		case 1: {_type = [1];};//scoped CVG_Rifles
		case 2: {_type = [1,5];};//heavy
		case 3: {_type = [4];};//secondary weapon
		case 4: {_type = [2];};//pistol
		case 5: {_type = [0];};//put/throw
		case 6: {_type = [4096];};//BinocularSlot
		case 7: {_type = [131072];};//SmallItems
		default {_type = [1];};
	};
	for "_i" from 0 to (count _cfgweapons)-1 do {
		_weapon = _cfgweapons select _i;
		if (isClass _weapon) then {
			_weap_type = configName(_weapon);
			_cur_type = getNumber(_weapon >> "type");
			_display_name = getText(_weapon >> "displayName");
			_no_pack = getNumber(_weapon >> "ACE_nopack");
			_optics = getText(_weapon >> "ModelOptics");
			if (((((getNumber(_weapon >> "scope")==2)&&(getText(_weapon >> "model")!="")&&(_display_name!=""))||((_item_type==5)&&(getNumber(_weapon >> "scope")>0)))&&(_cur_type in _type)&&(_display_name!=""))
			&&
			((_item_type in [3,4,5,6,7])||((_item_type==0)&&(_no_pack!=1)&&((_optics=="-")))||((_item_type==1)&&(_no_pack!=1)&&((_optics!="-")))||((_item_type==2)&&((_cur_type==5)||((_no_pack==1)&&(_cur_type in _type)))))) then {
				
				if (_item_type == 0) then {
					CVG_Rifles set [(count CVG_Rifles),_weap_type];//CVG_Rifles
				};
				if (_item_type == 1) then {
					CVG_Scoped set [(count CVG_Scoped),_weap_type];//CVG_Scoped
				};
				if (_item_type == 2) then {
					CVG_Heavy set [(count CVG_Heavy),_weap_type];//CVG_Heavy
				};
				if (_item_type == 3) then {
					CVG_Launchers set [(count CVG_Launchers),_weap_type];//CVG_Launchers
				};
				if (_item_type == 4) then {
					CVG_Pistols set [(count CVG_Pistols),_weap_type];//CVG_Pistols
				};
				if (_item_type == 5) then {
					CVG_Explosives set [(count CVG_Explosives),_weap_type];//CVG_Explosives
				};
				if (_item_type == 6) then {
					CVG_Binoculars set [(count CVG_Binoculars),_weap_type];//CVG_Binoculars
				};
				if (_item_type == 7) then {
					CVG_SmallItems set [(count CVG_SmallItems),_weap_type];//CVG_Binoculars
				};
			};
		};
	};
} forEach [0,1,2,3,4,5,6,7];
#define KINDOF_ARRAY(a,b) [##a,##b] call {_veh = _this select 0;_types = _this select 1;_res = false; {if (_veh isKindOf _x) exitwith { _res = true };} forEach _types;_res}
timeAtStart = time;
private ["_kindOf","_filter","_res","_veh","_types","_veh_type","_vehicle","_typeNumbers","_cfgvehicles"];
CVG_statics = [];
CVG_Cars = [];
CVG_trucks = [];
CVG_APCs = [];
CVG_tanks = [];
CVG_Helicopters = [];
CVG_Planes = [];
CVG_Ships = [];
CVG_Men = [];
{
	_veh_type = [];
	_typeNumbers = _x;
	_kindOf = ["tank"];
	_filter = [];
	switch (_typeNumbers) do {
		case 0: {_kindOf = ["staticWeapon"];};
		case 1: {_kindOf = ["car"];_filter = ["truck","Wheeled_APC"];};
		case 2: {_kindOf = ["truck"];};
		case 3: {_kindOf = ["Wheeled_APC","Tracked_APC"];};
		case 4: {_kindOf = ["tank"];_filter = ["Tracked_APC"];};
		case 5: {_kindOf = ["helicopter"];_filter = ["ParachuteBase"];};
		case 6: {_kindOf = ["plane"];_filter = ["ParachuteBase"];};
		case 7: {_kindOf = ["ship"];};
		case 8: {_kindOf = ["man"];};
		default {_kindOf = ["tank"];_filter = [];};
	};
	_cfgvehicles = configFile >> "CfgVehicles";
	for "_i" from 0 to (count _cfgvehicles)-1 do {
		_vehicle = _cfgvehicles select _i;
		if (isClass _vehicle) then {
			_veh_type = configName(_vehicle);
			if ((getNumber(_vehicle >> "scope")==2)and(getText(_vehicle >> "picture")!="")and(KINDOF_ARRAY(_veh_type,_kindOf))and!(KINDOF_ARRAY(_veh_type,_filter))) then {
				
				if (_typeNumbers == 0) then {
					CVG_statics set [(count CVG_statics),_veh_type];//CVG_statics
				};
				if (_typeNumbers == 1) then {
					CVG_Cars set [(count CVG_Cars),_veh_type];//CVG_Cars
				};
				if (_typeNumbers == 2) then {
					CVG_Trucks set [(count CVG_Trucks),_veh_type];//CVG_Trucks
				};
				if (_typeNumbers == 3) then {
					CVG_APCs set [(count CVG_APCs),_veh_type];//CVG_APCs
				};
				if (_typeNumbers == 4) then {
					CVG_Tanks set [(count CVG_Tanks),_veh_type];//CVG_tanks
				};
				if (_typeNumbers == 5) then {
					CVG_Helicopters set [(count CVG_Helicopters),_veh_type];//CVG_Helis
				};
				if (_typeNumbers == 6) then {
					CVG_Planes set [(count CVG_Planes),_veh_type];//CVG_planes
				};
				if (_typeNumbers == 7) then {
					CVG_Ships set [(count CVG_Ships),_veh_type];//CVG_Ships
				};
				if (_typeNumbers == 8) then {
					CVG_Men set [(count CVG_Men),_veh_type];//CVG_men
				};
			};
		};
	};
} forEach [1,2,3,5,7,8];
_pos = [0,0];
 buildings = nearestObjects [_pos, ["house"], 60000];
//progressLoadingScreen 0.3;
gunsComplete = 1;
//ammo cache script
[] execVM "craigs_scripts\AmmoCaches.sqf";
//Some functions
fn_getBuildingPositions = {
	private ["_building","_positions","_i","_next"];

	_building = _this;
	_positions = [];

	// search more positions
	_i = 1;
	while {_i > 0} do
	{
		_next = _building buildingPos _i;
		if (((_next select 0) == 0) && ((_next select 1) == 0) && ((_next select 2) == 0)) then
		{
			_i = 0;
		} else {
			_positions set [(count _positions), _next];
			_i = _i + 1;
		};
	};
	// return positions
	_positions
};

arrayCompare =
{
	private ["_array1","_array2","_i","_return"];
	
	_array1 = _this select 0;
	_array2 = _this select 1;
	
	_return = true;
	if ( (count _array1) != (count _array2) ) then
	{
		_return = false;
	}
	else
	{
		_i = 0;
		while {_i < (count _array1) && _return} do
		{
			if ( (typeName (_array1 select _i)) != (typeName (_array2 select _i)) ) then
			{
				_return = false;
			}
			else
			{
				if (typeName (_array1 select _i) == "ARRAY") then
				{
					if (!([_array1 select _i, _array2 select _i] call arrayCompare)) then
					{
						_return = false;
					};
				}
				else
				{
					if ((_array1 select _i) != (_array2 select _i)) then
					{
						_return = false;
					};
				};
			};
			_i = _i + 1;
		};
	};
	_return
};
///////////////////////////////
CLY_zombieclasses = [];
_civilians = [];
_soldiers = [];
{
	_class = _x;
	if (!(_class isKindOf "woman")) then {
		_soldiers = _soldiers + [_class];
	} else {CVG_men = CVG_men - [_x];};
} forEach CVG_Men;
_civilians = ["C_man_1","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_1_2_F","C_man_1_3_F"];
CLY_zombieclasses = [_civilians]; //CLY_zombieclasses = [[_civilians],[_soldiers]];
diag_log format ["CLY_zombieclasses: %1",CLY_zombieclasses];
////////////////////////////////
////Section 2 Done
//progressLoadingScreen 0.4;
/////////////////////////////////
////// Setup all the weapons

	Switch (CVG_weapontype) do {
		case 1: {
			//allweapons
			CVG_weapons = [];
			CVG_weapons = CVG_rifles;
			CVG_weapons = CVG_weapons + CVG_Scoped;
			CVG_weapons = CVG_weapons + CVG_Heavy;
			CVG_weapons = CVG_weapons + CVG_pistols;
			CVG_weapons = CVG_weapons + CVG_Launchers;
			
		};
		case 2: {
			//Farmer Guns
			CVG_weapons = [];   
			
		};
		case 3: {
			//Blufor Weapons
			CVG_weapons = [];    
			
		};
		case 4: {
			//OpFor Weapons
			CVG_weapons = [];
			  
		};
		case 5: 
		{
			//pistols
			CVG_weapons = CVG_pistols;
		};
		case 6:
		{
		};
		case 8:
		{
			_original_Config = [];
			CVG_weapons = [];
			CVG_weapons = CVG_rifles;
			CVG_weapons = CVG_weapons + CVG_Scoped;
			CVG_weapons = CVG_weapons + CVG_Heavy;
			CVG_weapons = CVG_weapons + CVG_pistols;
			CVG_weapons = CVG_weapons + CVG_Launchers;
			{
				if (_x in _original_Config) then {CVG_Weapons = CVG_Weapons - [_x]};
			} forEach CVG_Weapons
		};
	};
	// progressLoadingScreen 0.5;
	//prepares some functions to run later
	randomWeapons =		 compile preprocessFileLineNumbers "craigs_scripts\randomWeapons.sqf";
	vehicleInfo =		 compile preProcessFileLineNumbers "craigs_scripts\dvs\vehicleinfo.sqf";
	objSpawn = 		compile preProcessFileLineNumbers "craigs_scripts\dvs\ObjectSpawn.sqf";
	WF_FNCT_getRandomSafePos = compile preProcessFileLineNumbers "craigs_scripts\getRandomSafePos.sqf";
if (isServer) then {
   //Spawn loot (added A3, March 10
	[] execVM "tonic\wepConfig.sqf";
	hrn_fnc_loot = compile PreProcessFileLineNumbers "tonic\hrn_loot.sqf";
	//Start HRN_Loot System
	[] spawn hrn_fnc_loot;
	/*
	The Zombie Trigger creating begins. The first section spawns zombie triggers in a grid
	*/
	if (CVG_Zombietowns == 2) then {
		_xaxis = 0;
		_yaxis = 0;
		_working = true;
		while {_working} do {
			_yaxis = _yaxis + 1000;
			if (_yaxis == 20000) then {
				_xaxis = _xaxis + 1000;
				_yaxis = -5000;
			};
			
			_pos = [_xaxis,_yaxis];
			_trig = createTrigger ["EmptyDetector", _pos];
			trigArray = trigArray + [_trig];
			_trig setTriggerArea [500,500,0,true];
			_trig setTriggerActivation ["NONE", "PRESENT", FALSE];
			if (CVG_Horde == 2) then {
				_trig setTriggerStatements ["true", "0=[thisTrigger,-1] execVM 'zombie_scripts\cly_z_generatorhorde.sqf';", ""];
			};
			if (CVG_Horde == 1) then {
				_trig setTriggerStatements ["true", "0=[thisTrigger,-1] execVM 'zombie_scripts\cly_z_generator.sqf';", ""];
			};
			if (CVG_Debug == 2) then {
				_marker=createMarker [format ["mar%1",random 100000],getpos _trig];
				_marker setMarkerType "Dot";
				_marker setMarkerColor "ColorRed";
				_marker setMarkerSize [1,1];
			};
			_allaxiss = _xaxis + _yaxis;
			if (_allaxiss == 40000) then {_working = false;};
		};
	};
	//Spawns some zombies, if zombietowns equals three
	if (CVG_Zombietowns == 3) then {
		_xaxis = 0;
		_yaxis = 0;
		_working = true;
		while {_working} do {
			_yaxis = _yaxis + 1000;
			if (_yaxis == 20000) then {
				_xaxis = _xaxis + 1000;
				_yaxis = -5000;
			};
			_pos = [_xaxis,_yaxis];
			_trig = createTrigger ["EmptyDetector", _pos];
			trigArray = trigArray + [_trig];
			_trig setTriggerArea [500,500,0,true];
			_trig setTriggerActivation ["NONE", "PRESENT", FALSE];
			if (CVG_Horde == 2) then {
				_trig setTriggerStatements ["true", "0=[thisTrigger,-1] execVM 'zombie_scripts\cly_z_generatorhorde.sqf';", ""];
			};
			if (CVG_Horde == 1) then {
				_trig setTriggerStatements ["true", "0=[thisTrigger,-1] execVM 'zombie_scripts\cly_z_generator.sqf';", ""];
			};
			if (CVG_Debug == 2) then {
				_marker=createMarker [format ["mar%1",random 100000],getpos _trig];
				_marker setMarkerType "Dot";
				_marker setMarkerColor "ColorRed";
				_marker setMarkerSize [1,1];
			};
			_allaxiss = _xaxis + _yaxis;
			if (_allaxiss == 40000) then {_working = false;};
		};
	};
	[] spawn {
		while {isServer} do {
		sleep (60 * 30);
			{
				if (!isPlayer _x && !isNil {_x getVariable "zombietype"}) then {
					deleteVehicle _x;
				};
			} forEach AllUnits
		};
	};

	//Checks for fuel
	if (CVG_Fuel == 1) then {
		[] execVM "Craigs_scripts\removeGasStations.sqf";
	};
	
	//Sets time
	Diag_log "Setting Time";
	skipTime CVG_timeToSkipTo;
	diag_Log "Time Set";
   
	///Ends the server part
};
//This part is server and client


// progressLoadingScreen 0.95;
///////////////////////////
//////////////////////////
//Clients!! (and Server)\\
//////////////////////////
///////////////////////
if (!isDedicated) then {
	if (player != player) then
	{
		waitUntil {player == player};
	};
	if (time > 1) then {
		waitUntil {local Player};
	};
	diag_Log "loading clients";
};


//Starts fasttime script
if (CVG_fastTime == 1) then {
	[4] execFSM "craigs_scripts\core_time.fsm";
};


///This block  of code spawns the building destruction. Executes on all clients
if (isServer) then {
if (CVG_CityDestruction == 2) then {
	diag_Log  "loading building destruction";
	_newPos = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
	[_newPos,10000,0,[]] call bis_fnc_destroyCity;
};
};



[] execVM "craigs_scripts\tasks.sqf"; 
	
if (CVG_FoodWater == 1) then {
	[] execVM "tonic\init.sqf";
};

screendone = 1;

//EH

sleep 0.01;//This will stop script until ingame
//After mission started

//View distances
setViewDistance CVG_Viewdist;

if (!isDedicated) then
{
	player execVM "zombie_scripts\cly_z_victim.sqf";
	//[] execVM "craigs_scripts\sirenpoles.sqf";
	if (CVG_ZombieTowns == 4) then {
		[] spawn zedLoop; //[] execVM
	};
};