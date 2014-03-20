if (!isDedicated) then {

	#define NONE sideLogic

	mc_fnc_setMarkerTeam = {
		(_this select 1) setMarkerAlphaLocal 0;
	};
	
	#include "settings.sqf"
	
};