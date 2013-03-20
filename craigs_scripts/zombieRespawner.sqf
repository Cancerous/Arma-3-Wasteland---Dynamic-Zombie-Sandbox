		usedBuildings = [];
		sleep 15;
		if (!isDedicated) then {
			terminate zgenFSM;
			zgenFSM =[] execFSM "craigs_scripts\zombieGenerator2.FSM"; //[] spawn genZeds; //
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