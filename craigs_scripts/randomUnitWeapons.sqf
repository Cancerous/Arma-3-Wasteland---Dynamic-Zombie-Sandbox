/*
Weapons script by Craig
Free to use and modify, crediting not required
Classnames put into string form (a very annoying/laborous task) by Dominic/Genesis
*/




private ["_car","_weapons","_mags","_rnd","_weapon","_mag","_num","_i","_currweapon","_type","_muzzles","_hasRightWeapon"];
if (player != player) then {
    waitUntil {player == player};
    waitUntil {time > 10};
};


sleep 0.01;
private ["_car","_weapons","_mags","_rnd","_weapon","_mag"];

waitUntil {local Player};
_car = _this select 0;
removeAllWeapons _car;

//Does some randomnessness

if (CVG_weapontype == 6) then {
	_num = floor (random 100);
	if (_num < 100) then {CVG_weapons = CVG_pistols};
	if (_num < 50) then {CVG_weapons = CVG_Rifles};
	if (_num < 25) then {CVG_weapons = CVG_Scoped};
	if (_num < 10) then {CVG_weapons = CVG_Heavy};
};
    
    _rnd = random floor (count CVG_weapons);

    _weapon = CVG_weapons select _rnd;
    _mag=(getArray (configFile/"CfgWeapons"/_weapon/"magazines")) select 0;

//Add guns and magazines, note the Global at the end...
removeAllWeapons _car;
for [{_i=1},{_i<=8},{_i=_i+1}] do {
    _car addMagazine _mag;
};
_car addWeapon _weapon;



_type = _weapon;
// check for multiple muzzles (eg: GL)
_muzzles = getArray(configFile >> "cfgWeapons" >> _type >> "muzzles");

if (count _muzzles > 1) then
{
    player selectWeapon (_muzzles select 0);
}
else
{
    player selectWeapon _type;
};





if (CVG_Debug == 2) then {
    player sidechat FORMAT ["Weapon chosen, %1",_weapon];
};

_hasRightWeapon = 0;
while {_hasRightWeapon == 0} do {
    _currweapon = currentWeapon player;
    sleep 0.001;
    if (_currweapon != _type) then {
    	diag_log "Player does not have correct weapon";
        if (count _muzzles > 1) then
        {
            player selectWeapon (_muzzles select 0);
        }
        else
        {
            player selectWeapon _type;
        };
    }
    else
    {
        _hasRightWeapon = 1;
    };
};
diag_log "Player has the correct weapon";

