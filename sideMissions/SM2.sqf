//Horde assignment script



private ["_marker","_checking","_people","_towns","_towncount","_townnum","_town","_townpos","_side","_group","_trigger"];
sleep 120 + (random floor 480);
[player,nil,rSIDECHAT,STR_MISSION_TEXT_2] call RE;
[nil,nil,rHINT,STR_MISSION_TEXT_2] call RE;


_towns = townlist;
_towncount = count _towns;
_townnum = floor (random _towncount);
_town = _towns select _townnum;
_townpos = getpos _town;
missionActive = true;publicVariable "missionActive";
_marker_name = STR_MISSION_MARKER_2 + str (random 1000);
missionVars = [STR_MISSION_MARKER_2,_townpos,_marker_name];
publicVariable "missionVars";


_side = createCenter sideLogic;
_group = createGroup _side;
townlogic = _group createUnit ["Logic",_townpos, [], 0, "NONE"];


_marker = createMarker [_marker_name,_townpos];
_marker setMarkerType "mil_destroy";
_marker setMarkerColor "ColorRed";
_marker setMarkerText STR_MISSION_MARKER_2;
_marker setMarkerSize [1,1];



_checking = 1;
while {_checking == 1} do {
_people =  nearestObjects [[getpos _town select 0, getpos _town select 1,0],["Man","LandVehicle","Air"],300];
{_vehicle = _x;
if ({isPlayer _x} count crew _vehicle > 0) exitWith {vehicleCheck = true}} forEach _people;
if (({isPlayer _x} count _people > 0) || (vehicleCheck)) then {_checking = 0; vehicleCheck = false;};
sleep 1;
};

//hillpos doesn't work for some reason
_trigger=createTrigger ["EmptyDetector",getpos townlogic];
_trigger setTriggerArea [10,10,0,false];
[_trigger,15,CLY_hordetrigger,"normal"] execVM "zombie_scripts\cly_z_horde.sqf";
sleep 10;

_checking = 1;
while {_checking == 1} do {
_people =  nearestObjects [[getpos _town select 0, getpos _town select 1,0],["Man","LandVehicle","Air"],100];
{_vehicle = _x;
if ({isPlayer _x} count crew _vehicle > 0) exitWith {vehicleCheck = true}} forEach _people;
if (({isPlayer _x} count _people > 0) || (vehicleCheck)) then {_checking = 0; vehicleCheck = false;};
sleep 1;
};



[player,nil,rSIDECHAT,"Horde Eliminated, nice work!"] call RE;
[nil,nil,rHINT,"Horde Eliminated, nice work!"] call RE;
_marker setMarkerColor "ColorBlue";

missionActive = false;
publicVariable "missionActive";
deleteMarker _marker_name;

SM1 = 2;
[0] execVM "sideMissions\SMfinder.sqf";