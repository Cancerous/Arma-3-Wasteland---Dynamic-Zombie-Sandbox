disableSerialization;

sleep 3;

2 cutRsc ["bandagehud", "PLAIN"];
_bandageui = uiNamespace getVariable "bandagehud";
_bandagehud = _bandageui displayCtrl 235;
1 cutRsc ["namehud", "PLAIN"];
_nameui = uiNamespace getVariable "namehud";
_namehud = _nameui displayCtrl 235;
_nameclawhud = _nameui displayCtrl 236;

_namehud ctrlSetTextColor [1, 0.5, 0.5, 0.6];

while {true} do
{
	_unit = player getVariable ["spectating", player];
	if (CLY_cutscene) then
	{
		_bandagehud ctrlSetText "";
		_bandagehud ctrlCommit 0;
		_namehud ctrlSetText "";
		_namehud ctrlCommit 0;
		waitUntil {!CLY_cutscene};
	};
	//Damage
	if (damage _unit > 0.28) then
	{
		3 cutRsc ["clawhud", "PLAIN"];
		_ui = uiNamespace getVariable "clawhud";
		_hud = _ui displayCtrl 235;
		_hud ctrlSetPosition [safeZoneX + safeZoneW - 0.06, safeZoneY + safeZoneH - 0.1];
		_claw = "";
		if (damage _unit > 0.28) then {_claw = "claw1.paa";};
		if (damage _unit > 0.59) then {_claw = "claw2.paa";};
		if (damage _unit > 0.9) then {_claw = "claw3.paa";};
		_hud ctrlSetText _claw;
		_hud ctrlCommit 0;
	};
	//Bandages
	if (!isNil {_unit getVariable "CLY_heal_bandages"}) then
	{
		if (_unit getVariable "CLY_heal_bandages" >= 0) then
		{
			_bandagehud ctrlSetPosition [safeZoneX + safeZoneW - 0.12, safeZoneY + safeZoneH - 0.02];
			_bandagehud ctrlSetText format ["Bandages: %1", _unit getVariable "CLY_heal_bandages"];
			_bandagehud ctrlCommit 0;
		};
	}
	else
	{
		_bandagehud ctrlSetText "";
		_bandagehud ctrlCommit 0;
	};
	//Names
	_name = false;
	if (CLY_shownames) then
	{
		if (!visibleMap) then
		{
			if (cursorTarget isKindOf "Man") then
			{
				if (alive cursorTarget) then
				{
					if (_unit countFriendly [cursorTarget] == 1) then
					{
						if (isPlayer cursorTarget) then
						{
							_name = true;
							_namehud ctrlSetPosition [0.2, safeZoneY + safeZoneH - 0.22];
							_namehud ctrlSetText name cursorTarget;
							_namehud ctrlCommit 0;
							if (damage cursorTarget > 0.28) then
							{
								_claw = "claw1.paa";
								if (damage cursorTarget > 0.59) then {_claw = "claw2.paa";};
								_nameclawhud ctrlSetPosition [0.485, safeZoneY + safeZoneH - 0.19];
								_nameclawhud ctrlSetText _claw;
								_nameclawhud ctrlCommit 0;
							}
							else
							{
								_nameclawhud ctrlSetText "";
								_nameclawhud ctrlCommit 0;
							};
						};
					};
				};
			};
		};
	};
	if (!_name) then
	{
		_namehud ctrlSetText "";
		_namehud ctrlCommit 0;
		_nameclawhud ctrlSetText "";
		_nameclawhud ctrlCommit 0;
	};
	sleep 0.01;
};