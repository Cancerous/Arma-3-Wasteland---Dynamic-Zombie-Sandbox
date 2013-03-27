//This script updates the player list and cleans up unitless groups
if (!isServer) exitWith {};
terminate CLYupdateHandle;
CLYupdateHandle = [] spawn {
	waitUntil {!isNil "CLY_deadcharacters"};

	while {true} do
	{
		//Build player array
		CLY_zombievictims = [];
		if (isMultiplayer) then
		{
			CLY_players = playableUnits;
			if (count CLY_players == 0) then {CLY_players = allUnits;};
			{
				if (!isPlayer _x || !isNil {_x getVariable "spectating"} || vehicleVarName _x in CLY_deadcharacters) then
				{
					CLY_players = CLY_players - [_x];
				};
			} forEach CLY_players;
		}
		else
		{
			CLY_players = [player];
		};
		
		publicVariable "CLY_players";
		
		//Determine viable zombie victims
		if (!CLY_cutscene) then
		{
			{
				_unit = _x;
				if (_unit getVariable ["zombievictim", false]) then
				{
					if (getPos vehicle _unit select 2 < 10) then
					{
						CLY_zombievictims set [count CLY_zombievictims, _unit];
					};
				};
			} forEach allUnits;
		};
		
		//Delete unused groups
		{
			if (count units _x == 0) then {deleteGroup _x;};
		} forEach allGroups;
		
		sleep 5;
	};
};