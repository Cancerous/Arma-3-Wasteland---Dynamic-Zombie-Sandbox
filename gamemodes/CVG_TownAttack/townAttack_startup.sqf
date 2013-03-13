

private ["_kindOf","_filter","_res","_veh","_types","_veh_type","_vehicle","_typeNumbers","_cfgvehicles","_options","_value","_side","_group","_logic","_type","_weap_type","_cur_type","_display_name","_no_pack","_optics","_weapon","_cfgweapons","_item_type","_rad","_cnps","_class","_standard_Vehicles","_turret","_weapons","_magazines","_subturrets","_turrets","_original_Config","_playerRespawn"];
StartLoadingScreen["Loading Mission Compon ents","RscLoadScreenCustom"];




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
CVG_Respawn = (paramsArray select 29);
CVG_Mochilla = (paramsArray select 30);
CVG_Caches = (paramsArray select 31);
CVG_SideMissions= (paramsArray select 32);
CVG_SideMarkers= (paramsArray select 33);
CVG_Logistics= (paramsArray select 34);
CVG_NVG= (paramsArray select 35);
CVG_E= (paramsArray select 36);
CVG_Helis= (paramsArray select 37);
CVG_TownAttackVehicles= (paramsArray select 39);
CVG_TownAttackBoxes= (paramsArray select 40);



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
    CVG_maxaggroradius=floor (random 1000);
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

paramsDone = 1;

if (isNil "BIS_functions_mainscope") then
{
    _side = createCenter sideLogic;
    _group = createGroup _side;
    _logic = _group createUnit ["FunctionsManager", [0,0,0], [], 0, "NONE"];
};
waitUntil {!isnil "bis_fnc_init"};




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

CLY_zombieclasses = CVG_Men;
{
	_class = _x;
	if (_class iskindOf "woman") then {CLY_zombieclasses = CLY_zombieclasses - [_class]};
	
} forEach CVG_Men;

/*
player sideChat format ["Time taken = %1 seconds",(round (time - timeAtStart))];
player sideChat format ["Count of Cars is: %1",count CVG_Cars];
player sideChat format ["Count of trucks is: %1",count CVG_trucks];
player sideChat format ["Count of APCs is: %1",count CVG_APCs];
player sideChat format ["Count of Tanks is: %1",count CVG_Tanks];
player sideChat format ["Count of Helicopters is: %1",count CVG_Helicopters];
player sideChat format ["Count of Planes is: %1",count CVG_Planes];
player sideChat format ["Count of Ships is: %1",count CVG_Ships];
*/
gunsComplete = 1;


_rad=20000;
_cnps = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
townlist= nearestLocations [_cnps, ["CityCenter"], _rad];



if (CVG_Logistics == 1) then {
    objectList = ["Land_Campfire_burning","Land_BarGate2","Land_Fire_barrel_burning","Land_fort_bagfence_corner","Land_HBarrier5","Land_BagFenceLong","Fort_EnvelopeBig_EP1","Fort_EnvelopeSmall_EP1","Fort_StoneWall_EP1","Land_Fort_Watchtower_EP1","Land_Misc_IronPipes_EP1","Land_Misc_Rubble_EP1","Land_stand_small_EP1","Fort_RazorWire","Land_HBarrier_large","Land_HBarrier5","Fort_Barricade","Land_fort_artillery_nest","Land_fort_rampart","Land_fortified_nest_small","Land_fort_bagfence_round","Land_Ind_BoardsPack2"];
};
MilitaryVehs = [];
    //Set up cars:
    switch (vehSpawnType) do
    {
        case 0:
        {

			
            //cars = ["Ikarus","SkodaBlue","SkodaGreen","SkodaRed","Skoda","VWGolf","TT650_Civ","MMT_Civ","hilux1_civil_2_covered","hilux1_civil_1_open","hilux1_civil_3_open","car_hatchback","datsun1_civil_1_open","datsun1_civil_2_covered","V3S_Civ","car_sedan","Tractor","UralCivil","UralCivil2","Lada_base","LadaLM","Lada2","Lada1","UAZ_CDF","Ural_CDF","hilux1_civil_3_open_EP1","Ikarus_TK_CIV_EP1","Lada1_TK_CIV_EP1","Lada2_TK_CIV_EP1","Old_bike_TK_CIV_EP1","Old_moto_TK_Civ_EP1","S1203_TK_CIV_EP1","SUV_TK_CIV_EP1","TT650_TK_CIV_EP1","UAZ_Unarmed_TK_CIV_EP1","Volha_1_TK_CIV_EP1","Volha_2_TK_CIV_EP1","VolhaLimo_TK_CIV_EP1"];
            //militaryvehs = ["HMMWV","HMMWV_M2","HMMWV_Armored","HMMWV_MK19","HMMWV_TOW","HMMWV_Avenger","MTVR","HMMWV_Ambulance","UAZ_CDF","UAZ_AGS30_CDF","UAZ_MG_CDF","Ural_CDF","UralOpen_CDF","Ural_ZU23_CDF","UAZ_RU","UAZ_AGS30_RU","Kamaz","KamazOpen","Offroad_DSHKM_INS","Pickup_PK_INS","UAZ_INS","UAZ_AGS30_INS","UAZ_MG_INS","UAZ_SPG9_INS","Ural_INS","UralOpen_INS","Ural_ZU23_INS","Offroad_DSHKM_Gue","Offroad_SPG9_Gue","Pickup_PK_GUE","V3S_Gue","Ural_ZU23_Gue","HMMWV_DES_EP1","HMMWV_MK19_DES_EP1","HMMWV_TOW_DES_EP1","HMMWV_M998_crows_M2_DES_EP1","HMMWV_M998_crows_MK19_DES_EP1","HMMWV_M1151_M2_DES_EP1","HMMWV_M998A2_SOV_DES_EP1","HMMWV_Terminal_EP1","HMMWV_M1035_DES_EP1","HMMWV_Avenger_DES_EP1","HMMWV_Avenger_DES_EP1","M1030_US_DES_EP1","MTVR_DES_EP1","HMMWV_Ambulance_DES_EP1","HMMWV_M1151_M2_CZ_DES_EP1","LandRover_CZ_EP1","LandRover_Special_CZ_EP1","MAZ_543_SCUD_TK_EP1","GRAD_TK_EP1","LandRover_MG_TK_EP1","LandRover_SPG9_TK_EP1","SUV_TK_EP1","UAZ_Unarmed_TK_EP1","UAZ_AGS30_TK_EP1","UAZ_MG_TK_EP1","Ural_ZU23_TK_EP1","V3S_TK_EP1","V3S_Open_TK_EP1","LandRover_MG_TK_INS_EP1","LandRover_SPG9_TK_INS_EP1","SUV_UN_EP1","UAZ_Unarmed_UN_EP1","Ural_UN_EP1","Offroad_DSHKM_TK_GUE_EP1","Offroad_SPG9_TK_GUE_EP1","Pickup_PK_TK_GUE_EP1","Ural_ZU23_TK_GUE_EP1","V3S_TK_GUE_EP1"];
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
			_standard_Vehicles = ["Ural_CDF","UralOpen_CDF","UralRepair_CDF","UralReammo_CDF","UralRefuel_CDF","Ural_ZU23_CDF","GRAD_CDF","GRAD_RU","Ural_INS","UralOpen_INS","UralRepair_INS","UralReammo_INS","UralRefuel_INS","Ural_ZU23_INS","GRAD_INS","Ural_ZU23_Gue","UralCivil","UralCivil2","Kamaz","KamazOpen","KamazRepair","KamazReammo","KamazRefuel","MTVR","MtvrReammo","MtvrRefuel","MtvrRepair","V3S_Civ","V3S_Gue","Ural_UN_EP1","Ural_TK_CIV_EP1","UralRepair_TK_EP1","UralReammo_TK_EP1","UralRefuel_TK_EP1","Ural_ZU23_TK_EP1","Ural_ZU23_TK_GUE_EP1","UralSupply_TK_EP1","UralSalvage_TK_EP1","MTVR_DES_EP1","MtvrReammo_DES_EP1","MtvrRefuel_DES_EP1","MtvrRepair_DES_EP1","MtvrSupply_DES_EP1","MtvrSalvage_DES_EP1","GRAD_TK_EP1","MAZ_543_SCUD_TK_EP1","WarfareSalvageTruck_USMC","WarfareSupplyTruck_USMC","WarfareReammoTruck_USMC","WarfareSalvageTruck_RU","WarfareSupplyTruck_RU","WarfareReammoTruck_RU","WarfareSalvageTruck_CDF","WarfareSupplyTruck_CDF","WarfareReammoTruck_CDF","WarfareSalvageTruck_INS","WarfareSupplyTruck_INS","WarfareReammoTruck_INS","WarfareSalvageTruck_Gue","WarfareSupplyTruck_Gue","WarfareReammoTruck_Gue","WarfareRepairTruck_Gue","RM70_ACR","V3S_TK_EP1","V3S_Open_TK_EP1","V3S_Open_TK_CIV_EP1","V3S_TK_GUE_EP1","V3S_Refuel_TK_GUE_EP1","V3S_Repair_TK_GUE_EP1","V3S_Reammo_TK_GUE_EP1","V3S_Supply_TK_GUE_EP1","V3S_Salvage_TK_GUE_EP1","T810A_MG_ACR","T810_ACR","T810_Open_ACR","T810Refuel_ACR","T810Reammo_ACR","T810Repair_ACR","T810A_Des_MG_ACR","T810_Des_ACR","T810_Open_Des_ACR","T810Refuel_Des_ACR","T810Repair_Des_ACR","T810Reammo_Des_ACR","Tractor","HMMWV_M2","HMMWV_TOW","HMMWV_MK19","HMMWV","UAZ_MG_CDF","UAZ_AGS30_CDF","UAZ_CDF","UAZ_RU","UAZ_AGS30_RU","UAZ_MG_INS","UAZ_AGS30_INS","UAZ_INS","UAZ_SPG9_INS","Skoda","SkodaBlue","SkodaRed","SkodaGreen","datsun1_civil_1_open","datsun1_civil_2_covered","datsun1_civil_3_open","car_hatchback","car_sedan","hilux1_civil_1_open","hilux1_civil_2_covered","hilux1_civil_3_open","Pickup_PK_GUE","Pickup_PK_INS","Offroad_DSHKM_Gue","Offroad_SPG9_Gue","Offroad_DSHKM_INS","HMMWV_Armored","HMMWV_Ambulance","HMMWV_Avenger","Ikarus","Lada1","Lada2","LadaLM","TowingTractor","VWGolf","UAZ_MG_TK_EP1","UAZ_AGS30_TK_EP1","UAZ_Unarmed_TK_EP1","UAZ_Unarmed_UN_EP1","UAZ_Unarmed_TK_CIV_EP1","Pickup_PK_TK_GUE_EP1","Offroad_DSHKM_TK_GUE_EP1","Offroad_SPG9_TK_GUE_EP1","HMMWV_DES_EP1","HMMWV_MK19_DES_EP1","HMMWV_Ambulance_DES_EP1","HMMWV_Ambulance_CZ_DES_EP1","HMMWV_Avenger_DES_EP1","Lada1_TK_CIV_EP1","Lada2_TK_CIV_EP1","Ikarus_TK_CIV_EP1","hilux1_civil_3_open_EP1","ATV_US_EP1","ATV_CZ_EP1","HMMWV_M1035_DES_EP1","HMMWV_M1151_M2_CZ_DES_EP1","HMMWV_M1151_M2_DES_EP1","HMMWV_M998_crows_M2_DES_EP1","HMMWV_M998_crows_MK19_DES_EP1","HMMWV_M998A2_SOV_DES_EP1","HMMWV_TOW_DES_EP1","HMMWV_Terminal_EP1","LandRover_CZ_EP1","LandRover_TK_CIV_EP1","LandRover_MG_TK_INS_EP1","LandRover_MG_TK_EP1","LandRover_Special_CZ_EP1","LandRover_SPG9_TK_INS_EP1","LandRover_SPG9_TK_EP1","S1203_TK_CIV_EP1","S1203_ambulance_EP1","SUV_TK_CIV_EP1","SUV_TK_EP1","SUV_UN_EP1","Volha_1_TK_CIV_EP1","Volha_2_TK_CIV_EP1","VolhaLimo_TK_CIV_EP1","SUV_PMC","ArmoredSUV_PMC","UAZ_Unarmed_ACR","Dingo_WDL_ACR","Dingo_DST_ACR","Dingo_GL_Wdl_ACR","Dingo_GL_DST_ACR","M1114_AGS_ACR","M1114_DSK_ACR","LandRover_ACR","LandRover_Ambulance_ACR","LandRover_Ambulance_Des_ACR","Octavia_ACR","SUV_PMC_BAF","BAF_ATV_D","BAF_Offroad_D","BAF_Jackal2_L2A1_D","BAF_Jackal2_GMG_D","BAF_ATV_W","BAF_Offroad_W","BAF_Jackal2_L2A1_W","BAF_Jackal2_GMG_W"];
			
			{
				if (_x in _standard_Vehicles) then {cars = cars - [_x]};
			} forEach cars;
		};
    };

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

} forEach CVG_Trucks;
	
	
	

    Switch (CVG_weapontype) do {
        case 1:
		{
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
            CVG_weapons = ["huntingrifle","colt1911","m9","m9sd","makarov","makarovsd","aks_gold","AK_74","AK_47_M","FN_FAL","AK_47_S","AKS_74_U","LeeEnfield","m16a2","m1014"];
            
            
        };
		
        case 3: {
            //Blufor Weapons
            CVG_weapons = ["m24","m40a3","m107","m4spr","glock17_EP1","DMR","smaw","smaw","BAF_AS50_scoped","BAF_AS50_TWS","BAF_L110A1_Aim","BAF_L7A2_GPMG","BAF_L85A2_RIS_ACOG","BAF_L85A2_RIS_CWS","BAF_L85A2_RIS_Holo","m1014","m1014","m1014","m1014","BAF_L85A2_RIS_SUSAT","m8_carbine_pmc","m8_carbineGL","m8_SAW","m8_sharpshooter","m8_compact","BAF_L85A2_UGL_ACOG","AA12_PMC","m8_compact_pmc","BAF_L85A2_UGL_Holo","m8_holo_sd","BAF_L85A2_UGL_SUSAT","BAF_L86A2_ACOG","m8_tws_sd","BAF_LRR_scoped","m8_tws","BAF_LRR_scoped_W","colt1911","m9","m9sd","m16a2","m16a2gl","m16a4","m16a4_gl","m16a4_acg","m16a4_acg_gl","m4a1","m4a1_aim","m4A1_AIM_camo","SCAR_H_CQC_CCO_SD","SCAR_H_STD_EGLM_Spect","SCAR_H_STD_TWS_SD","Sa58P_EP1","Sa58V_EP1","Sa58V_RCO_EP1","Sa58V_CCO_EP1","SCAR_H_LNG_Sniper","SCAR_H_LNG_Sniper_SD","SCAR_L_STD_HOLO","SCAR_L_STD_Mk4CQT","SCAR_H_CQC_CCO","M4A1_AIM_SD_camo","SCAR_L_STD_EGLM_TWS","M4A1_HWS_GL","m4a1_hws_gl_camo","m4a1_hws_gl_sd_camo","m4a1_rco_gl","m8_carbine","m8_carbinegl","m8_compact","m8_sharpshooter","m240_scoped_EP1","M249_EP1","M249_m145_EP1","M110_TWS_EP1","m107_TWS_EP1","M249_TWS_EP1","M60A4_EP1","Mk_48_DES_EP1","g36a","g36k","g36c","g36_c_sd_eotech","mp5a5","mp5sd","m1014","MG36_camo","m249","m240","mk_48","mg36","m1014","m8_saw","M14_EP1","M4A3_RCO_GL_EP1","M4A3_CCO_EP1","SCAR_L_CQC_CCO_SD","SCAR_L_CQC","SCAR_L_CQC_Holo","SCAR_L_CQC_EGLM_Holo","SCAR_L_STD_EGLM_RCO"];
            
            
        };
		
        case 4: {
            //OpFor Weapons
            CVG_weapons = ["vss_vintorez","svd","svd_camo","SVD_NSPU_EP1","ksvk","rpg7v","pk","pecheneg","makarov","SVD_des_EP1","UZI_SD_EP1","UZI_EP1","revolver_gold_EP1","revolver_EP1","makarovsd","saiga12k","bizon","aks_gold","AK_74","AK_47_M","FN_FAL","RPK_74","PK","AK_74_GL_kobra","AK_47_S","AKS_74_pso","AKS_74_GOSHAWK","AKS_74_U","LeeEnfield"];
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
			_original_Config = ["M16A2","M16A2GL","m16a4","M16A4_GL","M4A1","M4A1_Aim","M4A1_Aim_camo","M4A1_RCO_GL","M4A1_AIM_SD_camo","M4A1_HWS_GL_SD_Camo","M4A1_HWS_GL","M4A1_HWS_GL_camo","MP5SD","MP5A5","G36C","G36_C_SD_eotech","G36a","G36K","MG36","AK_47_M","AK_47_S","AKS_GOLD","AK_74","AK_74_GL","AK_107_kobra","AK_107_GL_kobra","AKS_74_kobra","AKS_74_U","AKS_74_UN_kobra","RPK_74","bizon","bizon_silenced","M1014","Saiga12K","BAF_L85A2_RIS_Holo","BAF_L85A2_UGL_Holo","Sa58P_EP1","Sa58V_EP1","Sa58V_CCO_EP1","M4A3_CCO_EP1","AK_74_GL_kobra","AKS_74","FN_FAL","G36C_camo","G36_C_SD_camo","G36A_camo","G36K_camo","MG36_camo","M32_EP1","M79_EP1","Mk13_EP1","LeeEnfield","M14_EP1","SCAR_L_CQC","SCAR_L_CQC_Holo","SCAR_L_CQC_EGLM_Holo","SCAR_L_STD_HOLO","SCAR_L_CQC_CCO_SD","SCAR_H_CQC_CCO","SCAR_H_CQC_CCO_SD","AA12_PMC","Evo_ACR","Evo_mrad_ACR","evo_sd_ACR","CZ805_A2_ACR","CZ805_A2_SD_ACR","m16a4_acg","M16A4_ACG_GL","M24","M40A3","M4SPR","SVD","SVD_CAMO","AK_107_GL_pso","AK_107_pso","AKS_74_pso","DMR","VSS_vintorez","m8_carbine","m8_carbineGL","m8_compact","m8_sharpshooter","m8_SAW","huntingrifle","BAF_AS50_scoped","BAF_AS50_TWS","BAF_LRR_scoped","BAF_LRR_scoped_W","BAF_L85A2_RIS_SUSAT","BAF_L85A2_UGL_SUSAT","BAF_L85A2_RIS_ACOG","BAF_L85A2_UGL_ACOG","BAF_L85A2_RIS_CWS","BAF_L86A2_ACOG","M24_des_EP1","SVD_des_EP1","SVD_NSPU_EP1","Sa58V_RCO_EP1","M4A3_RCO_GL_EP1","AKS_74_NSPU","AKS_74_GOSHAWK","FN_FAL_ANPVS4","M110_TWS_EP1","M110_NVG_EP1","SCAR_L_STD_Mk4CQT","SCAR_L_STD_EGLM_RCO","SCAR_L_STD_EGLM_TWS","SCAR_H_STD_EGLM_Spect","SCAR_H_LNG_Sniper","SCAR_H_LNG_Sniper_SD","SCAR_H_STD_TWS_SD","PMC_AS50_scoped","PMC_AS50_TWS","m8_carbine_pmc","m8_compact_pmc","m8_holo_sd","m8_tws_sd","m8_tws","CZ_750_S1_ACR","CZ805_A1_ACR","CZ805_A1_GL_ACR","CZ805_B_GL_ACR","M240","Mk_48","M249","PK","Pecheneg","ksvk","m107","BAF_L110A1_Aim","BAF_L7A2_GPMG","M60A4_EP1","Mk_48_DES_EP1","M249_EP1","M249_TWS_EP1","M249_m145_EP1","m107_TWS_EP1","m240_scoped_EP1","UK59_ACR","M9","M9SD","Makarov","MakarovSD","Colt1911","Sa61_EP1","UZI_EP1","UZI_SD_EP1","revolver_EP1","revolver_gold_EP1","glock17_EP1","CZ_75_P_07_DUTY","CZ_75_D_COMPACT","CZ_75_SP_01_PHANTOM","CZ_75_SP_01_PHANTOM_SD","M136","Javelin","Stinger","RPG7V","Strela","Igla","MetisLauncher","RPG18","SMAW","BAF_NLAW_Launcher","M47Launcher_EP1","MAAWS"];
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
//
//
//
//
//
//

////////////////////////////////
////Section 2 Done
progressLoadingScreen 0.4;
/////////////////////////////////


   
	
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
    //prepares some functions to run later
    randomWeapons =		 compile preprocessFileLineNumbers "craigs_scripts\randomWeapons.sqf";
    vehicleInfo =		 compile preProcessFileLineNumbers "craigs_scripts\dvs\vehicleinfo.sqf";
    objSpawn = 		compile preProcessFileLineNumbers "craigs_scripts\dvs\ObjectSpawn.sqf";
    populateIsland =		compile preProcessFileLineNumbers "craigs_scripts\populateIsland.sqf";
	
	if (!isDedicated) then {
		_playerRespawn = player addMPEventHandler ["MPRespawn", {Null = _this execVM "gamemodes\CVG_TownAttack\onRespawn.sqf";}]; 
	};

	CLY_randomzombie={
    
    private ["_zombie","_selected"];
    _selected=false;
    _zombie=CLY_zombieclasses select floor random count CLY_zombieclasses;
    while {typeName _zombie=="ARRAY"} do {
        _zombie=_zombie select floor random count _zombie;
    };
    _zombie;
};

	endLoadingScreen;
	screendone = 1;
	[] execVM "gamemodes\CVG_TownAttack\townattack.sqf";
	

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
	
	    if (CVG_Debug == 2) then {
			player sidechat "Setting Time";
        };
        skipTime CVG_timeToSkipTo;
        if (CVG_Debug == 2) then {
            player sidechat "Time Set";
        };
        
    //View distances
    setViewDistance CVG_Viewdist;
    //Fog
    if (CVG_fog == 1) then {null=[player,100,11,30,3,7,-0.3,0.1,0.5,1,1,1,13,12,15,false,2,2.1,0.1,1,1,0,0,24] execFSM "Fog.fsm"};
	
    player execVM "zombie_scripts\cly_z_victim.sqf";

    sleep 3;
	if ( !isDedicated) then {
		if (CVG_NVG == 1) then {
			if (!(player hasWeapon "NVgoggles")) then {
				player addWeapon "NVgoggles";
				if (!(player hasWeapon "NVgoggles")) then {
					diag_log "Adding NV Goggles Failed, Trying again";
					while {!(player hasWeapon "NVgoggles")} do {
						player addWeapon "NVgoggles";
						diag_log "Trying to add NV Goggles again";
					};
				};
			};
			diag_log "NV Goggles added successfully";
		};


		player setCaptive true;
	};
