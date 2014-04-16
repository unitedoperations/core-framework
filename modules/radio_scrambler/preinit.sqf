
/* Set Defines */
#define CHANNEL_STEP 5
#define SEED_STEP 0.025
#define SIDES [CIVILIAN, WEST, EAST, RESISTANCE]

/* Load Libraries */
#include "libraries\backend.sqf"

/* Initialize Server */
if (isServer) then {
	private ["_seed", "_max"];
	_seed = 0;
	_max = (CHANNEL_STEP / SEED_STEP) / (count SIDES);
	rs_radioSeeds = [];
	{ // forEach
		_seed = _seed + random(_max);
		rs_radioSeeds set [_forEachIndex, _seed];
	} forEach SIDES;
	publicVariable "rs_radioSeeds";
};

/* Initialize Client */
if (hasInterface) then {
	[] spawn { // Use waitUntil instead of postInit for speed
		waitUntil {!isNil "rs_radioSeeds" && {!isNull player} && {!isNil "acre_api_fnc_setDefaultChannels"}};
		[(rs_radioSeeds select ((SIDES find (side player)) max 0)), CHANNEL_STEP, SEED_STEP] call rs_fnc_setDefaultChannels;
	};
};
