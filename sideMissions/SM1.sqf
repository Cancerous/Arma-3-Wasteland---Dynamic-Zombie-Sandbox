//Large Ammo Cache script


private ["_rad","_cnps","_hills","_hillcount","_hillnum","_hill","_marker","_checking","_people","_hillpos"];
sleep 120 + (random floor 240);
[player,nil,rSIDECHAT,STR_MISSION_TEXT_1] call RE;
[nil,nil,rHINT,STR_MISSION_TEXT_1] call RE;
private ["_rad","_cnps","_hills","_hillcount","_hillnum","_hill","_marker"];

_rad=20000;
_cnps = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
_hills = nearestLocations [_cnps, ["Hill"], _rad];
if (count _hills < 3) then {
_hills = nearestLocations [_cnps,["NameLocal"],_rad];
};
if (count _hills < 2) then {
_hills = towns; 
};
_hillcount = count _hills;
_hillnum = floor (random _hillcount);
_hill = _hills select _hillnum;
_hillpos = getpos _hill;


if (CVG_sideMarkers == 0) then {
	_marker_name = STR_MISSION_MARKER_1 + str (random 1000);
	_marker = createMarker [_marker_name,_hillpos];
	_marker setMarkerType "mil_destroy";
	_marker setMarkerColor "ColorRed";
	_marker setMarkerText STR_MISSION_MARKER_1;
	_marker setMarkerSize [1,1];
};

if (CVG_sideMarkers == 1) then {
	_hillpos = [(_hillpos select 0) + random 100, (_hillpos select 1) + random 100,0];
	_marker_name = STR_MISSION_MARKER_1 + str (random 50);
	_marker = createMarker [_marker_name,_hillpos];
	_marker setMarkerShape "ellipse";
	_marker setMarkerBrush "DiagGrid";
	_marker setMarkerColor "ColorRed";
	_marker setMarkerText STR_MISSION_MARKER_1;
	_marker setMarkerSize [200,200];
};

missionActive = true;
missionVars = [STR_MISSION_MARKER_1,_hillpos,_marker_name];
publicVariable "missionActive";
publicVariable "missionVars";

BOX = createVehicle ["USVehicleBox",[(getpos _hill select 0) + 10, getpos _hill select 1,0],[], 0, "NONE"];

[BOX] execVM "craigs_scripts\fillBoxes.sqf";

_checking = 1;
while {_checking == 1} do {
_people =  nearestObjects [[getpos _hill select 0, getpos _hill select 1,0],["Man","LandVehicle","Air"],20];
{_vehicle = _x;
if ({isPlayer _x} count crew _vehicle > 0) exitWith {vehicleCheck = true}} forEach _people;
if (({isPlayer _x} count _people > 0) || (vehicleCheck)) then {_checking = 0; vehicleCheck = false;};
sleep 1;
};

[player,nil,rSIDECHAT,"The Gear Cache has been found, nice work, enjoy the spoils."] call RE;
[nil,nil,rHINT,"The Gear Cache has been found, nice work, enjoy the spoils."] call RE;
_marker setMarkerColor "ColorBlue";


missionActive = false;
publicVariable "missionActive";
deleteMarker _marker_name;
SM1 = 1;
[0] execVM "sideMissions\SMfinder.sqf";
