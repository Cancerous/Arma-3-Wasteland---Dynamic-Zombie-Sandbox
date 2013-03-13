#include "dialog\defines.sqf";
#include "weaponlist.sqf";
disableSerialization;

_switch = _this select 0;

_dialog2 = findDisplay gunshop_DIALOG;
_gunlisttext = _dialog2 displayCtrl gunshop_gun_TEXT;
_gunlist = _dialog2 displayCtrl gunshop_gun;
_magtext = _dialog2 displayCtrl gunshop_mags_text;
_ammodialog = _dialog2 displayCtrl gunshop_mags;
_gunpicture = _dialog2 displayCtrl gunshop_gun_pic;
_guninfotxt = _dialog2 displayCtrl gunshop_gun_info;
_ammoamount = lbCurSel _ammodialog;
_gunInfo = Lbselection _gunlist select 0;
if(isNil {_gunInfo}) then { _gunInfo = 0;};
_weap_type = ((weaponsArray select _gunInfo) select 1);
_weapon = (configFile >> "cfgWeapons" >> _weap_type);
_picture = getText(_weapon >> "picture");
_library = getText(_weapon >> "Library" >> "libTextDesc");

switch(_switch) do 
{
	case 0: 
	{
		_price = (weaponsArray select _gunInfo) select 2;
		_lb = parsetext "<br/>";
		_text = composeText ["Gun Information:",_lb,parseText _library];
		_guninfotxt ctrlSetStructuredText _text;
		_gunpicture ctrlSettext _picture;
		_gunlisttext ctrlSetText format ["Price: $%1", _price];
	};
	
	case 1:
	{
		_ammoInfo = lbText[gunshop_mags, _ammoamount];
		_price2 = (weaponsArray select _gunInfo) select 4;
		_newprice = (parseNumber _ammoInfo)*_price2;
		_magtext ctrlSetText format ["Price: $%1", _newprice];
	};
};
		