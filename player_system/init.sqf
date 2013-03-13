#include "dialog\player_sys.sqf"; 
if(dialog) exitwith{};
_playerDialog = createDialog "playerSettings";
disableSerialization;

private["_Dialog","_foodtext","_watertext","_moneytext","_mvalue","_rogue"];

_Dialog = findDisplay playersys_DIALOG;
_foodtext = _Dialog displayCtrl food_text;
_watertext = _Dialog displayCtrl water_text;
_rogue = _Dialog displayCtrl rogue_text;
_foodtext ctrlSettext format["%1 / 100", round(hungerlvl)];
_watertext ctrlSetText format["%1 / 100", round(thirstlvl)];
