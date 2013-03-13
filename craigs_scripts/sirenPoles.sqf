
private ["_towersn","_pos","_towers"];
if (!isServer) exitWith {};



_pos = [0,0];
_towers = nearestObjects [_pos, ["Land_Ind_IlluminantTower","Land_Ind_Stack_Big"], 60000];

if (CVG_Debug == 2) then {
    _towersn = str _towers;
    player sideChat _towersn;
};

/*
This will start the playing of the sound for each siren. You can destroy the the tower to end the sound.
Sirens can be found here: http://www.armaholic.com/page.php?id=12598
Sirens by: DarkXess
*/

{
    [_x] spawn {
        
        private ["_marker","_tower","_Siren"];
        _tower = _this select 0;
        _siren = "sirens";
        if (CVG_Debug == 2) then {
            _marker=createMarker [format ["mar%1",random 100000],getpos _tower];
            _marker setMarkerType "Dot";
            _marker setMarkerColor "ColorBlue";
            _marker setMarkerText "Air Raid Siren";
            _marker setMarkerSize [2,2];
        };
        while {alive _tower} do{
            _tower say3D _siren;
            sleep 120000;
        };
    };
} forEach _towers;

