//Victim-based zombie aggro script

_unit = _this;
_maxaggro = CVG_maxaggroradius max CLY_altmaxaggroradius;


_unit setVariable ["zombievictim", true, true];

while {local _unit && alive _unit} do
{

	if (_unit getVariable ["zombievictim", false] && getPos vehicle _unit select 2 < 10 && _unit getVariable ["zombievictim", true]) then
	{

		//Find out aggro multiplier
		_vehicle = vehicle _unit;
		_isvehicle = _vehicle != _unit && isEngineOn _vehicle && getNumber (configFile / "CfgVehicles" / (typeOf _vehicle) / "isbicycle") == 0;
		_unarmed = currentWeapon _vehicle == "" && !_isvehicle;
		_multiplier = 1;
		if (_isvehicle) then
		{
			_multiplier = CLY_vehicleaggromultiplier;
		};
		if (_unarmed) then
		{
			_multiplier = CLY_unarmedaggromultiplier;
		};
		
		//Check for zombies that can attack
		_units = getPosATL _vehicle nearEntities ["Man", _maxaggro * _multiplier];
		{

				_zombie = _x;
				_victim = _zombie getVariable ["victim", objNull];
				if (_victim != _vehicle) then
				{
					if (_victim != _unit) then
					{
						if ((_zombie knowsAbout _vehicle >= CLY_minaggroknowsabout || !(_zombie getVariable "zombietype" in ["normal", "surprise", "creeper", "walker", "armored", "slow armored"]) || _zombie getVariable "horde")) then
						{
							_dist = _vehicle distance _zombie;
							if (_dist < (_zombie getVariable "aggroradius") * _multiplier) then
							{
								if (isNull _victim) then
								{
									_zombie setVariable ["victim", _unit, true];
								}
								else
								{
									if (_dist < (_zombie distance vehicle _victim) * 0.5) then
									{
										_zombie setVariable ["victim", _unit, true];
									};
								};
							};
						};
					};
				};
			
		} forEach _units;
	};
	sleep 0.01;
};