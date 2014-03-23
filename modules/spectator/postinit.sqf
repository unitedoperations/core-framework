if (isServer) then {
	sp_fnc_createMarker = {
		private["_marker"];
		_marker = createMarker [(_this select 0), [0, 0, 0]];
		_marker setMarkerShape "ICON";
		_marker setMarkerType "EMPTY";
	};

	["respawn_west"] call _sp_fnc_createMarker;
	["respawn_east"] call _sp_fnc_createMarker;
	["respawn_guerrila"] call _sp_fnc_createMarker;
	["respawn_civilian"] call _sp_fnc_createMarker;
};

if (!isDedicated) then {
	#include "libraries\backend.sqf"
	
	killedEh = player addEventHandler ["Killed", {sp_body = player;sp_side = side player;[] spawn sp_fnc_prep;}];
};