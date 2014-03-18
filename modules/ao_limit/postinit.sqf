#define ANY sideLogic

al_fnc_inArea = {
	private["_unit", "_marker", "_pos", "_xSize", "_ySize", "_radius", "_result", "_x", "_y", "_temp"];

	_unit = _this select 0;
	_marker = _this select 1;

	_pos = markerPos _marker;

	_xSize = (markerSize _marker) select 0;
	_ySize = (markerSize _marker) select 1;

	_radius = _xSize;
	if (_ySize > _xSize) then {

		_radius = _ySize;
		
	};

	_result = false;

	if ((_unit distance _pos) <= (_radius * 1.5)) then {

		_x = (getPosASL _unit) select 0;
		_y = (getPosASL _unit) select 1;

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
			
				if ((_unit distance _pos) <= _radius) then {
				
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

if (!isDedicated) then {

	al_fnc_addAoMarker = {
		private["_side", "_marker"];
		_side = _this select 0;
		_marker = _this select 1;
		
		if (_side == (side player) || _side == ANY) then {
			al_markers set [count al_markers, _marker];	
			_marker setMarkerAlphaLocal 1;
		};
	};

	al_fnc_removeAoMarker = {
		private["_side", "_marker"];
		_side = _this select 0;
		_marker = _this select 1;
		
		if (_side == (side player) || _side == ANY) then {
			al_markers = al_markers - [_marker];
			_marker setMarkerAlphaLocal 0;
		};
	};

	al_markers = [];

	#include "settings.sqf"

	if ((count al_markers) > 0) then {
	
		[] spawn {
			
			_pos = getPosATL (vehicle player);
			_allowedOutside = false;
			
			while {true} do {
			
				_vehicle = (vehicle player);
				
				if (!(_vehicle isKindOf "Air")) then {
			
					_outSide = true;
				
					{
						if ([_vehicle, _x] call al_fnc_inArea) exitWith {
							_outSide = false;
						};
					} forEach al_markers;
					
					if (_outside) then {
						if (!(_allowedOutside)) then {
							_vehicle setPos _pos;
						};
					} else {
						_allowedOutside = false;
						_pos = getPosATL _vehicle;
					};
				
				} else {
					_allowedOutside = true;
				};
				
				sleep(0.1);
				
			};

		};
	
	};
	
};