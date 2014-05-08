
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
	private["_object", "_marker", "_pos", "_xSize", "_ySize", "_radius", "_result", "_x", "_y", "_temp"];
	_object = _this select 0;
	_marker = _this select 1;
	
	_pos = markerPos _marker;
	_xSize = (markerSize _marker) select 0;
	_ySize = (markerSize _marker) select 1;
	_radius = _xSize;
	
	if (_ySize > _xSize) then {
		_radius = _ySize;
	};
	
	_result = false;
	
	if ((_object distance _pos) <= (_radius * 1.5)) then {
		_x = (getPosASL _object) select 0;
		_y = (getPosASL _object) select 1;
		_angle = markerDir _marker;
		_x = _x - (_pos select 0);
		_y = _y - (_pos select 1);
		
		if (_angle != 0) then {
			_temp = _x * cos(_angle) - _y * sin(_angle);
			_y = _x * sin(_angle) + _y * cos(_angle);
			_x = _temp;
		};	
		
		if ((markerShape _marker) == "ELLIPSE") then {
			if (_xSize == _ySize) then {
				if ((_object distance _pos) <= _radius) then {
					_result = true;	
				};
			} else {
				if (((_x ^ 2) / (_xSize ^ 2) + (_y ^ 2) / (_ySize ^ 2)) <= 1) then {
					_result = true;
				};
			};
		} else {
			if ((abs _x) <= _xSize && (abs _y) <= _ySize) then {
				_result = true;
			};
		};
	};
	
	_result
};
