		usedBuildings = [];
		sleep 15;
		if (!isDedicated) then {
			[] execFSM "craigs_scripts\zombieGenerator2.FSM"; //[] spawn genZeds; //
			while {alive player} do {
				if (count usedBuildings != 0) then {
					{
						if (_x distance player > 500) then { usedBuildings = usedBuildings - [_x]};
					} forEach usedBuildings;
				};
				//hint "starting spawning";
				sleep 600;
				usedBuildings = [];
			};
		};