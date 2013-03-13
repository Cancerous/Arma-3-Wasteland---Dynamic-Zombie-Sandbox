/*
	@file Version: 1D
	@file name: init.sqf
	@file Author: TAW_Tonic
	@file edit: 9/8/2002
	@file description: Initialize Food & Hunger System for DZS
*/
waitUntil {!isNull player};
//Init vars

[] execVM "tonic\compile.sqf";
[] execVM "tonic\playerActions.sqf";
[] execVM "tonic\client_vars.sqf";
[] execVM "tonic\eventhandles.sqf";
[] execVM "tonic\init_survival.sqf";
waitUntil {!(isNull (findDisplay 46))};
(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call keysDown"];
sleep 3;
player sidechat "Open the food menu with the ~ (tilde) key";
