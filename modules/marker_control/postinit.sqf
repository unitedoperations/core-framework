if (!isDedicated) then {

	#define NONE sideLogic

	mc_fnc_setMarkerTeam = {
		private["_marker", "_side"];
		_marker = _this select 0;
		_side = _this select 1;
		
		if (_side != (side player)) then {
			_marker setMarkerAlphaLocal 0;
		} else {
			_marker setMarkerAlphaLocal 1;
		};
	};
	
	#include "settings.sqf"
	
};