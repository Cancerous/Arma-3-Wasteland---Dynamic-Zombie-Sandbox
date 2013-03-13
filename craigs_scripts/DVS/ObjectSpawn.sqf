//determines the vehicles random properties
/*
private ["_objPos","_Objtype","_obj"];

    private ["_marker","_cartype","_car","_num","_tipped","_carpos","_type","_townpos"];
    
    _objPos = _this select 0;
    
    
    _Objtype = objectList call BIS_fnc_selectRandom; //picks a cartype
    _obj = createVehicle [_Objtype,_objPos,[], 50,"None"] ; 	// creates car
    _obj setpos [getpos _obj select 0,getpos _obj select 1,0];
	if(_Objtype == "Land_Barrel_water") then {_obj setVariable["water",20,true];};
	if(_Objtype == "Land_Bag_EP1") then {_obj setVariable["food",20,true];};
    
    if (cvg_debug == 2) then {
        _marker=createMarker [format ["mark%1",random 100000],getpos _obj];
        _marker setMarkerType "Dot";
        _marker setMarkerColor "ColorOrange";
        _marker setMarkerSize [1,1];
    };
    
*?