#include "dialog\defines.sqf"; 
if(isnil {waste_money}) then {waste_money = 0;};
_weaponDialog = createDialog "gunshopd";

disableSerialization;

_Dialog = findDisplay gunshop_DIALOG;
_zbandages = _Dialog displayCtrl gunshop_money;
_zbandages CtrlsetText format["Cash: $%1", waste_money];
gsLocation = str(_this select 0);

if(gsLocation == "gs1") then {gsLocation = g_ammo_1;};
if(gsLocation == "gs2") then {gsLocation = g_ammo_2;};
if(gsLocation == "gs3") then {gsLocation = g_ammo_3;};
if(gsLocation == "gs4") then {gsLocation = g_ammo_4;};