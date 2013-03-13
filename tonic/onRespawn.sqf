/*
	@file Version: 1D
	@file name: onRespawn.sqf
	@file Author: TAW_Tonic
	@file edit: 9/8/2012
	@file description: On player death reset vars
*/
private["_player","_corpse","_town","_spawn","_temp"];

_player = (_this select 0) select 0;
_corpse = (_this select 0) select 1;

[] call waste_pActions;
thirstlvl = 100; hungerlvl = 100;

//Set food variables
dzs_canfood = 0; //Canned Food supply
dzs_rabit = 0; //Raw rabit meat
dzs_goat = 0; //Raw goat meat
dzs_cow = 0; //Raw cow meat
dzs_boar = 0; //Raw boar meat
dzs_chicken = 0; //Raw chicken meat
dzs_rabit_c = 0; //Cooked Rabit Meat
dzs_goat_c = 0; //Cooked Goat Meat
dzs_boar_c = 0; //Cooked Boar Meat
dzs_cow_c = 0; //Cooked Cow Meat
dzs_chicken_c = 0; //Cooked Chicken Meat
dzs_water = 0;