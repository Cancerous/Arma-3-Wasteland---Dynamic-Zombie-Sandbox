#include "weaponlist.sqf"; //Include our weapon arrays with prices.
private["_switch","_player","_primary","_magazines","_magazine","_i","_weapon_value","_magPrice","_magSell"];
_player = player;

_primary = currentWeapon _player; //Fetch their current weapon in their hand...

		//Idiot doesn't have a gun, DENY HIM!
		if(isNil {_primary}) exitWith {hint "You don't have a current weapon in your hand to sell!";};
		
		//OK... Here is where we fetch the players magazine type because ArmA doesn't have a command to do exactly what I want and we want to ensure they sell the right shit....
		{
			if(_x in magazines _player) then
			{
				_magazine = _x;
			};
		} foreach (getArray (configFile >> "Cfgweapons" >> _primary >> "magazines"));
		
		_amount = {_x==_magazine} count magazines _player; //Amount of magazines.
		
		//Get the guns current value
		{
			if((_x select 0) == _primary) then
			{
				_weapon_value = _x select 1;
			};
		} foreach weaponSell;
		
		//If the gun doesn't have a value let's tell them the sad news and feed off delicious tears
		if(isNil {_weapon_value}) exitWith {hint "The current gun you have isn't sellable."};
		
		//Lets remove the weapon and magazines for it..
		_player removeWeapon _primary;
		_player removeMagazines _magazine;
		_magSell = 0;
		
		//Is it a javelin missle? If so let's set a value so they don't get ripped off and give me more tears to feed upon.
		if(_primary == "Javelin") then {
		_magPrice = 100;
		} else
		{
			_magPrice = round(random 5);
		};
		
		//Let's give them the cash for the gun....
		waste_money = waste_money + _weapon_value;
		
		//Let's calculate the cash for all their magazines.
		for "_i" from 1 to _amount do
		{
			_magSell = _magSell + _magPrice;
		};
		
		//Let's give them their cash for their magazines...
		waste_money = waste_money + _magSell;
		
		//Let's tell them what they sold, how much they got and how many magazines were sold etc.
		hint format["$%1 for %2\n$%3 for %4 magazine(s)\n\n You made a total of: $%5", _weapon_value, _primary, _magSell, _amount, _magSell + _weapon_value];
