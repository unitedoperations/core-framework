#include "libraries\backend.sqf"

if (isServer) then {
	sp_teams = [];
	#include "settings.sqf"
};

if (!isDedicated) then {
	["endScreen", {_this spawn es_fnc_displayEndScreen;}] call CBA_fnc_addEventHandler;
};