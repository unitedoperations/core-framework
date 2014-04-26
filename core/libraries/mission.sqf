
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
	
	//_object setVehicleId __objCfg("id", 0);
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

/*
	Function: core_fnc_loadModule
	Author(s): Naught
	Description:
		Loads a module in a specified environment.
		Also loads all module dependencies.
	Parameters:
		0 - Module config path [config]
		1 - Module load type name [string]
		2 - Run in scheduled environment [bool] (optional)
	Returns:
		Loaded modules [array]
*/

core_fnc_loadModule = {
	private ["_cfg", "_type", "_scheduled", "_exec"];
	_cfg = _this select 0;
	_type = _this select 1;
	_scheduled = [_this, 2, ["BOOL"], false] call core_fnc_param;
	_exec = [(_cfg >> _type), ""] call core_fnc_getConfigValue;
	
	if (_exec != "") then {
		
		if (([_cfg >> "required_version", 0] call core_fnc_getConfigValue) > core_version) exitWith { // Outdated Core
			["Error", "core_fnc_loadModule", "Cannot load module '%1' @ %2: Core framework outdated (currently v%3).", [_cfgName, _type, core_version], __FILE__, __LINE__] call core_fnc_log;
			nil // Function will return nil
		};
		
		private ["_cfgName", "_loadedModules", "_register"];
		_cfgName = configName(_cfg);
		_loadedModules = [];
		_register = true;
		
		{ // forEach
			if (((_x select 0) == _cfgName) && {(_x select 1) == _type}) exitWith {
				_register = false;
			};
		} forEach core_moduleList;
		
		if (_register) then { // Register new module state
			[core_moduleList, [_cfgName, _type]] call core_fnc_push;
			
			["Info", "core_fnc_loadModule", "Loading module '%1' %2.", [_cfgName, _type], __FILE__, __LINE__] call core_fnc_log;
			
			private ["_requirements", "_depError"];
			_requirements = [_cfg >> "dependencies", []] call core_fnc_getConfigValue;
			_depError = false;
			
			{ // forEach
				if (isClass(missionConfigFile >> "Modules" >> _x) || {!isClass(configFile >> "CfgPatches" >> _x)}) then {
					private ["_retModules"];
					_retModules = [missionConfigFile >> "Modules" >> _x, _type, _scheduled] call core_fnc_loadModule;
					
					if (isNil "_retModules") exitWith {
						_depError = true;
						["Error", "core_fnc_loadModule", "Cannot load module '%1' @ %2: Missing dependency '%3'.", [_cfgName, _type, _x], __FILE__, __LINE__] call core_fnc_log;
					};
					
					_loadedModules = _loadedModules + _retModules;
				};
			} forEach _requirements;
			
			if (!_depError) then {
				_exec = if ([_exec] call core_fnc_isFilePath) then {["modules\" + _cfgName + "\" + _exec] call core_fnc_compileFile} else {compile _exec};
				
				if (_scheduled) then {
					[] spawn _exec;
				} else {
					[] call _exec;
				};
				
				[_loadedModules, _cfgName] call core_fnc_push;
			};
		};
		
		_loadedModules
	} else {nil};
};

/* Library Initialization */

core_moduleList = [];

"core_mission_setVehicleVarName" addPublicVariableEventHandler {
	private ["_val"];
	_val = _this select 1;
	(_val select 0) setVehicleVarName (_val select 1);
};
