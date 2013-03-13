#include "dialog\defines.sqf";
#include "weaponlist.sqf";
disableSerialization;

if (local player) then {

	// Grab access to the controls
	_dialog = findDisplay gunshop_DIALOG;
	_gunlisttext = _dialog displayCtrl gunshop_gun_TEXT;
	_gunlist = _dialog displayCtrl gunshop_gun;
	_maglist = _dialog displayCtrl gunshop_mags;

	// Populate the view distance list box
	{_gunlistIndex = _gunlist lbAdd format["%1",_x select 0];} forEach weaponsArray;
	for [{_i=1}, {_i<=12}, {_i=_i+1}]
	do {
	_maglistIndex = _maglist lbAdd format["%1",_i];
	};
	
};