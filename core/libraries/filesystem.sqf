
/*
	Title: Filesystem Function Library
*/

/*
	Function: core_fnc_isFilePath
	Author(s): Naught
	Description:
		Returns whether a string is a valid
		file path (doesn't verify path).
	Parameters:
		0 - File path to check [string]
	Returns:
		Is file path [bool]
*/
core_fnc_isFilePath = {
	private ["_stringArray"];
	_stringArray = toArray(_this select 0);
	(46 in _stringArray) && {!(34 in _stringArray)} && {!(39 in _stringArray)} // 46='.', 34=("), 39=(') (ie: 'path\file.sqf')
};

/*
	Function: core_fnc_compileFile
	Author(s): Naught
	Description:
		Compiles a file and checks for contents.
	Parameters:
		0 - File path [string]
	Returns:
		Compiled file [code:nil]
*/
core_fnc_compileFile = {
	private ["_file"];
	_file = preprocessFileLineNumbers (_this select 0);
	if (_file != "") then {
		compile _file;
	} else {{}}; // Is empty code okay?
};

/*
	Function: core_fnc_registerModule
	Author(s): Naught
	Description:
		Registers a new module state.
	Parameters:
		0 - Module name [string]
		1 - Module load type name [string]
	Returns:
		New register status [bool]
*/
core_fnc_registerModule = {
	if (isNil "core_moduleList") then {core_moduleList = []};
	private ["_module", "_type", "_result"];
	_module = _this select 0;
	_type = _this select 1;
	_result = true;
	{ // forEach
		if (((_x select 0) == _module) && {(_x select 1) == _type}) exitWith {
			_result = false;
		};
	} forEach core_moduleList;
	if (!_result) then { // Register new module state
		[core_moduleList, [_module, _type]] call core_fnc_push;
	};
	_result
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
	private ["_cfg", "_type", "_scheduled"];
	_cfg = _this select 0;
	_type = _this select 1;
	_scheduled = [_this, 2, ["BOOL"], false] call core_fnc_param;
	if (isClass(_cfg)) then {
		if (([_cfg >> "required_version", 0] call core_fnc_getConfigValue) > core_version) exitWith { // Outdated Core
			["Error", "core_fnc_loadModule", "Cannot load module '%1' @ %2: Core framework outdated (currently v%3).", [_cfgName, _type, core_version], __FILE__, __LINE__] call core_fnc_log;
			nil; // Function will return nil
		};
		private ["_cfgName", "_loadedModules"];
		_cfgName = configName(_cfg);
		_loadedModules = [];
		if ([_cfgName, _type] call core_fnc_registerModule) then {
			["Info", "core_fnc_loadModule", "Loading module '%1' %2.", [_cfgName, _type], __FILE__, __LINE__] call core_fnc_log;
			private ["_requirements", "_depError"];
			_requirements = [_cfg >> "requirements", []] call core_fnc_getConfigValue;
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
				private ["_exec"];
				_exec = [(_cfg >> _type), ("modules\" + _cfgName + "\" + _type + ".sqf")] call core_fnc_getConfigValue;
				_exec = if ([_exec] call core_fnc_isFilePath) then {
					[_exec] call core_fnc_compileFile;
				} else {
					compile _exec;
				};
				if (_scheduled) then {
					[] spawn _exec;
				} else {
					[] call _exec;
				};
				["Info", "core_fnc_loadModule", "Loaded module '%1' %2.", [_cfgName, _type], __FILE__, __LINE__] call core_fnc_log;
				[_loadedModules, _cfgName] call core_fnc_push;
			};
		};
		_loadedModules;
	} else {nil};
};
