/*
@file Version: 1A
@file name: onJIP.sqf
@file Author: TAW_Tonic AKA Tonic, Edited by Craig Vander Galien
@file edit: 3/27/2012
@file description: Initiate JIP related stuff incase client has joined in progress
*/

private ["_markertxt","_markerpos","_markerName"];

if(missionActive) then {
	waitUntil {!isNil "missionVars"};
    _markertxt = missionVars select 0;
    _markerpos = missionVars select 1;
	_markerName = missionVars select 2;
	if (CVG_sideMarkers == 0) then {
		_marker = createMarker [_markerName,_markerpos];
		_marker setMarkerType "mil_destroy";
		_marker setMarkerColor "ColorRed";
		_marker setMarkerText _markertxt;
		_marker setMarkerSize [1,1];
	};
	
	if (CVG_sideMarkers == 1) then {
		_markerpos = [(_markerpos select 0) + random 100, (_markerpos select 1) + random 100,0];
		_marker = createMarker [_markerName,_markerpos];
		_marker setMarkerShape "ellipse";
		_marker setMarkerBrush "DiagGrid";
		_marker setMarkerColor "ColorRed";
		_marker setMarkerText _markertxt;
		_marker setMarkerSize [200,200];
	};

};

