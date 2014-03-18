if (!isDedicated) then {

	#define SYSTEM sideLogic

	mc_fnc_setMarkerTeam = {
		private["_marker", "_side"];
		_marker = _this select 0;
		_side = _this select 1;
		
		if (_side != (side player)) then {
			_marker setMarkerAlphaLocal 0;
		};
	};
	
	#include "settings.sqf"
	
};