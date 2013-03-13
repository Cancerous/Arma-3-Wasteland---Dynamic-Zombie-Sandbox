#include "dialog\player_sys.sqf";
disableSerialization;

private["_itemListIndex","_itemList"];

_dialog2 = findDisplay playersys_DIALOG;
_itemList = _dialog2 displayCtrl item_list;

if(dzs_water > 0) then {
_itemListIndex = _itemList lbAdd format["%1x - Water bottle", dzs_water];
_itemList lbSetData [(lbSize _itemList)-1, "water"];
};
if(dzs_canfood > 0) then {
_itemListIndex = _itemList lbAdd format["%1x - Canned Food", dzs_canfood];
_itemList lbSetData [(lbSize _itemList)-1, "canfood"];
};
if(dzs_rabit > 0) then {
_itemListIndex = _itemList lbAdd format["%1x - Raw Rabbit Meat", dzs_rabit];
_itemList lbSetData [(lbSize _itemList)-1, "rabitmeat"];
};
if(dzs_rabit_c > 0) then {
_itemListIndex = _itemList lbAdd format["%1x - Cooked Rabbit Meat", dzs_rabit_c];
_itemList lbSetData [(lbSize _itemList)-1, "rabitmeatc"];
};
if(dzs_cow > 0) then {
_itemListIndex = _itemList lbAdd format["%1x - Raw Cow Meat", dzs_cow];
_itemList lbSetData [(lbSize _itemList)-1, "cowmeat"];
};
if(dzs_cow_c > 0) then {
_itemListIndex = _itemList lbAdd format["%1x - Cooked Cow Meat", dzs_cow_c];
_itemList lbSetData [(lbSize _itemList)-1, "cowmeatc"];
};
if(dzs_chicken > 0) then {
_itemListIndex = _itemList lbAdd format["%1x - Raw Chicken Meat", dzs_chicken];
_itemList lbSetData [(lbSize _itemList)-1, "chickenmeat"];
};
if(dzs_chicken_c > 0) then {
_itemListIndex = _itemList lbAdd format["%1x - Cooked Chicken Meat", dzs_chicken_c];
_itemList lbSetData [(lbSize _itemList)-1, "chickenmeatc"];
};
if(dzs_boar > 0) then {
_itemListIndex = _itemList lbAdd format["%1x - Raw Boar Meat", dzs_boar];
_itemList lbSetData [(lbSize _itemList)-1, "boarmeat"];
};
if(dzs_boar_c > 0) then {
_itemListIndex = _itemList lbAdd format["%1x - Cooked Boar Meat", dzs_boar_c];
_itemList lbSetData [(lbSize _itemList)-1, "boarmeatc"];
};
if(dzs_goat > 0) then {
_itemListIndex = _itemList lbAdd format["%1x - Raw Goat Meat", dzs_goat];
_itemList lbSetData [(lbSize _itemList)-1, "goatmeat"];
};
if(dzs_goat_c > 0) then {
_itemListIndex = _itemList lbAdd format["%1x - Cooked Goat Meat", dzs_goat_c];
_itemList lbSetData [(lbSize _itemList)-1, "goatmeatc"];
};