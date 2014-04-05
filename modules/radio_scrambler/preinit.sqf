
#define CHANNEL_STEP 5
#define SEED_STEP 0.025

private ["_sides"];
_sides = [CIVILIAN, WEST, EAST, RESISTANCE];

if (isServer) then {
	private ["_seed", "_max"];
	_seed = 0;
	_max = (CHANNEL_STEP / SEED_STEP) / (count _sides);
	rs_radioSeeds = [];
	{ // forEach
		_seed = _seed + random(_max);
		rs_radioSeeds set [_forEachIndex, _seed];
	} forEach _sides;
	publicVariable "rs_radioSeeds";
};

if (hasInterface) then {
	[] spawn { // Use waitUntil instead of postInit for speed
		waitUntil {!(isNil "rs_radioSeeds") && {!(isNull player)}};
		private ["_index"];
		_index = _sides find (side player);
		if (_index < 0) then {_index = 0};
		[(rs_radioSeeds select _index), CHANNEL_STEP, SEED_STEP] call rs_fnc_setChannelDefaults;
	};
};
