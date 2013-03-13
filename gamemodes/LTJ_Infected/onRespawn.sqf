
_unit = _this select 0;


//Clear Player
	_oldUnit = player;
	selectNoPlayer;
	_oldUnit setPosATL [0,0,0];
	
	if (_OldUnit == player) then {
		_oldUnit addEventHandler ["HandleDamage",{false}];
		_oldUnit enableSimulation false;
		_oldUnit disableAI "ANIM";
		_oldUnit disableAI "MOVE";
		} else {
	deleteVehicle _oldUnit;
	};

//Create New Character
	[player] joinSilent grpNull;
	_group = 	createGroup west;
	_player_aminals = ["WildBoar","Sheep","Cock","Rabbit","Fin","Goat","Pastor","Hen","Cow04","Cow03","Cow01","Cow02"];
	_aminal_type = _player_aminals call BIS_fnc_selectRandom;
	_newUnit = _group createUnit [_aminal_type,newPos,[],50,"CAN_COLLIDE"];
	_newUnit setDir _dir;
	addSwitchableUnit _newUnit;
	setPlayable _newUnit;
	
//Move player inside
	selectPlayer _newUnit;
	
	_newUnit addEventHandler ["HandleDamage",{false}];
	_newUnit setVariable ["victim",objNull,true]