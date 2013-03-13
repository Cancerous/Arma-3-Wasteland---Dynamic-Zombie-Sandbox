//Aircraft crash sidemission


private ["_rad","_cnps","_locations","_locationcount","_locationnum","_location","_marker","_checking","_people","_locationpos","_group"];
sleep 120 + (random floor 480);
[player,nil,rSIDECHAT,STR_MISSION_TEXT_3] call RE;
[nil,nil,rHINT,STR_MISSION_TEXT_3] call RE;

_rad=20000;
_cnps = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
_locations = nearestLocations [_cnps, ["NameLocal"], _rad];
if (count _locations == 0) then {_locations = towns};
_locationcount = count _locations;
_locationnum = floor (random _locationcount);
_location = _locations select _locationnum;
_locationpos = getpos _location;

if (CVG_sideMarkers == 0) then {
	_marker_name = STR_MISSION_MARKER_3 + str (random 50);
	_marker = createMarker [STR_MISSION_MARKER_3,_locationPos];
	_marker setMarkerType "mil_destroy";
	_marker setMarkerColor "ColorRed";
	_marker setMarkerText STR_MISSION_MARKER_3;
	_marker setMarkerSize [1,1];
};

if (CVG_sideMarkers == 1) then {
	_locationPos = [(_locationPos select 0) + random 100, (_locationPos select 1) + random 100,0];
	_marker_name = STR_MISSION_MARKER_3 + str (random 50);
	_marker = createMarker [_marker_name,_locationPos];
	_marker setMarkerShape "ellipse";
	_marker setMarkerBrush "DiagGrid";
	_marker setMarkerColor "ColorRed";
	_marker setMarkerText STR_MISSION_MARKER_3;
	_marker setMarkerSize [200,200];
};

missionActive = true;
missionVars = [STR_MISSION_MARKER_3,_locationPos,_marker_name];
publicVariable "missionActive";
publicVariable "missionVars";


c130wreck = createVehicle ["C130J_wreck_EP1",[(getpos _location select 0) + 30, getpos _location select 1,0],[], 0, "NONE"];
box = createVehicle ["USOrdnanceBox",[(getpos _location select 0) - 10, getpos _location select 1,0],[], 0, "NONE"];
box2 = createVehicle ["USBasicWeaponsBox",[(getpos _location select 0) - 10, (getpos _location select 1) - 10,0],[], 0, "NONE"];

_group = createGroup resistance;
man = _group createunit ["Ins_Soldier_1", _locationpos, [], 0, "Form"];
[] spawn {

private ["_people"];
while {alive man} do {
_people =  nearestObjects [(getpos man),["Man"],400];
{if ((isPlayer _x) and (alive _x) and ((side _x == east) or (side _x == west) or (side _x == civilian))) then {_x setcaptive false; man doTarget _x; man doFire _x};} forEach _people;
sleep 1;
};
};
man allowdamage false;
man2 = _group createunit ["Ins_Soldier_1", _locationpos, [], 0, "Form"];
[] spawn {

private ["_people"];
while {alive man2} do {
_people =  nearestObjects [(getpos man2),["Man"],400];
{if ((isPlayer _x) and (alive _x) and ((side _x == east) or (side _x == west) or (side _x == civilian))) then {_x setcaptive false; man2 doTarget _x; man2 doFire _x};} forEach _people;
sleep 1;
};
};
man2 allowdamage false;
man3 = _group createunit ["Ins_Soldier_1", _locationpos, [], 0, "Form"];
[] spawn {

private ["_people"];
while {alive man3} do {
_people =  nearestObjects [(getpos man3),["Man"],400];
{if ((isPlayer _x) and (alive _x) and ((side _x == east) or (side _x == west) or (side _x == civilian))) then {_x setcaptive false; man3 doTarget _x; man3 doFire _x};} forEach _people;
sleep 1;
};
};
man3 allowdamage false;
spawnpos = [_locationpos select 0,(_locationpos select 1)+ 400,_locationpos select 2];
sleep 10;

{_x allowdamage true} forEach [man,man2,man3];

_checking = 1;
while {_checking == 1} do {
_people =  nearestObjects [[getpos _location select 0, getpos _location select 1,0],["Man","LandVehicle","Air"],300];
{_vehicle = _x;
if ({isPlayer _x} count crew _vehicle > 0) exitWith {vehicleCheck = true}} forEach _people;
if (({isPlayer _x} count _people > 0) || (vehicleCheck)) then {_checking = 0; vehicleCheck = false;};
sleep 1;
};

[nil,nil,rSpawn,"player setcaptive true"] call RE;
[player,nil,rSIDECHAT,"Oh SHIT bad guys. Well. Deal with them, or get delt yourself."] call RE;
[nil,nil,rHINT,"Oh SHIT bad guys. Well. Deal with them, or get delt yourself."] call RE;
_marker setMarkerColor "ColorBlue";

missionActive = false;
publicVariable "missionActive";
deleteMarker _marker_name;

SM1 = 1;
[0] execVM "sideMissions\SMfinder.sqf";



