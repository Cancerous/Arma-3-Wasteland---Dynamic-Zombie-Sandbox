
private ["_h","_unit"];
_unit = _this select 0;

if (!isNil {_unit getVariable "zombietype"}) then {
	if ((count magazines _unit) > 0) then {
		_h=getPosATL _unit nearObjects ["logic",0.1];
		if (count _h>0) then {deleteVehicle (_h select 0)};

		sleep 120;
		hideBody _unit;
		sleep 10;
		deleteVehicle _unit;
	};
};

if ((isNil {_unit getVariable "zombietype"}) && (_unit isKindOf "Man")) then {
	if (((count magazines _unit) > 0) || ((count weapons _unit) > 0)) then {
		_h=getPosATL _unit nearObjects ["logic",0.1];
		if (count _h>0) then {deleteVehicle (_h select 0)};
		sleep 300;
		hideBody _unit;
		sleep 10;
		deleteVehicle _unit;
	};
};

if ((isNil {_unit getVariable "zombietype"}) && (!(_unit isKindOf "Man"))) then {

	_h=getPosATL _unit nearObjects ["logic",0.1];
	if (count _h>0) then {deleteVehicle (_h select 0)};

	sleep 500;
	deleteVehicle _unit;
};

