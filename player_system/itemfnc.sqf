#include "dialog\player_sys.sqf";
#define GET_DISPLAY (findDisplay playersys_DIALOG)
#define GET_CTRL(a) (GET_DISPLAY displayCtrl ##a)
#define GET_SELECTED_DATA(a) ([##a] call {_idc = _this select 0;_selection = (lbSelection GET_CTRL(_idc) select 0);if (isNil {_selection}) then {_selection = 0};(GET_CTRL(_idc) lbData _selection)})
if(isNil {dropActive}) then {dropActive = false};
disableSerialization;

private["_switch","_data","_vehicle_type","_pos","_bomb","_beacon","_temp"];
_switch = _this select 0;
_data = GET_SELECTED_DATA(item_list);
switch(_switch) do 
	{
		case 0:
		{
			closeDialog 0;
			switch(_data) do 
				{
					case "canfood": 
					{
						if((vehicle player) == player) then { player playmove "AinvPknlMstpSnonWnonDnon_healed_1"; };
							dzs_canfood = dzs_canfood - 1;
							hungerlvl = hungerlvl + 20;
							hint format["You have eaten some canned food\nHunger Level: %1",hungerlvl];
							sleep  1;
							player playmove "AinvPknlMstpSnonWnonDnon_healed_1";
					};
					
					case "rabitmeatc": 
					{
						if((vehicle player) == player) then { player playmove "AinvPknlMstpSnonWnonDnon_healed_1"; };
							dzs_rabit_c = dzs_rabit_c - 1;
							hungerlvl = hungerlvl + 10;
							hint format["You have eaten some rabit meat\nHunger Level: %1",hungerlvl];
							sleep  1;
							player playmove "AinvPknlMstpSnonWnonDnon_healed_1";
					};
					
					case "cowmeatc": 
					{
						if((vehicle player) == player) then { player playmove "AinvPknlMstpSnonWnonDnon_healed_1"; };
							dzs_cow_c = dzs_cow_c - 1;
							hungerlvl = hungerlvl + 100;
							hint format["You have eaten some cow meat\nHunger Level: %1",hungerlvl];
							sleep  1;
							player playmove "AinvPknlMstpSnonWnonDnon_healed_1";
					};
					
					case "goatmeatc": 
					{
						if((vehicle player) == player) then { player playmove "AinvPknlMstpSnonWnonDnon_healed_1"; };
							dzs_goat_c = dzs_goat_c - 1;
							hungerlvl = hungerlvl + 50;
							hint format["You have eaten some goat meat\nHunger Level: %1",hungerlvl];
							sleep  1;
							player playmove "AinvPknlMstpSnonWnonDnon_healed_1";
					};
					
					case "boarmeatc": 
					{
						if((vehicle player) == player) then { player playmove "AinvPknlMstpSnonWnonDnon_healed_1"; };
							dzs_boar_c = dzs_boar_c - 1;
							hungerlvl = hungerlvl + 40;
							hint format["You have eaten some boar meat\nHunger Level: %1",hungerlvl];
							sleep  1;
							player playmove "AinvPknlMstpSnonWnonDnon_healed_1";
					};
					
					case "chickenmeatc": 
					{
						if((vehicle player) == player) then { player playmove "AinvPknlMstpSnonWnonDnon_healed_1"; };
							dzs_chicken_c = dzs_chicken_c - 1;
							hungerlvl = hungerlvl + 15;
							hint format["You have eaten some chicken meat\nHunger Level: %1",hungerlvl];
							sleep  1;
							player playmove "AinvPknlMstpSnonWnonDnon_healed_1";
					};
					
					case "water": 
					{
						if((vehicle player) == player) then { player playmove "AinvPknlMstpSnonWnonDnon_healed_1"; };
							dzs_water = dzs_water - 1;
							thirstlvl = 100;
							hint format["You've drank some water.\n\n Hydration Level: %1",thirstlvl];
							sleep  1;
							player playmove "AinvPknlMstpSnonWnonDnon_healed_1";
					};
				
				};
		};
		
		case 1:
		{
		
		if(_data == "") exitWith {hint "You didn't select anything to drop";};
		if(dropActive) exitwith {hint "You're already dropping something";};
		if(vehicle player != player) exitwith {hint "You can't use this action while in a vehicle."};
		player playmove "AinvPknlMstpSlayWrflDnon";
		dropActive = true;
		sleep 1.5;
		_pos = getPosATL player;
		//Drops the item and sets values & variables
			switch(_data) do 
				{
					case "canfood": {dzs_canfood = dzs_canfood - 1; _temp = "Land_Bag_EP1" createVehicle (position player); _temp setPos [(_pos select 0)+1, _pos select 1, _pos select 2]; _temp setVariable["food",10,true];};
					case "rabitmeat": {dzs_rabit = dzs_rabit - 1; _temp = "Land_Sack_EP1" createVehicle (position player); _temp setPos _pos; _temp setVariable["raw", true, true]; _temp setVariable["item", "rabit",true]};
					case "fuelFull": {dzs_fuelF = false; _temp = "Fuel_can" createVehicle (position player); _temp setVariable["fuel", true, true]; _temp setPos _pos;};
					case "fuelEmpty": {dzs_fuelE = false; _temp = "Fuel_can" createVehicle (position player); _temp setVariable["fuel", false, true]; _temp setPos _pos;};
					case "repairkits": {dzs_repairkits = dzs_repairkits - 1; _temp = "Suitcase" createVehicle (position player); _temp setPos _pos;};
					case "water": {dzs_water = dzs_water - 1; _temp = "Land_Teapot_EP1" createVehicle (position player); _temp setPos _pos;};
					case "medkit": {dzs_medkits = dzs_medkits - 1; _temp = "CZ_VestPouch_EP1" createVehicle (position player); _temp setPos _pos;};
					case "goatmeat": {dzs_goat  = dzs_goat - 1; _temp = "Land_Sack_EP1" createVehicle (position player); _temp setPos _pos; _temp setVariable["raw", true, true]; _temp setVariable["item", "goat",true]};
					case "cowmeat": {dzs_cow = dzs_cow - 1; _temp = "Land_Sack_EP1" createVehicle (position player); _temp setPos _pos; _temp setVariable["raw", true, true]; _temp setVariable["item", "cow",true]};
					case "boarmeat": {dzs_boar = dzs_boar - 1; _temp = "Land_Sack_EP1" createVehicle (position player); _temp setPos _pos; _temp setVariable["raw", true, true]; _temp setVariable["item", "boar",true]};
					case "chickenmeat": {dzs_chicken = dzs_chicken - 1; _temp = "Land_Sack_EP1" createVehicle (position player); _temp setPos _pos; _temp setVariable["raw", true, true]; _temp setVariable["item", "chicken",true]};
					case "chickenmeatc": {dzs_chicken_c = dzs_chicken_c - 1; _temp = "Land_Sack_EP1" createVehicle (position player); _temp setPos _pos; _temp setVariable["item", "chicken",true]; _temp setVariable["raw",false,true];};
					case "rabitmeatc": {dzs_rabit_c = dzs_rabit_c - 1; _temp = "Land_Sack_EP1" createVehicle (position player); _temp setPos _pos; _temp setVariable["item", "rabit",true]; _temp setVariable["raw",false,true];};
					case "boarmeatc": {dzs_boar_c = dzs_boar_c - 1; _temp = "Land_Sack_EP1" createVehicle (position player); _temp setPos _pos; _temp setVariable["item", "boar",true]; _temp setVariable["raw",false,true];};
					case "goatmeatc": {dzs_goat_c = dzs_goat_c - 1; _temp = "Land_Sack_EP1" createVehicle (position player); _temp setPos _pos; _temp setVariable["item", "goat",true]; _temp setVariable["raw",false,true];};
					case "cowmeatc": {dzs_cow_c = dzs_cow_c - 1; _temp = "Land_Sack_EP1" createVehicle (position player); _temp setPos _pos; _temp setVariable["item", "cow",true]; _temp setVariable["raw",false,true];};
				};
				dropActive = false;
				closeDialog 0;
		};
};