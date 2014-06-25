#include "libraries\backend.sqf"

if (isServer) then {
	0 spawn {
		sp_teams = [];
		uisleep 30;
		#include "settings.sqf"
	};
};

if (!isDedicated) then {
	["endScreen", {_this spawn es_fnc_displayEndScreen;}] call CBA_fnc_addEventHandler;
};