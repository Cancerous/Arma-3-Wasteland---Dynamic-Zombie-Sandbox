//Remove gas stations script 
//by Craig/bobtom
//free to use/abuse


private ["_Pos","_stations"];
_Pos = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
_stations = nearestObjects [_pos, ["Land_A_FuelStation_Build","Land_A_FuelStation_Shed","MAP_A_FuelStation_Build","MAP_A_FuelStation_Shed","Land_Ind_FuelStation_Build_EP1","Land_Ind_FuelStation_Shed_EP1","Land_FuelStation_Build_PMC","Land_FuelStation_Shed_PMC","FuelStation","Land_A_FuelStation_Feed","Land_Ind_FuelStation_Feed_EP1","Land_FuelStation_Feed_PMC"], 50000];
{_x setdamage 1} forEach _stations;