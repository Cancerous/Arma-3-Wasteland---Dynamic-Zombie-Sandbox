/*
	@file Version: 1D
	@file name: tonic\keyHandler.sqf
	@file Author: TAW_Tonic
	@file edit: 9/26/2012
	@file description: Handles keys pressed and processes them incase we have an action assigned to that key combination.
*/
private ["_handled","_shift","_alt","_code","_ctrl","_alt","_ctrlKey"];
_ctrl = _this select 0;
_code = _this select 1;
_shift = _this select 2;
_ctrlKey = _this select 3;
_alt = _this select 4;
_handled = false;

//Tlide key to pull up Player Menu
if(_code == 41) then
{
	[] call waste_fnc_pMenu;
};

_handled;
