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
			private ["_marker", "_pos"];
			_marker = [];
			
			{
				if (((_x select 0) == (side player)) && [(vehicle player), (_x select 2)] call core_fnc_inArea) exitWith {
					_marker = [(_x select 1), (_x select 2)];	
					(_marker select 1) setMarkerAlphaLocal 1;
				};
			} forEach sut_markers;
			
			_pos = getPosATL (vehicle player);
			
			if ((count _marker) > 0) then {
				#define SETUP_START_TEXT	("<t size=3 align=left>You Have </t><t size=3 color='#6599FF' shadow='1' shadowColor='#000000' align=left>%1</t><t size=3 align=left> Seconds Setup Time.</t>")
				#define SETUP_OOB_TEXT		("The Setup Area Ends Here.")
				#define SETUP_END_TEXT		("<t size=3 align=left>SETUP COMPLETE!</t>")
				[SETUP_START_TEXT, _marker, false, 10] call core_fnc_hint;
				while {(count _marker) > 0} do {
					private ["_vehicle"];
					_vehicle = (vehicle player);
				
					if ([_vehicle, (_marker select 1)] call core_fnc_inArea) then {
						_pos = getPosATL _vehicle;
					} else {
						[SETUP_OOB_TEXT, [], false, 0.1] call core_fnc_hint;
						_vehicle setPos _pos;
					};
					
					if (time >= (_marker select 0)) then {
						[SETUP_END_TEXT, [], false, 5] call core_fnc_hint;
						(_marker select 1) setMarkerAlphaLocal 0;
						_marker = [];
					};
					sleep(0.1);
				};
			};
		};
	
	};
	
};