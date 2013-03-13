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

private ["_options","_value","_side","_group","_logic","_type","_weap_type","_cur_type","_display_name","_no_pack","_optics","_weapon","_cfgweapons","_item_type","_marker","_pos","_trig","_building","_xaxis","_yaxis","_working","_allaxiss","_newPos","_townnumber","_town","_townpos","_rad","_cnps","_towns","_playerRespawn","_check2","_check1","_thing","_things","_checkVar","_dist","_dir","_armPos","_centPos","_kindOf","_filter","_res","_veh","_types","_veh_type","_vehicle","_typeNumbers","_cfgvehicles","_turret","_weapons","_magazines","_subturrets","_turrets","_EHkilled"];

//Starts the loading screen that was defined in the description.ext
//StartLoadingScreen["Loading Mission Components","RscLoadScreenCustom"];


/*
This part declares all the variables for the mission. It gets the values from the chosen parameters
*/

private ["_options","_value","_num"];
CLY_friendlyfire=paramsArray select 0;
CLY_terraingrid=paramsArray select 1;
CVG_Debug= (paramsArray select 2);
CVG_timeToSkipTo = (paramsArray select 3);
CVG_CityDestruction= (paramsArray select 4);
CVG_bandages= (paramsArray select 5);
CVG_Fog = (paramsArray select 6);
CVG_Viewdist = (paramsArray select 7);
CVG_Weather = (paramsArray select 8);
gameType = (paramsArray select 9);
CVG_FoodWater = (paramsArray select 10);
CVG_Playerstart = (paramsArray select 11); 
CVG_playerWeapons = (paramsArray select 12); 
CVG_playerItems= (paramsArray select 13); 
CVG_Aminals= (paramsArray select 14); 
CVG_Horde= (paramsArray select 15);
CVG_maxaggroradius = (paramsArray select 16);
CVG_Zdensity = (paramsArray select 17);
CVG_minSpawnDist = (paramsArray select 18);
CVG_weapontype = (paramsArray select 19);
CVG_Zombietowns= (paramsArray select 20);
CVG_taskType = (paramsArray select 21);
CVG_taskOption = (paramsArray select 22);
vehspawntype = (paramsArray select 23);
chanceNumber = (paramsArray select 24);
CVG_Fuel = (paramsArray select 25);
CVG_fastTime = (paramsArray select 26);
CVG_Weaponcount = (paramsArray select 27);
CVG_VehicleStatus = (paramsArray select 28);
CVG_Mochilla = (paramsArray select 29);
CVG_Caches = (paramsArray select 30);
CVG_SideMissions= (paramsArray select 31);
CVG_SideMarkers= (paramsArray select 32);
CVG_Logistics= (paramsArray select 33);
CVG_NVG= (paramsArray select 34);
CVG_E= (paramsArray select 35);
CVG_Helis= (paramsArray select 36);
CVG_TownAttackVehicles= (paramsArray select 38);
CVG_TownAttackBoxes= (paramsArray select 39);

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
                    CVG_Explosives set [(count CVG_Pistols),_weap_type];//CVG_Pistols
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
    _cfgvehicles = configFile >> "cfgVehicles";
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

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
	CLY_zombieclasses = [];
	_civilians = [];
	_soldiers = [];
	{
		_class = _x;
		if (!(_class isKindOf "woman")) then {
			_soldiers = _soldiers + [_class];
		} else {CVG_men = CVG_men - [_x];};
	} forEach CVG_Men;
	_civilians = ["C_man_1","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F"];
	CLY_zombieclasses = [_civilians]; //CLY_zombieclasses = [[_civilians],[_soldiers]];
	diag_log format ["CLY_zombieclasses: %1",CLY_zombieclasses];
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////




if (CVG_Logistics == 1) then {
    objectList = [];
};
	cars = [];
	trucks = [];
	militaryvehs = [];
    switch (vehSpawnType) do
    {
        case 0:
        {
			{
				_vehicle = configFile >> "CfgVehicles" >> _x;
				_weapons =  getArray(_vehicle >> "weapons");
				_turrets= (_vehicle >> "Turrets");
				for "_i" from 0 to (count _turrets)-1 do {
					_turret = _turrets select _i;
					_weapons = _weapons + getArray(_turret >> "weapons");
					_magazines = _magazines + getArray(_turret >> "magazines");
					_subturrets = _turret >> "Turrets";
					for "_j" from 0 to (count _subturrets)-1 do {
						_turret = _subturrets select _j;
						_weapons = _weapons + getArray(_turret >> "weapons");
						_magazines = _magazines + getArray(_turret >> "magazines");
					};
				};
				if ((count _weapons) < 2) then {Cars = cars + [_x]} else {MilitaryVehs = MilitaryVehs + [_x]};
				
			} forEach CVG_Cars;
			{
				_vehicle = configFile >> "CfgVehicles" >> _x;
				_weapons =  getArray(_vehicle >> "weapons");
				_turrets= (_vehicle >> "Turrets");
				for "_i" from 0 to (count _turrets)-1 do {
					_turret = _turrets select _i;
					_weapons = _weapons + getArray(_turret >> "weapons");
					_magazines = _magazines + getArray(_turret >> "magazines");
					_subturrets = _turret >> "Turrets";
					for "_j" from 0 to (count _subturrets)-1 do {
						_turret = _subturrets select _j;
						_weapons = _weapons + getArray(_turret >> "weapons");
						_magazines = _magazines + getArray(_turret >> "magazines");
					};
				};
				if ((count _weapons) < 2) then {trucks = trucks + [_x]} else {MilitaryVehs = MilitaryVehs + [_x]};

			} forEach CVG_Trucks

        };
        case 1:
        {
            cars = CVG_Cars;
        };
        case 2:
        {
            cars = CVG_Trucks;
        };
        case 3:
        {
			{
				_vehicle = configFile >> "CfgVehicles" >> _x;
				_side = getNumber(_vehicle >> "side");
				if ((_side == 1) || (_side == 2) || (_side == 0)) then {cars = cars + [_x];};
			} forEach CVG_Cars;
		};
        case 4:
        {
			cars = CVG_trucks + CVG_cars;
		};
		case 5:
        {
			cars = CVG_trucks + CVG_cars;
			_standard_Vehicles = [];
			
			{
				if (_x in _standard_Vehicles) then {cars = cars - [_x]};
			} forEach cars;
		};
    };


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
  
//	[] execFSM "craigs_scripts\populateIsland.fsm";
//	waitUntil {CVG_vehicleDone};
	//progressLoadingScreen 0.6;
	//waitUntil {CVG_objectDone};
	//progressLoadingScreen 0.7;
	//waitUntil {CVG_triggerDone};
    //progressLoadingScreen 0.75;
	//waitUntil {CVG_boatDone};
	//progressLoadingScreen 0.77;
//	waitUntil {CVG_heliDone};
	//progressLoadingScreen 0.8;

	
	//populateIsland = compile preProcessFileLineNumbers "craigs_scripts\populateIsland.sqf";
	//[] call populateIsland;
	//waitUntil {CVG_weaponDone};
	//progressLoadingScreen 0.9;

	
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

        //Spawns some more zombies, if zombietowns equals three
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
    if (CVG_CityDestruction == 2) then {
		diag_Log  "loading building destruction";
        _newPos = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
        [_newPos,10000,0,[]] call bis_fnc_destroyCity;
    };

    //Moves loading screen some more, this probably won't show up, but it's more for aesthetics in the code
   // progressLoadingScreen 0.97;
 
/* 
    All of this chooses where the player should spawn at start. The first set, playerstart 50, puts the player in a random town. 
    The second, 100, puts the player in a random position outside of a town
    The third, puts the player at the center position with all other players

    diag_Log "Picking Location";
    _towns= townlist;
    diag_log format ["%1",townlist];
    if (CVG_Playerstart == 50) then {
        if ((count _towns) != 0) then {
            _townnumber = floor (random (count _towns));
            _town = _towns select _townnumber;
            _townpos = (position _town);
            _group = createGroup sideLogic;
            _logic = _group createUnit ["Logic",_townpos, [], 100, "NONE"];   
            _newPos = position _logic;
			if ((_newPos select 0) != 0) then {
            player setpos _newPos;
			} else {
			player setpos _townPos
			};
            diag_Log format ["location chosen, %1",_town];
			
        }
        else
        {
            if ((count buildings) != 0) then {
                _building = (round(random(count buildings)));
                _newpos = position (buildings select _building);
                _newpos = [_newPos,0,50,1,0,20,0] call BIS_fnc_findSafePos;
                player setpos _newpos;
            }
            else
            {
                _things = nearestObjects [player, [], 200000];
                if ((count _things) != 0) then {
                    _thing = (round(random(count _things)));
                    _newpos = position (_things select _thing);
                    player setpos _newpos;
                }
                else
                {
                    _newpos = [(random 1000),(random 1000)];
                    player setpos _newpos;
                };
            };
        };
		deleteVehicle _logic;	
		diag_Log format ["location chosen, %1",_newPos];
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
        player setpos _pos;
        diag_Log format ["location chosen, %1",_townpos];
    };
 
 
    if (CVG_playerstart == 150) then {
        if (isServer) then {
				if (count _towns != 0) then {
				_townnumber = floor (random (count _towns));
				_town = _towns select _townnumber;
				newPos = (position _town);
			}
			else
			{
				if ((count buildings) != 0) then {
					_building = (round(random(count buildings)));
					_newpos = position (buildings select _building);
					newPos = [_newPos,0,50,1,0,20,0] call BIS_fnc_findSafePos;
				}
				else
				{
					_things = nearestObjects [player, [], 200000];
					if ((count _things) != 0) then {
						_thing = (round(random(count _things)));
						newPos = position (_things select _thing);
					}
					else
					{
						newPos = [(random 1000),(random 1000),0];
					};
				};
			};
		publicVariable "newPos";
        };
		waitUntil {!(isNil "newPos")};
		player setpos newPos;
        diag_Log format ["location chosen, %1",_newPos];
		};
*/
		//endLoadingScreen;
		screendone = 1;
		
/*	//Put code for class switch dialog here
	if (!isDedicated) then {
		waituntil {!(IsNull (findDisplay 46))};
		createDialog "BuyDialog";
		ctrlSetText [1001, "Skins"];
		ctrlSetText [1701, "Put on"];
		buttonSetAction [1701, "playerChoice = 1"];
		buttonSetAction [1700, "playerChoice = 2"];
		waitUntil {!isNil "CVG_men"};
		{
			_vehicle = configFile >> "CfgVehicles" >> _x;
			_text= getText(_vehicle >> "displayName");
			_index = lbAdd [1500, _text];
			_veh_type = configName(_vehicle);
			lbSetData [1500,_index,_veh_type];
		} forEach CVG_Men;
		waitUntil {(!isNil "playerChoice") || (!dialog)};
		
		_index = lbCurSel 1500;
		_class = lbData [1500,_index];
		closeDialog 0;
		//Clear Player
		if (playerChoice == 1) then {
			_pos = getPosATL player;
			_dir = getDir player;
			_oldUnit = player;
			selectNoPlayer;
			_oldUnit setPosATL [0,0,0];
			
			if (_OldUnit == player) then {
				_oldUnit addEventHandler ["HandleDamage",{false}];
				_oldUnit enableSimulation false;
				_oldUnit disableAI "ANIM";
				_oldUnit disableAI "MOVE";
			} else {
				deleteVehicle _oldUnit;
			};

			//Create New Character
			[player] joinSilent grpNull;
			_group = 	createGroup west;
			_newUnit = _group createUnit [_class,_pos,[],50,"CAN_COLLIDE"];
			diag_log format ["%1",_class];
			_newUnit setDir _dir;
			addSwitchableUnit _newUnit;
			setPlayable _newUnit;
			
			//Move player inside
			selectPlayer _newUnit;
		};
	};
*/
	[] execVM "craigs_scripts\tasks.sqf"; 
	
/*	//Option to set terrain detail at start
if (isMultiplayer) then
{
	if (!isDedicated) then
	{
		[] spawn
		{
			sleep 1;
			if (CLY_terraingrid == 0) then
			{
				_structure = "<t font = 'EtelkaMonospaceProBold' size = '0.8' color = '#885555ff'>";
				CLY_terrainaction0 = player addAction [_structure + "Clutter distance OK", "cly_terraingrid.sqs", 0, 2.5, true, true, "", ""];
				CLY_terrainaction1 = player addAction [_structure + "Clutter distance: no clutter", "cly_terraingrid.sqs", 50, 2.5, true, false, "", ""];
				CLY_terrainaction2 = player addAction [_structure + "Clutter distance: low", "cly_terraingrid.sqs", 25, 2.5, true, false, "", ""];
				CLY_terrainaction3 = player addAction [_structure + "Clutter distance: medium", "cly_terraingrid.sqs", 12.5, 2.5, true, false, "", ""];
				CLY_terrainaction4 = player addAction [_structure + "Clutter distance: high", "cly_terraingrid.sqs", 6.25, 2.5, true, false, "", ""];
				CLY_terrainaction5 = player addAction [_structure + "Clutter distance: very high", "cly_terraingrid.sqs", 3.125, 2.5, true, false, "", ""];
				CLY_terrainconfirmed = false;
				CLY_terrainlastchanged = time;
				waitUntil {time - CLY_terrainlastchanged > 60};
				if (!CLY_terrainconfirmed) then
				{
					[0, 0, 0, 0] exec "cly_terraingrid.sqs";
				};
			}
			else
			{
				if (CLY_terraingrid > 0) then {setTerrainGrid (CLY_terraingrid * 0.001);};
			};
		};
	}
	else
	{
		setTerrainGrid 50;
	};
};
*/
	
	if (CVG_FoodWater == 1) then {
		[] execVM "tonic\init.sqf";
	};
/*
    //Should the player have weapons?
    if (CVG_playerWeapons == 1) then {
		diag_Log "picking starting weapon";
        removeAllWeapons player;
        [player] execVM "craigs_scripts\randomUnitWeapons.sqf";
    };

       
    if (CVG_playerWeapons == 2) then 
    {
        removeAllWeapons player;
    };

    //Should the player have a map?? 
    if (CVG_playerItems == 2) then {player removeWeapon "ItemMap"};
*/	
    //Sets up respawn
    _playerRespawn = player addMPEventHandler ["MPRespawn", {Null = _this execVM "craigs_scripts\playerRestart.sqf";}]; 
    
	//EH
	_EHkilled = player addEventHandler ["killed", {_this execVM "craigs_scripts\onDeath.sqf"}];	
    

    sleep 0.01;//This will stop script until ingame
    //After mission started

    
    //Weather
    switch (CVG_Weather) do {
        case 1:
        {0 setFog 0;
        0 setOvercast 0;};
        case 2: 
        {
            0 setFog 0;
            0 setOvercast 1;
        };
        case 3: 
        {
            0 setFog 0.5;
            0 setOvercast 0.5;
        };
        case 4: 
        {
            0 setFog 1;
            0 setOvercast 1;
        };
        case 5:
        {
        	if (isServer) then 
        	{
        		fogNumber = (random 1);
        		overcastNumber = (random 1);
        		publicVariable "fogNumber";
        		publicVariable "overcastNumber";
        	};
        	waitUntil {(!(isNil "fogNumber")) && (!(isNil "overcastNumber"))};
        	0 setFog fogNumber;
        	0 setOvercast overcastNumber;
        };
        
    };
    
    //View distances
    setViewDistance CVG_Viewdist;
    //Fog
    if (CVG_fog == 1) then {null=[player,100,11,30,3,7,-0.3,0.1,0.5,1,1,1,13,12,15,false,2,2.1,0.1,1,1,0,0,24] execFSM "Fog.fsm"};
    
    
if (!isDedicated) then
 {
	player execVM "zombie_scripts\cly_z_victim.sqf";
	

	//Should the player have a map?? 
	if (CVG_playerItems == 2) then 
	{
		if (player hasWeapon "ItemMap") then 
		{
			while {player hasWeapon "itemMap"} do 
			{
				player removeWeapon "itemMap";
			};  
		diag_log "Player now has no map";
		};
	};
	sleep 5;

	//http://community.bistudio.com/wiki/addGoggles
/*	if (CVG_NVG == 1) then {
		if ((goggles player == "")) then {
			player addGoggles "NVgoggles";
			if (goggles player == "") then {
				diag_log "Adding NV Goggles Failed, Trying again";
				while {goggles player == ""} do {
					player addGoggles "NVgoggles";
					diag_log "Trying to add NV Goggles again";
				};
			};
		};
		diag_log "NV Goggles added successfully";
	};
};*/
  
    
    //[] execVM "craigs_scripts\sirenpoles.sqf";
	
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
	sleep 3;
	
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
};

	