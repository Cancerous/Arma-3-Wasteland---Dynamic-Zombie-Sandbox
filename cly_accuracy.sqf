/*
	Accuracy boost script written by Celery
	
	This script boosts the accuracy of weapons.
	Normally used to make pistols not so useless.
	
	Called in a unit's "Fired" event handler.
	Needs the CLY_accuracyarray variable that contains weapon classnames that get the boost.
	Also needs the weapon direction updater that saves weapon direction before recoil kicks in. Execute once in init script:
	[] spawn {_lasttime = 0;while {true} do {sleep 0.01;CLY_weapondir = [player weaponDirection currentWeapon player, time, _lasttime];_lasttime = time}}
*/

if (CLY_accuracy) then {
	_unit = _this select 0;
	_weapon = _this select 1;
	_mag = _this select 5;
	_bullet = _this select 6;
	_weapontype = getNumber (configFile / "CfgWeapons" / _weapon / "type");
	_dispersion = getNumber (configFile / "CfgWeapons" / _weapon / "dispersion");
	_magcount = getNumber (configFile / "CfgMagazines" / _mag / "count");
	_magtype = getNumber (configFile / "CfgMagazines" / _mag / "type");
	_bulletexplosive = getNumber (configFile / "CfgAmmo" / (typeOf _bullet) / "explosive");

	_inarray = (_weapontype == 2 && _dispersion > CLY_mindispersion) || _weapon in CLY_accuracyarray;
	_grenade = _magtype == 16 && _magcount == 1;

	if (local _unit && _inarray && !_grenade && _bulletexplosive != 1) then
	{
		_elevation = 0.002;
		_speed = (speed _bullet / 3.6);
		_weapondir = CLY_weapondir select 0;
		if ((CLY_weapondir select 1) - (CLY_weapondir select 2) > 0.085 || (CLY_weapondir select 1) + 0.085 < time) then
		{
			_weapondir = player weaponDirection _weapon;
		};
		_bullet setVelocity [(_weapondir select 0) * _speed, (_weapondir select 1) * _speed, (((_weapondir select 2) + _elevation) * _speed)];
	};
};