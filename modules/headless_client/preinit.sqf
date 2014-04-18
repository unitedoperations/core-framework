
/* Load Functions */

hc_fnc_loadMissionObjects = {
	private ["_groupsCfg"];
	_groupsCfg = missionConfigFile >> "Mission" >> "Mission" >> "Groups";
	for "_i" from 0 to ((count _groupsCfg) - 1) do {
		private ["_groupCfg"];
		_groupCfg = _groupsCfg select _i;
		if (isClass(_groupCfg)) then {
			[_groupCfg, {
				!isText(_this >> "player") &&
				{[_this >> "presence", 1] call core_fnc_getConfigValue == 0} &&
				{!(([_this >> "side", "EMPTY"] call core_fnc_getConfigValue) in ["EMPTY", "LOGIC", "AMBIENT LIFE"])}
			}] call core_fnc_spawnMissionGroup;
		};
	};
};

/* Initialize All */

"hc_processMissionObjects" addPublicVariableEventHandler {
	if (local(_this select 1)) then {
		[] call hc_fnc_loadMissionObjects;
	};
};

/* Initialize Server */

if (isServer) then {
	hc_headlessClient = objNull;
	"hc_headlessClientFlag" addPublicVariableEventHandler {
		if (isServer) then {
			hc_headlessClient = _this select 1;
		};
	};
};
