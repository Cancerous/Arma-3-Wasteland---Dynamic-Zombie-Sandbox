//Puts a random number of weapons into the weapon crate sidemission.

private ["_weapon","_mag","_randomNumberToSpawn","_weapons","_crate","_WeaponNumber"];
_weapons = CVG_Weapons;
_crate = _this select 0;


_WeaponNumber = (round (CVG_WeaponCount / 3));


_randomNumberToSpawn = ((round (random 10)) + _WeaponNumber);
//Adjust this with parameter^

while {_randomNumberToSpawn != 0} do 
{
	//Pick a random weapons from the already defined list of weapons (defined in startup.sqf)
	_weapon = _weapons call BIS_fnc_selectRandom;
	//Put that weapon in the box:
	_mag=(getArray (configFile/"Cfgweapons"/_weapon/"magazines")) select 0;
	_crate addMagazineCargoGlobal [_mag,(round(random(12)))];
	_crate addWeaponCargoGlobal [_weapon,1];
	_randomNumberToSpawn = _randomNumberToSpawn - 1;
};	