//	@file Version: 1.0
//	@file Name: mission_Hord.sqf
//	@file Author: ported from Craig's DZS by Cancerous
//	@file Created: 03/14/2013 15:19
//	@file Args:
#include "setup.sqf"
#include "sideMissionDefines.sqf";

if(!isServer) exitwith {};

private ["_result","_missionMarkerName","_missionType","_startTime","_returnData","_randomPos","_randomIndex","_picture","_hint","_currTime","_playerPresent","_unitsAlive","_checking","_people","_side","_towns","_towncount","_townnum","_town","_randomPos","_group","_trigger"];

//Mission Initialization.
_result = 0;

_missionMarkerName = "Town with horde" + str (random 1000);
_missionType = "Horde Attack";

_checking = 1;
while {_checking == 1} do {

_towns = townlist;
_towncount = count _towns;
_townnum = floor (random _towncount);
_town = _towns select _townnum;
_randomPos = getpos _town;

_people =  nearestObjects [[_randomPos select 0, _randomPos select 1,0],["Man","LandVehicle","Air"],300];
{_vehicle = _x;
if ({isPlayer _x} count crew _vehicle > 0) exitWith {_playerPresent = true}} forEach _people;
if (({isPlayer _x} count _people > 0) || (_playerPresent)) then {_checking = 0; _playerPresent = false;};
sleep 1;
};

#ifdef __A2NET__
_startTime = floor(netTime);
#else
_startTime = floor(time);
#endif

diag_log format["WASTELAND SERVER - Side Mission Started: %1",_missionType];

//Get Mission Location

//missionVars = ["Town with horde",_randomPos,_missionMarkerName];

_side = createCenter sideLogic;
_group = createGroup _side;
townlogic = _group createUnit ["Logic",_randomPos, [], 0, "NONE"];


diag_log format["WASTELAND SERVER - Side Mission Waiting to run: %1",_missionType];
[sideMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Side Mission Resumed: %1",_missionType];

//[_missionMarkerName,_randomPos,_missionType] call createClientMarker;
[_missionMarkerName,_randomPos,"Town with horde"] call createClientMarker;
// _marker = createMarker [_missionMarkerName,_randomPos];
// _marker setMarkerType "mil_destroy";
// _marker setMarkerColor "ColorRed";
// _marker setMarkerText "Town with horde";
// _marker setMarkerSize [1,1];



_hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Side Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>A nearby town has been attacked by a zombie horde!<br/>Find and eliminate it!</t>", _missionType, sideMissionColor, subTextColor];

messageSystem = _hint;
publicVariable "messageSystem";

//hillpos doesn't work for some reason
_trigger=createTrigger ["EmptyDetector",getpos townlogic];
_trigger setTriggerArea [10,10,0,false];
[_trigger,15,CLY_hordetrigger,"normal"] execVM "zombie_scripts\cly_z_horde.sqf";

diag_log format["WASTELAND SERVER - Side Mission Waiting to be Finished: %1",_missionType];

#ifdef __A2NET__
_startTime = floor(netTime);
#else
_startTime = floor(time);
#endif

_unitsAlive = 0;
_playerPresent = false;
//_zombiesstart = nearestObjects [[_randomPos select 0, _randomPos select 1,0],["Man"],100];
//{if(isNil {_x getVariable "zombietype"}) then {_zombiesstart = _zombiestart - _x}}forEach _zombiestart;
waitUntil
{
    sleep 1; 
	_people = nearestObjects [[_randomPos select 0, _randomPos select 1,0],["Man","LandVehicle","Air"],100];
	_vehicle = _x;
	#ifdef __A2NET__
	_currTime = floor(netTime);
	#else
	_currTime = floor(time);
	#endif
	if(_currTime - _startTime >= sideMissionTimeout) then {_result = 1;};
	{if({isPlayer _x} count crew _vehicle > 0) exitWith {_playerPresent = true};}forEach _people;
	_zombiesnow = nearestObjects [[_randomPos select 0, _randomPos select 1,0],["Man"],100];
	{if(isNil {_x getVariable "zombietype"}) then {_zombiesnow = _zombiesnow - [_x]};}forEach _zombiesnow;
	(_result == 1) OR ((_playerPresent) AND (_zombiesnow < 10))
};

if(_result == 1) then
{
	//Mission Failed.
    {deleteVehicle _x;}forEach units _group;
    deleteGroup _group;
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>Objective failed, better luck next time</t>", _missionType, failMissionColor, subTextColor];
	messageSystem = _hint;
    publicVariable "messageSystem";
    diag_log format["WASTELAND SERVER - Side Mission Failed: %1",_missionType];
} else {
	//Mission Complete.
    deleteGroup _group;
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>Horde Eliminated, nice work!</t>", _missionType, successMissionColor, subTextColor];
	messageSystem = _hint;
    publicVariable "messageSystem";
    diag_log format["WASTELAND SERVER - Side Mission Success: %1",_missionType];
};

//Reset Mission Spot.
//MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;