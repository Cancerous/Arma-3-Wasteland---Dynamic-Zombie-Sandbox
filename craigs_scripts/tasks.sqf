private ["_choppatype","_side","_group","_survivalTime","_rad","_cnps","_hills","_hillcount","_hillnum","_hill","_hillpos","_checking","_people","_trigger","_logic"];
//Discontinued
//Escape Via chopper task
if (isNil "BIS_functions_mainscope") then
{
    _side = createCenter sideLogic;
    _group = createGroup _side;
    _logic = _group createUnit ["FunctionsManager", [0,0,0], [], 0, "NONE"];
};
waitUntil {!isnil "bis_fnc_init"};







if (CVG_TaskType == 1) then {
    
    sleep 1;
    if (isServer) then {
        _choppatype = ["Mi17_Ins","Ka52","Mi24_P","Mi17_rockets_RU","Mi17_CDF","Mi24_D","MV22","UH1Y","MH60S","Mi17_Civilian"]  call BIS_fnc_selectRandom;
        _rad=20000;
        _cnps = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
        _hills = nearestLocations [_cnps, ["NameLocal","Hill"], _rad];
        _hillcount = count _hills;
        _hillnum = floor (random _hillcount);
        _hill = _hills select _hillnum;
        _hillpos = position _hill;
        createPos = _hillpos; publicVariable "createpos";
        choppa = createVehicle [_choppatype,[(getpos _hill select 0) + 10, getpos _hill select 1,0],[], 0, "NONE"]; publicVariable "choppa";
    };
    
    
    newTask = player createSimpleTask ["Get to the chopper and escape!"];
    if (CVg_Taskoption == 1) then {
        newTask Setsimpletaskdestination createPos;
    };
    newTask setSimpleTaskDescription ["Get to the chopper, and fly away to safety. The chopper is at this location!", "Escape!", "Chopper!"];
    newTask setTaskState "Assigned";
    player setCurrentTask newTask;
    if (CVG_Debug == 2) then {
        player sidechat "loading tasks DONE";
    };
    if (CVg_Taskoption == 1) then {
        hintSilent "There is a chopper at the location given to you. Find it and get out of the country";
        sleep 5;
        hintSilent "There is a chopper at the location given to you. Find it and get out of the country";
    } else {
        hintSilent "There is a chopper somewhere on the island. Find it and get out of the country";
        sleep 5;
        hintSilent "There is a chopper somewhere on the island. Find it and get out of the country";
    };
    
    
    
    
    if ((!isdedicated) && (time > 1)) then {
        waitUntil {(((position Choppa) distance createPos) > 100) && (player in Choppa)};
        _side = createCenter sideLogic;
        _group = createGroup _side;
        FW = _group createUnit ["Logic", [0,0,0], [], 0, "NONE"];
        FW setGroupId ["FoxtrotWhiskey"];
        FW globalChat "Uknown Contact this is Foxtrot Whiskey, please confirm your identity. Over.";
        sleep 4;
        player setGroupId ["Survivor"];
        player globalChat "Foxtrot Whiskey, this is the uknown contact. We just excaped the apocalypse via helicopter. Where do you want us to go?";
        sleep 4;
        FW globalChat "Roger that, we are giving you the callsign 'Red Rabbit'. Please head West, bearing 270. Over.";
        sleep 5;
        player setGroupID ["Red Rabbit"];
        player globalChat "Ok, adjusting course now, what is the status of the rest of the world. Over.";
        sleep 4;
        FW globalChat "War is upon us, Red Rabbit, the human race is facing its greatest trial. We need every man that can fire a weapon. Foxtrot Whiskey Out.";
    };
    if (isServer) then {
        sleep 30;
        [nil,nil,rHINT,"You escaped, but this is only the beginning."] call RE;
        sleep 10;
        [nil,nil,rtitleText,"","BlackOut",7] call RE;
        sleep 8;
        [nil,nil,rENDMISSION,"END1"] call RE;
        endMission "END1";
    };
};




































//=======BETA TASK=======\\



if (CVg_TaskType == 2) then {
    if (CVG_Debug == 2) then {
        player sidechat "loading tasks";
    };
    //Find and defend base task before evacs\\
    
    if (isServer) then {
        _rad=20000;
        _cnps = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
        _hills = nearestLocations [_cnps, ["NameLocal"], _rad];
        _hillcount = count _hills;
        _hillnum = floor (random _hillcount);
        _hill = _hills select _hillnum;
        createPos = getpos _hill;
        posfound=1; publicVariable "posfound";
        GroupHQG1 = CreateGroup WEST;
        g1 = GroupHQG1 createUnit ["USMC_Soldier_AT", createPos, [], 18, "NONE"];
        g2 = GroupHQG1 createUnit ["USMC_Soldier_AR",createPos, [], 18, "NONE"];
        g3 = GroupHQG1 createUnit ["USMC_Soldier_Medic", createPos, [], 18, "NONE"];
        g4 = GroupHQG1 createUnit ["USMC_Soldier_LAT", createPos, [], 18, "NONE"];
        g5 = GroupHQG1 createUnit ["USMC_SoldierM_Marksman", createPos, [], 18, "NONE"];
        g1 = leader GroupHQG1;
        wp1 = GroupHQG1 addwaypoint [ createPos, 0];
        wp1 setwaypointtype "Sentry";
        {_x setSkill 1} foreach units GroupHQG1;
        GroupHQG1 setformation "DIAMOND";
        
        
        _group = CreateGroup WEST;
        
        g1 = _group createUnit ["USMC_Soldier_AT", createPos, [], 18, "NONE"]; publicVariable "g1";
        g2 = _group createUnit ["USMC_Soldier_AR", createPos, [], 18, "NONE"];
        g3 = _group createUnit ["USMC_Soldier_Medic", createPos, [], 18, "NONE"];
        g4 = _group createUnit ["USMC_Soldier_LAT", createPos, [], 18, "NONE"];
        g5 = _group createUnit ["USMC_SoldierM_Marksman", createPos, [], 18, "NONE"];
        
        
    };
    
    
    sleep 1;
    fob1 = [createPos, random 360, "smallbase"] call (compile (preprocessFileLineNumbers "ca\modules\dyno\data\scripts\objectMapper.sqf"));
    
    if (isServer) then {
        []spawn {
            
            private ["_group"];
            {_x moveInGunner (nearestObject [_x, "StaticWeapon"]); sleep 0.1;} forEach (units _group);
        };
    };
    if (isDedicated) then {
        "playerinarea" addPublicVariableEventHandler {
            []spawn {
                
                private ["_trigger"];
                CLY_hordereservedgroups=50;
                _trigger=createTrigger ["EmptyDetector",getpos g4];
                _trigger setTriggerArea [10,10,0,false];
                [_trigger,15,CLY_hordetrigger,"normal"] execVM "zombie_scripts\cly_z_horde.sqf";
                sleep 360;
                playMusic ["Track16", 30];
                [nil,nil,rHINT,"You successfully defended the base! You will all be evacuated soon!"] call RE;
                [zombiespawner,nil,rSIDECHAT,"You successfully defended the base! You will all be evacuated soon!"] call RE;
                sleep 10;
                [nil,nil,rtitleText,"","BlackOut",7] call RE;
                sleep 8;
                [nil,nil,rENDMISSION,"END1"] call RE;
                endMission "END1";
            }
        };
    };
    
    if (!isDedicated) then {
        newTask = player createSimpleTask ["Defend Base"];
        if (CVg_Taskoption == 1) then {
            newTask Setsimpletaskdestination (getpos g1);
        };
        newTask setSimpleTaskDescription ["Get to the base and defend it, they will provide a way out of the country", "Escape!", "Base!"];
        newTask setTaskState "Assigned";
        player setCurrentTask newTask;
        if (CVg_Taskoption == 1) then {
            hintSilent "An American Base is marked on your map, the soldiers stationed there may need some help. Get over there!";
            sleep 5;
            hintSilent "An American Base is marked on your map, the soldiers stationed there may need some help. Get over there!";
            hintSilent "An American Base is marked on your map, the soldiers stationed there may need some help. Get over there!";
        } else {
            hintSilent "An American Base is somewhere on the map, the soldiers stationed there may need some help. Find it and get over there!";
            sleep 5;
            hintSilent "An American Base is somewhere on the map, the soldiers stationed there may need some help. Find it and get over there!";
        };
        if (CVG_Debug == 2) then {
            player sidechat "loading tasks DONE";
        };
        
        
    };
    if (isServer) then {
        _checking = 1;
        while {_checking == 1} do {
            _people =  nearestObjects [[getpos g1 select 0, getpos g1 select 1,0],["Man"],50];
            if ({isPlayer _x} count _people > 0) then {_checking = 0};
            sleep 1;
        };
        CLY_hordereservedgroups=50;
        _trigger=createTrigger ["EmptyDetector",getpos g4];
        _trigger setTriggerArea [10,10,0,false];
        [_trigger,15,CLY_hordetrigger,"normal"] execVM "zombie_scripts\cly_z_horde.sqf";;
        sleep 360;
        playMusic ["Track16", 30];
        [nil,nil,rHINT,"You successfully defended the base! You will all be evacuated soon!"] call RE;
        [zombiespawner,nil,rSIDECHAT,"You successfully defended the base! You will all be evacuated soon!"] call RE;
        sleep 10;
        [nil,nil,rtitleText,"","BlackOut",7] call RE;
        sleep 8;
        [nil,nil,rENDMISSION,"END1"] call RE;
        endMission "END1";
        
    };
};




















if (CVg_TaskType == 3) then {
    if (CVG_Debug == 2) then {
        player sidechat "loading tasks";
    };
    newTask = player createSimpleTask ["Survive for 30 minutes"];
    newTask setSimpleTaskDescription ["Survive in the God-Forsaken Land for 30 minutes", "Survive", "Survive"];
    newTask setTaskState "Assigned";
    player setCurrentTask newTask;
    if (CVG_Debug == 2) then {
        player sidechat "loading tasks DONE";
    };
    hintSilent "Just survive, its only 30 minutes. No worries...";
    sleep 5;
    hintSilent "Just survive, its only 30 minutes. No worries...";
    if (isServer) then {
        _survivaltime = 0;
        while {true} do
        {	
            _survivalTime = (_survivalTime +1);
            sleep 1;
            if (_survivaltime == 1800) exitWith {survivaldone = 1;publicVariable "survivaldone";};
        };
        
    };
    waitUntil {survivaldone == 1};
    playMusic ["Track16", 30];
    [nil,nil,rHINT,"You survived! Well Done!"] call RE;
    [zombiespawner,nil,rSIDECHAT,"You survived! Well Done!"] call RE;
    sleep 10;
    [nil,nil,rtitleText,"","BlackOut",7] call RE;
    sleep 8;
    [nil,nil,rENDMISSION,"END1"] call RE;
    endMission "END1";	
};













if (CVg_TaskType == 4) then {
    newTask = player createSimpleTask ["Survive"];
    newTask setSimpleTaskDescription ["Survive. You have no hope. Avoid the inevitable. Scavenge. Barricade. Run. Hide. Whatever it takes. ", "Survive", "Survive"];
    newTask setTaskState "Assigned";
    player setCurrentTask newTask;
    hintSilent "Survive. You have no hope. Avoid the inevitable. Scavenge. Barricade. Run. Hide. Betray. Whatever it takes.";
    sleep 5;
    hintSilent "Survive. You have no hope. Avoid the inevitable. Scavenge. Barricade. Run. Hide. Betray. Whatever it takes.";
    hintSilent "Survive. You have no hope. Avoid the inevitable. Scavenge. Barricade. Run. Hide. Betray. Whatever it takes.";
};


