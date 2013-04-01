
private ["_buildings","_h","_pos","_unit","_x"];
_unit = _this select 0;

if (!isNil {_unit getVariable "zombietype"}) then {
	if ((count magazines _unit) > 0) then {
		_h=getPosATL _unit nearObjects ["logic",0.1];
		if (count _h>0) then {deleteVehicle (_h select 0)};
		_pos = getPos _unit;
		_buildings = nearestObjects [_pos, ["house"], 1000];
		{
			usedBuildings = usedBuildings - [_x];
		} forEach _buildings;
		sleep 30;
		hideBody _unit;
		sleep 1;
		deleteVehicle _unit;
	};
};

if ((isNil {_unit getVariable "zombietype"}) && (!(_unit isKindOf "Man"))) then {

	_h=getPosATL _unit nearObjects ["logic",0.1];
	if (count _h>0) then {deleteVehicle (_h select 0)};
	sleep 30;
	deleteVehicle _unit;
};