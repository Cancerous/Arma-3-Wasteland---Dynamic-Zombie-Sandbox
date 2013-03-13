
private ["_marker","_boxes","_town","_newpos","_numb","_boxnum","_box","_townpos","_towns"];

if (isServer) then {
        _towns = townlist;
        _boxes = (count _towns) * 2;
		_num = _boxes;

        
        while {_boxes > 0} do {
            _boxess = ["Box_NATO_WpsSpecial_F","Box_NATO_Wps_F","Box_NATO_Support_F","Box_NATO_Grenades_F","Box_NATO_AmmoOrd_F","Box_NATO_Ammo_F","Box_East_WpsSpecial_F","Box_East_Wps_F","Box_East_Support_F","Box_East_Grenades_F","Box_East_AmmoOrd_F","Box_East_Ammo_F"];
            _town = _towns call BIS_fnc_selectRandom;
            _newpos = getpos _town;
            _townpos = [_newpos, 10, 100, 1, 0, 60 * (pi / 180), 0] call BIS_fnc_findSafePos;
            _numb = (count _boxess);
            _boxnum = floor (random _numb);
            _box = _boxess select _boxnum;
            _box = createVehicle [_box,_townpos,[], 0, "NONE"]; 
			diag_log format ["Box spawned at: %1", _town];
			clearWeaponCargoGlobal _box;
			clearMagazineCargoGlobal _box;
			clearItemCargoGlobal _box;
			clearBackpackCargoGlobal _box;
            _boxes = _boxes - 1;
			[_box] execVM "craigs_scripts\fillboxes.sqf"

        };
};
		