
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
