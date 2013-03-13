       _guns = 0;
	   	   diag_log "Starting building weapons";
	   {
	
		   //building is the current building selected in the forEach loop
            _building = _x;
            //Find the positions, function by Rube
            _positions = _building call fn_getBuildingPositions;
			diag_log format ["Positions: %1",_positions];
            //check if that chosen position is an empty array, with array compare function
            _check1 = [_positions, []] call arrayCompare;
            if (!_check1) then {
                if ((typeOf _building) in militaryWeaponBuildings) then {
                    if (count _positions > 1) then {
                        _numberOfPositions = 0;
                        _randomNumber = (1+(floor (random (count _positions))));
                        _totalPositionsAvailable = (_positions);
                        while {_numberOfPositions <= _randomnumber} do {
                            _posnumber = floor (random (count _totalPositionsAvailable));
                            _rightonthedot = _totalPositionsAvailable select _posnumber;
                            //spawn the weapons randomly
                            _weapon = CVG_Weapons call BIS_fnc_selectRandom;
                            //find that weapons magazines
                            _mag=(getArray (configFile/"Cfgweapons"/_weapon/"magazines")) select 0;
                            //create the holder
                            _weap = createVehicle ["groundWeaponHolder", [0,0], [], 0, "CAN_COLLIDE"];
							_guns = _guns + 1;
                            //add the magazine
                            _weap addMagazineCargoGlobal [_mag,1+(floor(random 10))];
                            //add the weapon
                            _weap addWeaponCargoGlobal [_weapon,1+(round(random .55))];
                            //set the weapon holder to the position (cant create it on the exact spot, setpos is needed
                           
                            if (((typeOf _building) == ("Land_Mil_Barracks_i")) || ((typeOf _building) == ("Land_Mil_Barracks_i_EP1")) && (count _rightOnTheDot < 2)) then {
                                _weap setPos _rightonthedot;
                                _weap setPos [getPos _weap select 0, getPos _weap select 1,(getPos _weap select 2) - .14];
                            }
                            else
                            {
                                _weap setPos _rightonthedot;
                            };
							
                            //take another position out of the list:    NOTE! OH CRAP! YOU CAN't REMOVE ARRAYS FROM ARRAYS WORKAROUND TIME! Serendipity
                            _totalPositionsAvailable set [_posnumber,20];
                            _totalPositionsAvailable = _totalPositionsAvailable - [20];
                            //add one to the number of positions
                            _numberOfPositions = _numberOfPositions + 1;
							
                        };
                    }
                    else
                    {
                        //Pick a random position
                        _posnumber = floor (random (count _positions));
                        //Select that position
                        _rightonthedot = _positions select _posnumber;
                        //spawn the weapons randomly
                        _weapon = CVG_Weapons call BIS_fnc_selectRandom;
                        //find that weapons magazines
                        _mag=(getArray (configFile/"Cfgweapons"/_weapon/"magazines")) select 0;
                        //create the holder
                        _weap = createVehicle ["groundWeaponHolder", [0,0], [], 0, "CAN_COLLIDE"];
							_guns = _guns + 1;
                        //add the magazine
                        _weap addMagazineCargoGlobal [_mag,1+(floor(random 10))];
                        //add the weapon
                        _weap addWeaponCargoGlobal [_weapon,1+(round(random .55))];
                        //set the weapon holder to the position (cant create it on the exact spot, setpos is needed
                        _weap setPos _rightonthedot;
                    };
                } 
                else
                {
					if ((count _positions) > 3) then 
					{
						// The above has been changed for testing
						//Pick a random position
						_posnumber = floor (random (count _positions));
						//Select that position
						_rightonthedot = _positions select _posnumber;
						//spawn the weapons randomly
						_weapon = CVG_Weapons call BIS_fnc_selectRandom;
						//find that weapons magazines
						_mag=(getArray (configFile/"Cfgweapons"/_weapon/"magazines")) select 0;
						//create the holder
						_weap = createVehicle ["groundWeaponHolder", [0,0], [], 0, "CAN_COLLIDE"];
							_guns = _guns + 1;
						//add the magazine (Magazine should always be first)
						_weap addMagazineCargoGlobal [_mag,1+(floor(random 5))];
						//add the weapon
						_weap addWeaponCargoGlobal [_weapon,1+(round(random .55))];
						//set the weapon holder to the position (cant create it on the exact spot, setpos is needed
						_weap setPos _rightonthedot;
						if (CVG_Debug == 2) then {
							_marker=createMarker [format ["mar%1",random 100000],_rightonthedot];
							_marker setMarkerType "Dot";
							_marker setMarkerColor "ColorBrown";
							_marker setMarkerSize [2,2];
						};
					};
                };
            };  
		} forEach buildings;	
		diag_log format ["Number of weapons spawned: %1",_guns];
	   diag_log "Buliding weapons done!";
		CVG_weaponDone = true;