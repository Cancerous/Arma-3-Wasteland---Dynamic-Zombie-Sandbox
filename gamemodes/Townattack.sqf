if (isServer) then {
    private ["_rad","_cnps","_dist","_dir","_pos","_marker","_armPos","_centPos","_checkVar","_side","_group","_logic","_check1","_check2","_arrayCompare"];
    
    
    
    
    private ["_rad","_cnps","_dist","_dir","_pos","_marker","_armPos","_centPos","_checkVar","_side","_group","_logic"];
    if (isNil "BIS_functions_mainscope") then
    {
        _side = createCenter sideLogic;
        _group = createGroup _side;
        _logic = _group createUnit ["FunctionsManager", [0,0,0], [], 0, "NONE"];
    };
    waitUntil {!isnil "bis_fnc_init"};
    
    private ["_rad","_cnps","_dist","_dir","_pos","_marker","_armPos","_centPos","_checkVar"];
    
    
    
    if (isNil ("townlist")) then {
        _rad=20000;
        _cnps = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
        townlist= nearestLocations [_cnps, ["CityCenter"], _rad]};
        
        town = townlist call BIS_fnc_selectRandom;
        
        _marker=createMarker [format ["mar%1",random 100000],(position town)];
        _marker setMarkerType "Dot";
        _marker setMarkerColor "ColorBlue";
        _marker setMarkerSize [2,2];
        
        _checkVar = 0;
        _armPos = getArray(configFile >> "CfgWorlds" >> worldName >> "Armory" >> "positionStart");
        _centPos = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
        
        while {_checkVar < 1} do{
            _dist = 300;
            _dir = random 360;
            _pos = [(getPos town select 0) + (sin _dir) * _dist, (getPos town select 1) + (cos _dir) * _dist, 0];
            _pos = [_pos,0,40,25,0,20,0] call BIS_fnc_findSafePos;
            
            _check1 = [_pos, _armPos] call arrayCompare;
            _check2 = [_pos,_centPos] call arrayCompare;
            if ((!_check1) && (!_check2) && ((_pos distance (getpos town)) > 300)) then { _checkVar = 1};
        };
        //Publish the location:
        
        startPosition = _pos;
        publicVariable "startPosition";
        
        _marker=createMarker [format ["mar%1",random 100000],_pos];
        _marker setMarkerType "Dot";
        _marker setMarkerColor "ColorRed";
        _marker setMarkerSize [2,2];
        
    };
    waitUntil {!isNil "startPosition"};
    
    player setpos startPosition;
    
    //Check to make sure player is at that position:
    if ((position player) distance startPosition > 50) then {
        While {(position player) distance startPosition > 50} do {
            player setpos startPosition;
            sleep 1;
        };
    };
    
    
    
    
    
    
    
    
    
    
    
    