//base script
sleep 120 + (random floor 480);

private ["_rad","_cnps","_hills","_hillcount","_hillnum","_hill","_marker","_checking","_people","_hillPos","_hilpos","_locationPos","_try","_findingBase"];

[player,nil,rSIDECHAT,STR_MISSION_TEXT_4] call RE;
[nil,nil,rHINT,STR_MISSION_TEXT_4] call RE;
private ["_rad","_cnps","_hills","_hillcount","_hillnum","_hill","_marker"];

_rad=20000;
_cnps = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
_hills = nearestLocations [_cnps, ["Hill"], _rad];
_hillcount = count _hills;
_hillnum = floor (random _hillcount);
_hill = _hills select _hillnum;
_hilpos = getpos _hill;
_locationPos = getpos _hill;

_findingBase = 1;
_try = 0;
while {_findingBase == 1} do {
if (({(typeOf _X == "Land_Barrack2_EP1") or (typeOf _X == "Land_Barrack2")}count (nearestObjects [_locationPos, ["House"], 100]) != 0) and (_try < 10)) then {
_rad=20000;
_cnps = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
_hills = nearestLocations [_cnps, ["Hill"], _rad];
_hillcount = count _hills;
_hillnum = floor (random _hillcount);
_hill = _hills select _hillnum;
_hilpos = getpos _hill;
_locationPos = getpos _hill;
_try = _try + 1;
} else {
if (_try > 9) then {
[0] execVM "sideMissions\SMfinder.sqf";
};
_findingBase = 0;
};
sleep .1;
};



if (CVG_sideMarkers == 0) then {
	_marker_name = STR_MISSION_MARKER_4  + str (random 1000);
	_marker = createMarker [_marker_name,_locationPos];
	_marker setMarkerType "mil_destroy";
	_marker setMarkerColor "ColorRed";
	_marker setMarkerText STR_MISSION_MARKER_4;
	_marker setMarkerSize [1,1];
};

if (CVG_sideMarkers == 1) then {
	_markerPos = [(_locationPos select 0) + random 100, (_locationPos select 1) + random 100,0];
	_marker_name = STR_MISSION_MARKER_4  + str (random 50);
	_marker = createMarker [_marker_name,_markerPos];
	_marker setMarkerShape "ellipse";
	_marker setMarkerBrush "DiagGrid";
	_marker setMarkerColor "ColorRed";
	_marker setMarkerText STR_MISSION_MARKER_4;
	_marker setMarkerSize [200,200];
};

missionActive = true;
missionVars = [STR_MISSION_MARKER_4,_locationPos];
publicVariable "missionActive";
publicVariable "missionVars";


baserunover = [_locationPos, random 360, "smallbase"] call (compile (preprocessFileLineNumbers "ca\modules\dyno\data\scripts\objectMapper.sqf"));

_checking = 1;
while {_checking == 1} do {
_people =  nearestObjects [[getpos _hill select 0, getpos _hill select 1,0],["Man","Land"],300];
{
_vehicle = _x;
if ({isPlayer _x} count crew _vehicle > 0) exitWith {vehicleCheck = true};
} forEach _people;

if (({isPlayer _x} count _people > 0) || (vehicleCheck)) then {_checking = 0; vehicleCheck = false;};
sleep 1;
};

//hillpos doesn't work for some reason
trigger=createTrigger ["EmptyDetector",_locationPos];
trigger setTriggerArea [10,10,0,false];
[trigger,15,CLY_hordetrigger,"normal"] execVM "zombie_scripts\cly_z_horde.sqf";
sleep 15;

_checking = 1;
while {_checking == 1} do {
_people =  nearestObjects [[getpos _hill select 0, getpos _hill select 1,0],["Man"],100];
if ({(!isPlayer _x) and (alive _x)} count _people < 2) then {_checking = 0};
sleep 1;
};

[player,nil,rSIDECHAT,"The base is yours. Excellent work, now keep it to yourself or let anyone use it"] call RE;
[nil,nil,rHINT,"The base is yours, Excellent work, now keep it to yourself or let anyone use it"] call RE;
_marker setMarkerColor "ColorBlue";

missionActive = false;
publicVariable "missionActive";

SM1 = 1;
[0] execVM "sideMissions\SMfinder.sqf";


