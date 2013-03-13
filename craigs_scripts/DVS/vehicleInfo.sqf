//determines the vehicles random properties

private ["_marker","_cartype","_car","_num","_tipped","_carpos","_type","_townpos","_number"];
_type = _this select 1;
_townpos = _this select 0;
if (_type == 0) then {
	if (vehSpawnType == 0) then {
		_num = random 100;
		if (_num < 30) then {_cartype = cars call BIS_fnc_selectRandom;} else {_cartype = cars call BIS_fnc_selectRandom;};
	} else {
		_cartype = cars call BIS_fnc_selectRandom; //picks a cartype
	};
    _car = createVehicle [_cartype,_townpos,[], 30,"None"] ; 	// creates car
    clearMagazineCargoGlobal _car;
    clearWeaponCargoGlobal _car;
    if (CVG_Debug == 2) then {
        _marker=createMarker [format ["mark%1",random 100000],getpos _car];
        _marker setMarkerType "Dot";
        _marker setMarkerColor "ColorBlue";
        _marker setMarkerSize [1,1];
    };
    switch (CVG_VehicleStatus) do {
        case 1:
        {
            _car setFuel ((random .2)+.6);
            _car setDamage (random .2);
        };
        case 2:
        {
            _car setFuel ((random .3)+.3);
            _car setDamage ((random .3)+.3);
        };
        case 3:
        {
			_car setFuel ((random .2) +.1);
            _car setDamage ((random .4) +.5);

        };
        case 4: 
        {
			_car setFuel ((random .9)+.1);
            _car setDamage (random .9);
        }
    };
    _car setDir (random 360);
    _num = (random 100);
    if (_num < 0.5) then { _car addWeaponCargoGlobal ["ItemMap",1];};
    _car setVehicleAmmo (random .2);
    _tipped = (random 100);
    if (_tipped < 10) then {_car setVectorUp [0,1,0]};//simulates chaos, rioting, zombies pushing cars over 
    
    if (CVG_weaponcount != 101) then {
        _number = floor (random 100);
        if (_number < CVG_weaponcount) then {
            [_car] call RandomWeapons;
        };
    } else {
        [_car] call RandomWeapons;
    };
    
} ;

if (_type == 1) then {
    if (vehspawntype == 0) then {
        _cartype = militaryvehs call BIS_fnc_selectRandom; //picks a cartype
    } else {
        _cartype = cars call BIS_fnc_selectRandom; //picks a cartype
    };
    _car = createVehicle [_cartype,_townpos, [], 30, "None"] ; 	// creates car
    clearMagazineCargoGlobal _car;
    clearWeaponCargoGlobal _car;
    if (CVG_Debug == 2) then {
        _marker=createMarker [format ["mark%1",random 100000],getpos _car];
        _marker setMarkerType "Dot";
        _marker setMarkerColor "ColorBlack";
        _marker setMarkerSize [1,1];
    };
    
      switch (CVG_VehicleStatus) do {
        case 1:
        {
            _car setFuel ((random .2)+.6);
            _car setDamage (random .2);
        };
        case 2:
        {
            _car setFuel ((random .3)+.3);
            _car setDamage ((random .3)+.3);
        };
        case 3:
        {
			_car setFuel ((random .2) +.1);
            _car setDamage ((random .4) +.5);

        };
        case 4: 
        {
			_car setFuel ((random .9)+.1);
            _car setDamage (random .9);
        }
    };
    
    _car setDir (random 360);
    
    _num = (random 100);
    if (_num < 1) then { _car addWeaponCargoGlobal ["ItemMap",1];};
    _car setVehicleAmmo (random .2);
    _tipped = (random 100);
    if (_tipped < 10) then {_car setVectorUp [0,1,0]};//simulates chaos, rioting, zombies pushing cars over 
    
    if (CVG_weaponcount != 101) then {
        _number = floor (random 100);
        if (_number < CVG_weaponcount) then {
            [_car] call RandomWeapons;
        };
    };
    _carpos = getpos _car;
    _car setpos _carpos;
};