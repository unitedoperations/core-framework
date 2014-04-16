if (isServer) then {
	{
		private["_marker"];
		_marker = createMarker [_x, [0, 0, 0]];
		_marker setMarkerShape "ICON";
		_marker setMarkerType "EMPTY";
	} forEach ["respawn_west", "respawn_east", "respawn_guerrila", "respawn_civilian"];
};

if (!isDedicated) then {
	#include "libraries\backend.sqf"
	
	sp_killedEh = player addEventHandler ["Killed", {sp_body = player;sp_side = side player;[] spawn sp_fnc_prep;}];
};