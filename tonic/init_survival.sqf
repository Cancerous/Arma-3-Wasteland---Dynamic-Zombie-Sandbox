[] spawn  {
	while{true} do
	{
		sleep 300;
		if(hungerlvl < 2) then {player setDamage 1; hint "You have starved to death.";}
		else
		{
		hungerlvl = hungerlvl - 10;
		if(hungerlvl < 2) then {player setDamage 1; hint "You have starved to death.";};
		switch(hungerlvl) do {
			case 50: {hint format["You haven't eaten anything in awhile, your hunger level is currently: %1\n\n You should find something to eat soon!", hungerlvl];};
			case 30: {hint format["You haven't eaten anything in awhile, your hunger level is currently: %1\n\n You should find something to eat soon!", hungerlvl];};
			case 20: {hint format["You are starting to starve, you need to find something to eat otherwise you will start to lose health!", hungerlvl];};
			case 10: {hint format["You are now starving to death, you will slowly lose health, find something to eat quickly!", hungerlvl]; player setDamage (damage player)*0.4;};
			};
		};
	};
};

[] spawn  {
	while{true} do
	{
	sleep 200;
	if(thirstlvl < 2) then {player setDamage 1; hint "You have died from dehydration.";}
	else
	{
		thirstlvl = thirstlvl - 10;
		if(thirstlvl < 2) then {player setDamage 1; hint "You have died from dehydration.";};
		switch(thirstlvl) do {
			case 50: {hint format["You haven't drank anything in awhile, your thirst level is %1", thirstlvl];};
			case 30: {hint format["You haven't drank anything in awhile, your thirst level is %1\n\nYou should find something to drink soon.", thirstlvl];};
			case 20: {hint format["You haven't drank anything in along time, you should find someting to drink soon or you'll start to die from dehydration", thirstlvl];};
			case 10: {hint format["You are now suffering from severe dehydration find something to drink quickly!", thirstlvl]; player setDamage (damage player)*0.4;};
			};
		};
	};
};

