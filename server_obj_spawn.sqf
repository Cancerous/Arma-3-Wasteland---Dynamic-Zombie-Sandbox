private["_object","_pos","_dir","_objType","_newObject"];

_object = (_this select 0) select 0;
_pos = (_this select 0) select 1;
_dir = (_this select 0) select 2;


_objType = typeOf _object;
deleteVehicle _object;

_newObject = _objType createVehicle _pos;

if((_pos select 2) > 0.10) then
{
	_newObject setPosATL _pos;
}
else
{
	_newObject setPosATL [_pos select 0, _pos select 1, 0];
};

_newObject setDir _dir;

_newObject setVariable ["R3F_LOG_est_deplace_par", objNull, true];


