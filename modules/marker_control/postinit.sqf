#define SYSTEM sideLogic

#define ADDMARKER(SIDE, NAME) \
_markers set [count _markers, [SIDE, NAME]];

if (!isDedicated) then {

	_markers = [];

	#include "settings.sqf"

	{
		if ((_x select 0) != (side player)) then {
			(_x select 1) setMarkerAlphaLocal 0;
		};
	} forEach _markers;
};