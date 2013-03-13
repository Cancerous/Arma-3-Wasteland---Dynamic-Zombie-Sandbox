//A quick script that puts the player into the vehicle he presses E nearby

private ["_vcls","_vcl","_key"];
_key     = _this select 1;
switch _key do
{
    case 18:
    {
        _vcls = nearestobjects [getpos player, ["LandVehicle", "Air", "ship"], 7];
        _vcl = _vcls select 0;
        if(_vcl emptyPositions "Driver" > 0)exitwith   {player action ["getInDriver", _vcl]};
        if(_vcl emptyPositions "Gunner" > 0)exitwith   {player action ["getInGunner", _vcl]};
        if(_vcl emptyPositions "Commander" > 0)exitwith{player action ["getInCommander", _vcl]};
        if(_vcl emptyPositions "Cargo" > 0)exitwith    {player action ["getInDriver", _vcl];};
    };
};