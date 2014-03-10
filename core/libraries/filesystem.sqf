
/*
	Title: Filesystem Function Library
	Notes:
		1. When updating the library, increment the
		below library register version number by one.
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
	Function: core_fnc_loadModule
	Author(s): Naught
	Description:
		Loads a module in a specified environment.
	Parameters:
		0 - Module config path [config]
		1 - Module load type name [string]
		2 - Run in scheduled environment [bool] (optional)
	Returns:
		Module return value [any]
*/
core_fnc_loadModule = {
	private ["_cfg", "_type", "_scheduled", "_cfgName", "_exec"];
	_cfg = _this select 0;
	_type = _this select 1;
	_scheduled = [_this, 2, ["BOOL"], false] call core_fnc_param;
	_cfgName = configName(_cfg);
	["Info", "core_fnc_loadModule", "Loading module '%1' %2.", [_cfgName, _type], __FILE__, __LINE__] call core_fnc_log;
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
};
