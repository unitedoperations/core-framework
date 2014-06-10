#define ANY sideLogic

if (!isDedicated) then
{
	al_fnc_addAoMarker = {
		private["_side", "_marker"];
		_side = _this select 0;
		_marker = _this select 1;
		
		if (_side == (side player) || _side == ANY) then
		{
			al_markers set [count al_markers, _marker];	
			_marker setMarkerAlphaLocal 1;
		};
	};
	
	al_fnc_removeAoMarker = {
		private["_side", "_marker"];
		_side = _this select 0;
		_marker = _this select 1;
		
		if (_side == (side player) || _side == ANY) then
		{
			al_markers = al_markers - [_marker];
			_marker setMarkerAlphaLocal 0;
		};
	};
	
	al_markers = [];
	
	#include "settings.sqf"
	
	if ((count al_markers) > 0) then
	{
		0 spawn
		{
			private ["_pos", "_allowedOutside", "_sleep"];
			_pos = getPosATL (vehicle player);
			_allowedOutside = false;
			_sleep = 5;
			
			while {!(player getVariable ["spectating", false])} do
			{
				private ["_vehicle"];
				_vehicle = vehicle player;
				
				if (!(_vehicle isKindOf "Air")) then
				{
					private ["_outSide"];
					_outSide = true;
					
					{ // forEach
						if ([_vehicle, _x] call core_fnc_inArea) exitWith {
							_outSide = false;
						};
					} forEach al_markers;
					
					if (_outside) then
					{
						if (!_allowedOutside) then
						{
							hint "Please stay in the AO!";
							_vehicle setPosATL _pos;
							sleep 0.1;
						};
					}
					else // Inside AOs
					{
						if (_allowedOutside) then {_allowedOutside = false};
						_pos = getPosATL _vehicle;
						sleep 5;
					};
					
				}
				else // In air vehicle
				{
					if (!_allowedOutside) then {_allowedOutside = true};
				};
				
				if (_allowedOutside) then {sleep 10};
			};
		};
	};
};
