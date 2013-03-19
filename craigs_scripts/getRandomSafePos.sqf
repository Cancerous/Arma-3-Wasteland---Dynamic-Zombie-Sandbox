//------------------------------------------------------------------------------- Spam_One -----------------
//
// Script for finding random pos easily for object, while checking if it's safe (water) // -----------------
//
// Call it with [objectName,"random on select 0","random on select 1","minimum distance"]  -----------------
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
comment "Return random position";
private ["_object", "_Rpos0", "_Rpos1", "_minPos", "_x", "_y", "_pos"];

_object = _this select 0;  	// the object from which you will search the pos

_Rpos0 = _this select 1;		// random position on getPos select 0

_Rpos1 = _this select 2;		// random position on getPos select 1

_minPos = _this select 3;	// the minimum distance which pos can be


_x = 0;
_y = 0;
_pos = [_x, _y];

while {(_x == 0) or (_y == 0) or (surfaceIsWater _pos)} do {
    // _xOp = if (random 1 > 0.5) then {1} else {-1};
    // _yOp = if (random 1 > 0.5) then {1} else {-1};
    // _x = (getPos _object select 0) + (((random _Rpos0) + _minPos) * _xOp);
    // _y = (getPos _object select 1) + (((random _Rpos1) + _minPos) * _yOp);
	//    _pos = [_x, _y]; 
	_exp = "(100 * houses) * (100 * deadBody) * (10 + meadow) * (1 - forest) * (1 - trees) - (100 * sea) - (100 * hills)";
	_prec = 100;
	_tpos = getPos _object;
	_bestplace = selectBestPlaces [_tpos,500,_exp,_prec,1];
	_spot = _bestplace select 0;
	_pos = _spot select 0;

};


_pos set [2, 0];
_pos

// end