if (!isDedicated) then {

	sut_fnc_addSetupMarker = {
		private["_side", "_time", "_name"];
		_side = _this select 0;
		_time = _this select 1;
		_name = _this select 2;
	
		sut_markers set [count sut_markers, [_side, _time, _name]];
	};

	sut_markers = [];

	#include "settings.sqf"

	if ((count sut_markers) > 0) then {
	
		[] spawn {
			
			_marker = [];
			
			{
				if (((_x select 0) == (side player)) && [(vehicle player), (_x select 2)] call al_fnc_inArea) exitWith {
					_marker = [(_x select 1), (_x select 2)];	
					(_marker select 1) setMarkerAlphaLocal 1;
				};
			} forEach sut_markers;
			
			_pos = getPosATL (vehicle player);
			
			while {(count _marker) > 0} do {
			
				_vehicle = (vehicle player);
			
				if ([_vehicle, (_marker select 1)] call al_fnc_inArea) then {
					_pos = getPosATL _vehicle;
				} else {
					_vehicle setPos _pos;
				};
				
				hintSilent format["Seconds remaining: %1", round((_marker select 0) - time)];
				
				if (time >= (_marker select 0)) then {
					hint "Setup timer expired";
					(_marker select 1) setMarkerAlphaLocal 0;
					_marker = [];
				};
				
				sleep(0.1);
				
			};

		};
	
	};
	
};