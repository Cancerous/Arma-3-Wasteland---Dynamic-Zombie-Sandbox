private ["_killer","_effect","_prev"];


_killer = _this select 1;
_effect = _this select 2; // can be hit or killed
if (_killer != player || isDedicated) exitWith {};



_prev = player getVariable "Points";

if (_effect == "hit") then {
	player setVariable ["Points",_prev + 10,true];
	player sideChat "+10";
};

if (_effect == "killed") then {
	player setVariable ["Points",_prev + 50,true];
	player sideChat "+50";
};