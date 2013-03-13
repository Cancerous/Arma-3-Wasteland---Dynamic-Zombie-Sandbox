/*
	@file Version: 1D
	@file name: conKilled.sqf
	@file Author: TAW_Tonic
	@file edit: 9/8/2012
	@file description: When killed unit drops whatever items he had
*/

_player = (_this select 0) select 0;
_killer = (_this select 0) select 1;
_player removeAction 0;

if(!local _player) exitwith {};

private["_a","_b","_c","_d","_e","_f","_m","_player","_killer"];

if(dzs_canfood > 0) then {

for "_c" from 1 to dzs_canfood do
{	
_m = "Land_Bag_EP1" createVehicle (position _player);
};
};

if(dzs_water > 0) then {

for "_f" from 1 to dzs_water do
{	
	_m = "Land_Teapot_EP1" createVehicle (position _player);
};
};

//Drop Rabit meat if unit has it
[_player,dzs_rabit,true,"rabit"] call dzs_fnc_dropFood;
[_player,dzs_rabit_c,false,"rabit"] call dzs_fnc_dropFood;
//Drop Goat meat if unit has it
[_player,dzs_goat,true,"goat"] call dzs_fnc_dropFood;
[_player,dzs_goat_c,false,"goat"] call dzs_fnc_dropFood;
//Drop Cow meat if unit has it
[_player,dzs_cow,true,"cow"] call dzs_fnc_dropFood;
[_player,dzs_cow_c,false,"cow"] call dzs_fnc_dropFood;
//Drop Boar meat if unit has it
[_player,dzs_boar,true,"boar"] call dzs_fnc_dropFood;
[_player,dzs_boar_c,false,"boar"] call dzs_fnc_dropFood;
//Drop Chicken meat if unit has it
[_player,dzs_chicken,true,"chicken"] call dzs_fnc_dropFood;
[_player,dzs_chicken_c,false,"chicken"] call dzs_fnc_dropFood;