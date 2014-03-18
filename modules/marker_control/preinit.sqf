if (!isDedicated) then {

	#define SYSTEM sideLogic

	mc_fnc_setMarkerTeam = {
		(_this select 0) setMarkerAlphaLocal 0;
	};
	
	#include "settings.sqf"
	
};