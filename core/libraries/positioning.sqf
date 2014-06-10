
/*
	Title: Positioning Function Library
*/

/*
	Section: Definitions
*/

#define SBP_HILL "(1 - forest) * (1 + hills) * (1 - sea)"
#define SPB_TOWN "(1 - forest) * (1 + houses) * (1 - sea)"
#define SBP_FOREST "(1 + forest + trees) * (1 - sea) * (1 - houses)"
#define SBP_MEADOW "(1 + meadow) * (1 - forest) * (1 - hills) * (1 - houses) * (1 - sea)"

/*
	Section: Functions
*/

/*
	Function: core_fnc_getPos
	Author(s): Naught
	Description:
		Gets the position of a thing.
	Parameters:
		0 - Thing [object:marker:array]
	Returns:
		Position [array]
*/

core_fnc_getPos = {
	private ["_thing"];
	_thing = _this select 0;
	
	switch (typeName _thing) do {
		case "OBJECT": {getPos _thing};
		case "STRING": {getMarkerPos _thing};
		case "ARRAY": {getWPPos _thing};
		default {[0,0,0]};
	};
};

/*
	Function: core_fnc_closestPlayerDis
	Author(s): Naught
	Description:
		Retrieves closest player distance.
	Parameters:
		0 - Reference thing [object:marker:array]
	Returns:
		Minimum distance [number]
*/

core_fnc_closestPlayerDis = {
	private ["_ref", "_minDis"];
	_ref = [_this select 0] call core_fnc_getPos;
	_minDis = -1;
	
	{ // forEach
		private ["_dis"];
		_dis = _x distance _ref;
		if ((_dis < _minDis) || {_minDis < 0}) then {
			_minDis = _dis;
		};
	} forEach (call CBA_fnc_players);
	
	_minDis
};

/*
	Function: core_fnc_sortObjectDistance
	Author(s): Naught
	Description:
		Sorts distances between an array of objects and a thing.
	Parameters:
		0 - Object array [object]
		1 - Reference thing [object:marker:array]
	Returns:
		Sorted array [array]
*/

core_fnc_sortObjectDistance = {
	private ["_refPos"];
	_refPos = [_this select 1] call core_fnc_getPos; // Can use in compFunc b/c of SQF scoping
	[(_this select 0), {_this distance _refPos}] call core_fnc_heapSort;
};

/*
	Function: core_fnc_inArea
	Author(s): Olsen
	Description:
		Checks to see if a vehicle is within a marker area.
	Parameters:
		0 - Unit/Vehicle [object]
		1 - Marker [string]
	Returns:
		Object in area [bool]
*/

core_fnc_inArea = {
	private["_object", "_marker", "_result"];
	_object = _this select 0;
	_marker = _this select 1;
	
	private ["_mPos", "_mSize", "_mShape", "_mRadius", "_distance", "_maxMult"];
	_mPos = markerPos _marker;
	_mSize = markerSize _marker;
	_mShape = markerShape _marker;
	_mRadius = (_mSize select 0) max (_mSize select 1);
	_distance = _object distance _mPos;
	
	_maxMult = (switch (_mShape) do
	{
		case "ELLIPSE": {1};
		case "RECTANGLE": {sqrt(2)};
		default {0};
	});
	
	if (_distance > (_mRadius * _maxMult)) exitWith {false}; // Object too far away
	
	private ["_x", "_y", "_dir"];
	_x = ((getPosASL _object) select 0) - (_mPos select 0);
	_y = ((getPosASL _object) select 1) - (_mPos select 1);
	_dir = markerDir _marker;
	
	if (_dir != 0) then {
		private ["_tmp"];
		_tmp = _x * cos(_dir) - _y * sin(_dir);
		_y = _x * sin(_dir) + _y * cos(_dir);
		_x = _temp;
	};
	
	switch (_mShape) do
	{
		case "ELLIPSE": {((_x ^ 2) / ((_mSize select 0) ^ 2) + (_y ^ 2) / ((_mSize select 1) ^ 2)) <= 1};
		case "RECTANGLE": {((abs _x) <= (_mSize select 0)) && {(abs _y) <= (_mSize select 1)}};
		default {false};
	};
};
