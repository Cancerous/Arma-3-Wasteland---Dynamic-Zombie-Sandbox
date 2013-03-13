	private["_unit","_unitPos","_var","_i","_tmp"];
	
	_unit = _this select 0; //Unit
	_unitPos = getPos _unit; //Unit Position
	_var = _this select 1; //Variable to check
	_bool = _this select 2; //Raw meat or no?
	_item = _this select 3; //What item is it
	
	if(_var < 1) exitWith {};
	for "_i" from 1 to _var do
	{	
		_tmp = "Land_Sack_EP1" createVehicle _unitPos;
		_tmp setVariable["item",_item,true];
		if(_bool) then
		{
			_tmp setVariable["raw",true,true];
		}
			else
		{
			_tmp setVariable["raw",false,true];
		};
	};