
private ["_weapon","_weaponNumber","_weapon_type","_type","_mag"];

_weaponNumber = lbCurSel 1500;
if (((player getVariable "Points") >= ((weaponsArray select _weaponNumber) select 2)) or (name player == "Craig [DZS]")) then {
	_weapon_string = (weaponsArray select _weaponNumber) select 1;
	_weapon_type = (configFile >> "cfgWeapons" >> _weapon_string);
	_type = getNumber(_weapon_type >> "type");
	if (_type == 5) then {_type = 1};
	{
		_weapon = (configFile >> "cfgWeapons" >> _x);
		_weap_string = _x;
		if (_type == (getNumber(_weapon >> "type"))) then {
			player removeWeapon _weap_string;
			{
				if (_x == ((getArray (configFile/"CfgWeapons"/_weap_string/"magazines")) select 0)) then {
					player removeMagazine _x;
				};
			} forEach (magazines player);
		};
	} forEach (weapons player);



	_mag=(getArray (configFile/"CfgWeapons"/_weapon_string/"magazines")) select 0;

	_prev = player getVariable "Points";
	player setVariable ["Points",(_prev-((weaponsArray select _weaponNumber) select 2)),true];
	sleep .1;
	{player addMagazine _mag} forEach [1,2,3];
	player addWeapon _weapon_string;

	closedialog 0;
} else {player sideChat "You don't have enough killpoints!"};