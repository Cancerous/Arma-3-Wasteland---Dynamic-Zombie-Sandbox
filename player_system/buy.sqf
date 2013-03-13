#include "dialog\defines.sqf";
#include "weaponlist.sqf";
if(isnil {waste_money}) then {waste_money = 0;};
disableSerialization;

_switch = _this select 0;

_dialog2 = findDisplay gunshop_DIALOG;
_gunlisttext = _dialog2 displayCtrl gunshop_gun_TEXT;
_gunlist = _dialog2 displayCtrl gunshop_gun;
_magtext = _dialog2 displayCtrl gunshop_mags_text;
_ammodialog = _dialog2 displayCtrl gunshop_mags;
_ammoamount = lbCurSel _ammodialog;
_gunInfo = Lbselection _gunlist select 0;
_zbandages = _dialog2 displayCtrl gunshop_money;
_invslots = [player] call BIS_fnc_invSlots;
_invfree = [player] call BIS_fnc_invSlotsEmpty;
_bandages = waste_money;
if(isNil {_gunInfo}) then { _gunInfo = 0;};

hint format ["%1", gslocation];

switch(_switch) do 
{
	case 0: 
	{
		_price = (weaponsArray select _gunInfo) select 2;
		if(_bandages < _price) exitwith {hint "You do not have enough cash"};
		waste_money = _bandages - _price;
		
		/*
		_weap_type = ((weaponsArray select _gunInfo) select 1);
		_type = getNumber(configFile >> "cfgWeapons" >> _weap_type >> "type");
		if (_type in [1,2,4,5]) then {
			{_cWepType = [getNumber(configFile >> "cfgWeapons" >> _x >> "type")];
			if (_cWepType select 0 in [1,5]) then {_cWepType = [1,5];};
			if (_type in _cWepType) then {
				player removeWeapon _x;
				_current_magazines = magazines player;
				_compatible_magazines = getArray(configFile >> "cfgWeapons" >> _x >> "magazines");
				{if (_x in _compatible_magazines) then {
					player removeMagazine _x;
				};} forEach _current_magazines;
			};} forEach (weapons player);
		};
		*/
		//player addWeapon _weap_type;
		gsLocation addWeaponCargoGlobal [((weaponsArray select _gunInfo) select 1),1];
		_zbandages CtrlsetText format["Cash: %1", waste_money];
	};
	
	case 1:
	{
		_ammoInfo = lbText[gunshop_mags, _ammoamount];
		_price2 = (weaponsArray select _gunInfo) select 4;
		if(!(_ammoInfo in ["1","2","3","4","5","6","7","8","9","10","11","12"])) exitwith {hint "You have not selected the amount of magazines you want.";};
		_tmp = (weaponsArray select _gunInfo) select 1;
		if(_tmp == "NVGoggles") exitwith {};
		_price = (parseNumber _ammoInfo)*_price2;
		if(_bandages < _price) exitwith {hint "You do not have enough cash"};
		waste_money = _bandages - _price;
		/*
		for[{_i=0}, {_i<=(parsenumber _ammoInfo)}, {_i=_i+1}] do {
			if(_tmp == "Javelin") then 
		{
			player addMagazine ((weaponsArray select _gunInfo) select 3);
		} else {	
		[player,((weaponsArray select _gunInfo) select 3),false] call BIS_fnc_invAdd;
		};
		};
		*/
		gsLocation addMagazineCargoGlobal [((weaponsArray select _gunInfo) select 3),(parseNumber _ammoInfo)];
	
		_zbandages CtrlsetText format["Cash: %1", waste_money];
	};
};
