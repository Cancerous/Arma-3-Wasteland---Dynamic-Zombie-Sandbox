
private ["_weapon","_mysterybox","_mag"];


// Price for ammo box will be $1000
if ((player getVariable "Points") >999) then {
boxOpen = 1; publicVariable "boxOpen";
[nil,nil,rplaySound,"mysterybox"] call RE;


_prev = player getVariable "Points";
player setVariable ["Points",(_prev-1000),true];

sleep 4;

_weapon = CVG_weapons call BIS_fnc_selectRandom;

mysterybox addWeaponCargoGlobal [_weapon,1];
_mag=(getArray (configFile/"Cfgweapons"/_weapon/"magazines")) select 0;
mysterybox addMagazineCargoGlobal [_mag, 4];

sleep 30;

clearWeaponCargo mysteryBox;
clearMagazineCargo mysteryBox;

boxOpen = 0; publicVariable "boxOpen";
} else {player sideChat "You don't have enough killpoints!"};