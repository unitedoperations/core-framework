#include "libraries\backend.sqf"

if (isServer) then {
	sp_teams = [];
	#include "settings.sqf"
	["test secnario"] spawn es_fnc_endMission; // this is just for testing
};

if (!isDedicated) then {
	["endScreen", {_this spawn es_fnc_displayEndScreen;}] call CBA_fnc_addEventHandler;
};