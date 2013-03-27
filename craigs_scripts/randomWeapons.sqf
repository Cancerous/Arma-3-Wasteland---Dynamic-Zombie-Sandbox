/*
CVG_weapons script by Craig
Free to use and modify, crediting not required
Classnames put into string form (a very annoying/laborous task) by Dominic/Genesis
*/
private ["_car","_rnd","_weapon","_mag","_num"];
//Server check
if (!isServer) exitWith {};


//Grabs carname from array in execVM
_car = _this select 0;
//Sets up weapon array


if (CVG_weapontype == 6) then {
    _num = floor (random 100);
    if (_num < 100) then {CVG_weapons = CVG_pistols};
    if (_num < 50) then {CVG_weapons = CVG_Rifles};
    if (_num < 25) then {CVG_weapons = CVG_Scoped};
    if (_num < 10) then {CVG_weapons = CVG_Heavy};
};


// if enabled add NVGs
if (CVG_NVG == 2) then {
    _num = floor (random 100);
    if (_num < 10) then { _car addItemCargoGlobal ["NVgoggles", 1]};
};


//Does some randomessness

_rnd = random floor (count CVG_weapons);
_weapon = CVG_weapons select _rnd;

_mag=(getArray (configFile/"Cfgweapons"/_weapon/"magazines")) select 0;

//Add guns and magazines, note the Global at the end...
_car addMagazineCargoGlobal [_mag,(random 7)];
_car addWeaponCargoGlobal [_weapon,1];
