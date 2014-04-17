
/*
	Title: Mission Function Library
*/

#define __objCfg(val,dft) ([_cfg >> val, dft] call core_fnc_getConfigValue)

/*
	Function: core_fnc_fixMissionPos
	Author(s): Naught
	Description:
		Convert from mission.sqm position to game position.
		Flips Y and Z values.
	Parameter:
		Mission Position [array]
	Returns:
		Game Position [array]
*/
core_fnc_fixMissionPos = {
	[(_this select 0), (_this select 2), (_this select 1)]
};

/*
	Function: core_fnc_spawnMissionObject
	Author(s): Naught
	Description:
		Creates a mission object (from editor).
	Parameters:
		0 - Group [group]
		1 - Mission Object Config [config]
	Returns:
		Object [object]
	Notes:
		1. What doesn't work:
			- Special "In Cargo"
			- Any Info Age
			- Ammo Levels
*/
core_fnc_spawnMissionObject = {
	private ["_group", "_cfg", "_object"];
	_group = _this select 0;
	_cfg = _this select 1;
	_object = objNull;
	if (__objCfg("side", "EMPTY") in ["EMPTY", "LOGIC"]) then {
		// Vehicle
		_object = createVehicle [
			__objCfg("vehicle", ""),
			(__objCfg("position", []) call core_fnc_fixMissionPos),
			[],
			__objCfg("placement", 0),
			__objCfg("special", "FORM")
		];
	} else {
		// Unit
		private ["_object"];
		_object = _group createUnit [
			__objCfg("vehicle", ""),
			(__objCfg("position", []) call core_fnc_fixMissionPos),
			[],
			__objCfg("placement", 0),
			__objCfg("special", "FORM")
		];
	};
	_object setVehicleId __objCfg("id", 0);
	if (isText(_cfg >> "text")) then {
		private ["_vehVarName"];
		_vehVarName = getText(_cfg >> "text");
		_object setVehicleVarName _vehVarName;
		core_mission_setVehicleVarName = [_object, _vehVarName];
		publicVariable "core_mission_setVehicleVarName";
		missionNamespace setVariable [_vehVarName, _object, true];
	};
	_object setDir __objCfg("azimut", 0);
	_object setSkill __objCfg("skill", 0.6);
	_object setRank __objCfg("rank", "PRIVATE");
	_object setDamage (1 - __objCfg("health", 1));
	if (__objCfg("leader", 0) == 1) then {
		_group selectLeader _object;
	};
	this = _object;
	call compile __objCfg("init", "");
	_object
};

/*
	Function: core_fnc_addMissionWaypoint
	Author(s): Naught
	Description:
		Adds a mission waypoint (from editor).
	Parameters:
		0 - Group [group]
		1 - Mission Waypoint Config [config]
	Returns:
		Waypoint [array]
*/
core_fnc_addMissionWaypoint = {
	private ["_group", "_cfg", "_wpt"];
	_group = _this select 0;
	_cfg = _this select 1;
	_wpt = _group addWaypoint [
		(__objCfg("position", []) call core_fnc_fixMissionPos),
		__objCfg("placement", 0)
	];
	_wpt setWaypointType __objCfg("type", "MOVE");
	_wpt setWaypointBehaviour __objCfg("combat", "UNCHANGED");
	_wpt setWaypointCombatMode __objCfg("combatMode", "NO CHANGE");
	_wpt setWaypointCompletionRadius __objCfg("completitionRadius", 5);
	_wpt setWaypointDescription __objCfg("description", "");
	_wpt setWaypointFormation __objCfg("formation", "NO CHANGE");
	_wpt setWaypointScript __objCfg("script", "");
	_wpt setWaypointSpeed __objCfg("speed", "UNCHANGED");
	_wpt setWaypointStatements [__objCfg("expCond", "true"), __objCfg("expActiv", "")];
	_wpt setWaypointTimeout [
		__objCfg("timeoutMin", 0),
		__objCfg("timeoutMid", 0),
		__objCfg("timeoutMax", 0)
	];
	_wpt
};

/*
	Function: core_fnc_spawnMissionGroup
	Author(s): Naught
	Description:
		Creates and spawns a mission group (from editor).
	Parameters:
		0 - Mission Group Config [config]
		1 - Vehicle Spawn Condition [code] (optional)
	Returns:
		Group [group]
*/
core_fnc_spawnMissionGroup = {
	private ["_cfg", "_vehCond", "_side", "_group"];
	_cfg = _this select 0;
	_vehCond = [_this, 1, ["CODE"], {true}] call core_fnc_param;
	_side = switch (toLower(getText(_cfg >> "side"))) do {
		case "west": {west};
		case "east": {east};
		case "guer": {resistance};
		default {civilian};
	};
	_group = createGroup _side;
	// Spawn objects
	private ["_vehCfg"];
	_vehCfg = _cfg >> "Vehicles";
	for "_i" from 0 to ((count _vehCfg) - 1) do {
		private ["_objCfg"];
		_objCfg = _vehCfg select _i;
		if (isClass(_objCfg) && {_objCfg call _vehCond}) then {
			[_group, _objCfg] call core_fnc_spawnMissionObject;
		};
	};
	if ((count (units _group)) > 0) then {
		// Add start waypoint
		_group addWaypoint [getPos(leader _group), 0];
	};
	// Add other waypoints
	private ["_wptCfg"];
	_wptCfg = _cfg >> "Waypoints";
	if (isClass(_wptCfg)) then {
		for "_i" from 0 to ((count _wptCfg) - 1) do {
			private ["_wpt"];
			_wpt = _wptCfg select _i;
			if (isClass(_wpt)) then {
				[_group, _wpt] call core_fnc_addMissionWaypoint;
			};
		};
	};
	// Return
	_group
};

/* Library Initialization */

"core_mission_setVehicleVarName" addPublicVariableEventHandler {
	private ["_val"];
	_val = _this select 1;
	(_val select 0) setVehicleVarName (_val select 1);
};
