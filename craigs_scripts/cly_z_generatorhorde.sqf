//Zombie generator script by Celery

private ["_x","_amount","_activate","_relocate","_pos","_marker","_despawn","_zombie","_spawn","_zombietype","_total","_side","_r","_group","_class","_idarray","_positions","_markers","_horde","_removeidarray","_zombies","_trigger","_radius","_triggerpos","_activatedist","_deactivatedist","_posx","_posy","_altlogic"];
sleep 3;
if (!isServer) exitWith {};

waitUntil {{isNil "_x"} count ["CLY_minspawndist","CLY_maxspawndist","CLY_despawndist","CLY_defaultdensity","CLY_hordereservedgroups","CLY_players","CLY_debug","BIS_fnc_inTrigger"]==0};

_trigger=_this select 0;
_amount=_this select 1;
_radius=(triggerArea _trigger select 0) max (triggerArea _trigger select 1);
_triggerpos=[getPos _trigger select 0,getPos _trigger select 1,0];
_activatedist=_radius/cos 45+CLY_maxspawndist;
_deactivatedist=_activatedist+100;
//Continue if logic is inside area of operations (or there is no such area)
_posx=getPos _trigger select 0;
_posy=getPos _trigger select 1;
if (!isNil "generatorminxy" and !isNil "generatormaxxy") then {
    if (_posx<getPos generatorminxy select 0 or _posx>getPos generatormaxxy select 0 or _posy<getPos generatorminxy select 1 or _posy>getPos generatormaxxy select 1) exitWith {deleteVehicle _trigger};
};

//Zombie amount if set to default
if (_amount<0) then {
    _amount=round (CLY_defaultdensity*abs _amount);
};

//Create altitude detector
_altlogic="logic" createVehicleLocal _triggerpos;

//Run script until there are no zombies left
while {_amount>0} do {
    //Wait until players are in range
    _activate=false;
    while {!_activate} do {
        if ({_triggerpos distance [getPos vehicle _x select 0,getPos vehicle _x select 1,0]<_activatedist} count CLY_players>0) then {_activate=true};
        if (!_activate) then {sleep 5};
    };
    
    //Prepare positions
    _positions=[];
    _idarray=[];
    _markers=[];
    for "_x" from 1 to _amount do {
        _pos=[0,0,0];
        _relocate=true;
        //Relocate if position is on water or on a structure or close to player
        while {_relocate} do {
		_exp = "(100 * houses) * (100 * deadBody) * (1 + meadow) * (1 - forest) * (1 - trees) - (100 * sea) - (100 * hills)";
		_prec = 100;
		_bestplace = selectBestPlaces [_triggerpos,500,_exp,_prec,1];
		_spot = _bestplace select 0;
		_pos = _spot select 0;
		//_pos=[(_triggerpos select 0)-_radius+random _radius*2,(_triggerpos select 1)-_radius+random _radius*2,0];
            _altlogic setPos [_pos select 0,_pos select 1,0]; //1000
            if ([_trigger,_pos] call BIS_fnc_inTrigger and !surfaceIsWater _pos and (getPos _altlogic select 2)==(getPosATL _altlogic select 2) and {_pos distance [getPos vehicle _x select 0,getPos vehicle _x select 1,0]<CLY_minspawndist} count CLY_players==0) then {_relocate=false};
        };
        //Debug marker
        if (CLY_debug) then {
            _marker=createMarkerLocal [format ["marker%1",random 100000],_pos];
            _marker setMarkerTypeLocal "Dot";
            _marker setMarkerColorLocal "ColorGreen";
            _marker setMarkerSizeLocal [0.15,0.15];
            _markers set [count _markers,_marker];
        };
        //Add to array
        _positions set [count _positions,_pos];
        _idarray set [count _idarray,_x-1];
    };
    _horde = true;
    //Initialize arrays
    _removeidarray=[];
    _zombies=[];
    for "_x" from 1 to count _positions do {_zombies set [count _zombies,objNull]};
    
    sleep random 2;
    
    //Loop until players are out of range
    while {_amount>0 and {_triggerpos distance [getPos vehicle _x select 0,getPos vehicle _x select 1,0]>_deactivatedist} count CLY_players<count CLY_players} do {
        {
            //Despawn zombie if not in range or detach from generator if horde
            if (!isNull (_zombies select _x)) then {
                _zombie=_zombies select _x;
                _despawn=true;
                if ({_zombie distance [getPos vehicle _x select 0,getPos vehicle _x select 1,0]<CLY_despawndist or !isNull (_zombie getVariable "victim")} count CLY_players>0) then {_despawn=false};
                if (_despawn or !alive _zombie or (_zombie getVariable "horde")) then {
					if (count usedBuildings != 0) then {
						{
							if (_x distance _zombie <= 500) then { usedBuildings = usedBuildings - [_x]};
						} forEach usedBuildings;
					};
                    if (_despawn) then {_zombie setDamage 1};
                    _zombies set [_x,objNull];
                    _removeidarray set [count _removeidarray,_x];
                    if (CLY_debug) then {deleteMarkerLocal (_markers select _x)};
                };
            } else {
                //Create zombie
                if ({side _x==east or side _x==west or side _x==resistance} count allGroups<432-CLY_hordereservedgroups) then {
                    //Determine whether position is in spawning range
                    _spawn=false;
                    _pos=_positions select _x;
                    if ({_pos distance vehicle _x<CLY_maxspawndist} count CLY_players>0 and {_pos distance vehicle _x<CLY_minspawndist} count CLY_players==0) then {_spawn=true};
                    
                    //Spawn new zombie
                    if (_spawn) then {
                        //Determine zombie type
                        _zombietype="normal";
                        _r=random 100;
                        _total=0;
                        {
                            if (_r>_total and _r<=_total+(_x select 1)) then {_zombietype=_x select 0};
                            _total=_total+(_x select 1);
                        } forEach CLY_zombietypes;
                        
                        //Create unit
                        _side=east;
                        if ({side _x==east} count allGroups>=144) then {_side=west};
                        if (_side==west and {side _x==west} count allGroups>=144) then {_side=resistance};
                        _group=createGroup _side;
                        _class=if !(_zombietype in ["armored","slow armored"]) then {
                            call CLY_randomzombie;
                        } else {
                            call CLY_randomarmoredzombie;
                        };
                        _zombie=_group createUnit [_class,getPos zombiespawner,[],50,"NONE"];
                        _zombie enableSimulation false;
                        
                        
                        //Initialize zombification
                        [_zombie,_zombietype,objNull,_horde,0,_positions select _x] exec "zombie_scripts\cly_z_init.sqs";
                        
                        //Add to arrays
                        _zombies set [_x,_zombie];
                    };
                };
            };
            sleep 0.01;
        } forEach _idarray;
        
        //Remove expired IDs
        {_idarray=_idarray-[_x]} forEach _removeidarray;
        _amount=count _idarray;
        
        sleep 0.1;
    };
    {deleteMarkerLocal _x} forEach _markers;
    _amount=count _idarray;
};

deleteVehicle _trigger;
deleteVehicle _altlogic;