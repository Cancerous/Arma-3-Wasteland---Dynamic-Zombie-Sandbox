/*
	CLY Heal - a self-bandaging script
	Version 2012.8.11
	
	-How to use-
	Execute in init script:
		[player, 0.2, 0, 3, true] execVM "cly_heal.sqf";
	The first number is the damage threshold after which you are given the option to heal.
	The second one is the player's damage after healing.
	The third one is the number of bandages. -1 is unlimited.
	The boolean at the end is optional, setting it to true will make the bandaging action
	pop up when the player is injured. It's false by default.
	
	How to add bandages to a unit:
		unit setVariable ["CLY_heal_bandages", this getVariable "CLY_heal_bandages" + 1, true]
	Make an AI unit drop bandages when it dies:
		0 = [this, 0, 0, 1] execVM "cly_heal.sqf";
	
	If you don't like the special font, leave the _structure string empty.
*/

_target = _this select 0;
_caller = _this select 1;
_id = _this select 3;

_structure = "<t font = 'EtelkaMonospaceProBold' size = '0.8' color = '#88ff5555'>";

//Add PVEHs
if (isNil "CLY_heal_firstrun") then
{
	CLY_heal_firstrun = true;
	"CLY_heal_interruptpv" addPublicVariableEventHandler
	{
		_var = _this select 1;
		_var select 0 switchMove (_var select 1);
		_var select 0 playMoveNow (_var select 1);
	};
	"CLY_heal_announcepv" addPublicVariableEventHandler
	{
		_var = _this select 1;
		_unit = _var select 0;
		_text = _var select 1;
		if (player == _unit) then
		{
			titleText _text;
		};
	};
};

//Give bandage
if (_id in ["give"]) then
{
	_caller setVariable ["CLY_heal_bandages", (_caller getVariable "CLY_heal_bandages") - 1, true];
	_target setVariable ["CLY_heal_bandages", (_target getVariable "CLY_heal_bandages") + 1, true];
	titleText [format ["Bandage given to %1", name _target], "PLAIN DOWN", 0.3];
	_text = [format ["Received bandage from %1", name _caller], "PLAIN DOWN", 0.3];
	CLY_heal_announcepv = [_target, _text];
	publicVariable "CLY_heal_announcepv";
};

//Interrupt healing
if (_id in ["interrupt"]) then
{
	_caller setVariable ["CLY_heal_interrupt", true];
};

//Take bandage
if (_id in ["take"]) then
{
	_taken = _target getVariable ["CLY_heal_bandages", 0];
	_caller setVariable ["CLY_heal_bandages", (_caller getVariable "CLY_heal_bandages") + _taken, true];
	_target setVariable ["CLY_heal_bandages", 0, true];
	_s = if (_taken > 1) then {"s";} else {"";};
	titleText [format ["%1 bandage%2 taken", _taken, _s], "PLAIN DOWN", 0.3];
	_target removeAction (_target getVariable ["CLY_heal_takeaction", 0]);
	_target setVariable ["CLY_heal_takeaction", nil];
};

//Heal self or other
if (_id in ["heal", "healother"]) then
{
	_weapontype = getNumber (configFile / "CfgWeapons" / (currentWeapon _caller) / "type");
	_weapontypes = [];
	{_weapontypes set [count _weapontypes, getNumber (configFile / "CfgWeapons" / _x / "type")]} forEach weapons _caller;
	
	_anim = "ainvpknlmstpsnonwnondnon_medic_2";
	if (_weapontype in [1, 5] || (_weapontype == 0 && {_x in [1, 5]} count _weapontypes > 0)) then {_anim = "ainvpknlmstpslaywrfldnon_medic";};
	if (_weapontype == 2 || (_weapontype == 0 && 2 in _weapontypes)) then {_anim = "ainvpknlmstpsnonwnondnon_medic_1";};
	
	if (_id == "healother") then
	{
		_text = [format ["%1 is bandaging you", name _caller], "PLAIN DOWN", 0.3];
		CLY_heal_announcepv = [_target, _text];
		publicVariable "CLY_heal_announcepv";
	};
	
	_caller playMove _anim;
	_caller say ["bandageRip",5];
	_caller setVariable ["CLY_heal_cooldown", time + 5];
	_caller setVariable ["CLY_heal_interrupt", false];
	
	waitUntil {animationState _caller in ["ainvpknlmstpslaywrfldnon_medic", "ainvpknlmstpsnonwnondnon_medic_1", "ainvpknlmstpsnonwnondnon_medic_2"]};
	waitUntil {_caller getVariable "CLY_heal_interrupt" || !alive _target || _caller distance _target > 3 || !(animationState _caller in ["ainvpknlmstpslaywrfldnon_medic", "ainvpknlmstpsnonwnondnon_medic_1", "ainvpknlmstpsnonwnondnon_medic_2"])};
	if (alive _caller) then
	{
		//Heal
		if (alive _target && !(_caller getVariable "CLY_heal_interrupt")) then
		{
			_healee = if (_id == "healother") then {_target;} else {_caller;};
			if (damage _healee > _caller getVariable "CLY_heal_threshold") then
			{
				_healee setDamage (_caller getVariable "CLY_heal_damage");
				_caller setVariable ["CLY_heal_bandages", (_caller getVariable "CLY_heal_bandages") - 1, true];
			};
			//Heal legs
			if (!canStand _healee) then
			{
				_healee setHit ["legs", _caller getVariable "CLY_heal_damage"];
				_caller setVariable ["CLY_heal_bandages", (_caller getVariable "CLY_heal_bandages") - 1, true];
			};
		//Interrupt healing
		}
		else
		{
			_caller setVariable ["CLY_heal_interrupt", false];
			_anim = "ainvpknlmstpslaywrfldnon_amovpknlmstpsnonwnondnon";
			if (_weapontype in [1, 5]) then {_anim = "ainvpknlmstpslaywrfldnon_amovpknlmstpsraswrfldnon";};
			if (_weapontype == 2) then {_anim = "ainvpknlmstpsnonwnondnon_amovpknlmstpsraswpstdnon";};
			if (_weapontype == 4) then {_anim = "amovpknlmstpsnonwnondnon_amovpknlmstpsraswlnrdnon";};
			CLY_heal_interruptpv = [_caller, _anim];
			publicVariable "CLY_heal_interruptpv";
			_caller switchMove _anim;
			_caller playMoveNow _anim;
		};
	};
};

//Main loop
while {typeName _id == "SCALAR"} do
{
	if (!local _target) exitWith {};
	_healthreshold = _this select 1;
	_healdamage = _this select 2;
	_healings = floor (_this select 3);
	_popup = if (count _this > 4) then {_this select 4;} else {false;};
	CLY_heal_anims = ["amovpknlmstpsraswrfldnon_ainvpknlmstpslaywrfldnon", "ainvpknlmstpslaywrfldnon_medic", "ainvpknlmstpslaywrfldnon_amovpknlmstpsraswrfldnon", "amovpknlmstpsraswpstdnon_ainvpknlmstpsnonwnondnon", "amovpknlmstpsraswpstdnon_ainvpknlmstpsnonwnondnon_end", "ainvpknlmstpsnonwnondnon_medic_1", "ainvpknlmstpsnonwnondnon_amovpknlmstpsraswpstdnon", "amovpknlmstpsraswlnrdnon_ainvpknlmstpsnonwnondnon", "ainvpknlmstpsnonwnondnon_medic_2", "amovpknlmstpsnonwnondnon_amovpknlmstpsraswlnrdnon"];
	
	//Add bandages to AI, then exit
	if (_target != player) exitWith
	{
		_target setVariable ["CLY_heal_bandages", _healings, true];
	};
	
	waitUntil {alive player};
	_unit = player;
	
	if (isNil {_unit getVariable "CLY_heal_bandages"}) then {_unit setVariable ["CLY_heal_bandages", _healings, true];};
	if (isNil {_unit getVariable "CLY_heal_threshold"}) then {_unit setVariable ["CLY_heal_threshold", _healthreshold];};
	if (isNil {_unit getVariable "CLY_heal_damage"}) then {_unit setVariable ["CLY_heal_damage", _healdamage];};
	if (isNil {_unit getVariable "CLY_heal_cooldown"}) then {_unit setVariable ["CLY_heal_cooldown", time - 5];};
	if (isNil {_unit getVariable "CLY_heal_interrupt"}) then {_unit setVariable ["CLY_heal_interrupt", false];};
	
	_healaction = 100;
	_interruptaction = 100;
	_reset = true;
	
	while {alive _unit && _unit == player} do
	{
		//Reset actions
		if (_reset) then
		{
			_unit removeAction _healaction;
			_unit removeAction _interruptaction;
			
			_healaction = _unit addAction
			[
				format ["%1Bandage wounds", _structure],
				"cly_heal.sqf", 
				"heal",		//Argument
				1.37,		//Priority
				_popup,		//Action pops up?
				true,		//Hide on use
				"",			//Shortcut
				"_this == _target && (damage _this > _this getVariable 'CLY_heal_threshold' || !canStand _this) && !(animationState _this in CLY_heal_anims) && time > _this getVariable ['CLY_heal_cooldown', time] && _this getVariable ['CLY_heal_bandages', 0] != 0"
			];
			_interruptaction = _unit addAction
			[
				format ["%1Cancel bandaging", _structure],
				"cly_heal.sqf",
				"interrupt",
				1.4,
				true,
				true,
				"",
				"_this == _target && animationState _target in ['ainvpknlmstpslaywrfldnon_medic', 'ainvpknlmstpsnonwnondnon_medic_1', 'ainvpknlmstpsnonwnondnon_medic_2']"
			];
			_reset = false;
		};
		
		//Add and remove heal, give and take actions
		{
			if (_x != _unit) then
			{
				if (alive _x && _x isKindOf "Man") then
				{
					if (isNil {_x getVariable "CLY_heal_healotheraction"}) then
					{
						if (_unit countEnemy [_x] == 0 && _x countEnemy [_unit] == 0) then
						{
							_healotheraction = _x addAction
							[
								format ["%1Bandage %2", _structure, name _x],
								"cly_heal.sqf",
								"healother",
								1.38,
								true,
								true,
								"",
								"_this != _target && alive _target && (damage _target > _this getVariable 'CLY_heal_threshold' || !canStand _target) && !(animationState _this in CLY_heal_anims) && time > _this getVariable ['CLY_heal_cooldown', time] && _this getVariable ['CLY_heal_bandages', 0] != 0 && _this distance _target < 3"
							];
							_x setVariable ["CLY_heal_healotheraction", _healotheraction];
						};
					};
					if (isNil {_x getVariable "CLY_heal_giveaction"}) then
					{
						if (!isNil {_x getVariable "CLY_heal_bandages"}) then
						{
							if (_unit countEnemy [_x] == 0 && _x countEnemy [_unit] == 0) then
							{
								_giveaction = _x addAction
								[
									format ["%1Give bandage to %2%3", _structure, name _x],
									"cly_heal.sqf",
									"give",
									1.39,
									true,
									true,
									"",
									"_this != _target && alive _target && !(animationState _this in CLY_heal_anims) && _target getVariable ['CLY_heal_bandages', -1] >= 0 && _this getVariable ['CLY_heal_bandages', 0] > 0 && _this distance _target < 3"
								];
								_x setVariable ["CLY_heal_giveaction", _giveaction];
							};
						};
					};
				}
				else
				{
					if (isNil {_x getVariable "CLY_heal_takeaction"}) then
					{
						if (_x getVariable ["CLY_heal_bandages", 0] > 0) then
						{
							_takeaction = _x addAction
							[
								format ["%1Take bandage%2", _structure, if (_x getVariable ["CLY_heal_bandages", 1] > 1) then {"s"} else {""}], 
								"cly_heal.sqf", 
								"take", 
								1.4, 
								true, 
								true, 
								"", 
								"_this != _target && !alive _target && _this distance _target < 4 && _this getVariable ['CLY_heal_bandages', -1] >=0 && _target getVariable ['CLY_heal_bandages', 0] > 0 && !(_this isKindOf 'Animal')"
							];
							_x setVariable ["CLY_heal_takeaction", _takeaction];
						};
					};
					//Remove useless actions from corpses
					if (!isNil {_x getVariable "CLY_heal_healotheraction"}) then
					{
						_x removeAction (_x getVariable "CLY_heal_healotheraction");
						_x setVariable ["CLY_heal_healotheraction", nil];
					};
					if (!isNil {_x getVariable "CLY_heal_giveaction"}) then
					{
						_x removeAction (_x getVariable "CLY_heal_giveaction");
						_x setVariable ["CLY_heal_giveaction", nil];
					};
					if (!isNil {_x getVariable "CLY_heal_takeaction"}) then
					{
						if (_x getVariable ["CLY_heal_bandages", 0] == 0) then
						{
							_x removeAction (_x getVariable "CLY_heal_takeaction");
							_x setVariable ["CLY_heal_takeaction", nil];
						};
					};
				};
			};
		} forEach (getPosATL _unit nearObjects ["All", 10]);

	sleep 0.01;
	};
	
	//Remove actions at death or unit switch
	_unit removeAction _healaction;
	_unit removeAction _interruptaction;
	
	//Take bandage from corpse action
	if (!alive _unit && _unit getVariable ["CLY_heal_bandages", 0] > 0) then
	{
		_action =
		[
			format ["%1Take bandage%2", _structure, if (_unit getVariable "CLY_heal_bandages" > 1) then {"s"} else {""}], 
			"cly_heal.sqf", 
			["take", _unit getVariable "CLY_heal_bandages"], 
			1.4, 
			true, 
			true, 
			"", 
			"_this != _target && !alive _target && _this distance _target < 4 && _this getVariable 'CLY_heal_bandages' >= 0 && !(_this isKindOf 'Animal')"
		];
		_unit addAction _action;
		CLY_healbandagepv = [_unit, _action];
		publicVariable "CLY_healbandagepv";
	};
	
	waitUntil {alive player};
	_target = player;
	_target setVariable ["CLY_heal_bandages", nil, true];
};