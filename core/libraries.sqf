
/*
	Title: Core Library Initialization
	Author(s): Naught
	Description:
		Initialization code which loads libraries
		and related functions and variables.
*/

/*
	Function: core_fnc_registerLibrary
	Author(s): Naught
	Description:
		Registers a new library with the framework.
	Parameters:
		0 - Library name [string]
		1 - Library version [number]
		2 - Library authors [array] (optional)
	Returns:
		Nothing
*/
core_fnc_registerLibrary = {
	core_libraries set [(count core_libraries), _this];
};

/*
	Function: core_fnc_checkLibrary
	Author(s): Naught
	Description:
		Checks a library's version, which must be
		the same or higher than the required version.
	Parameters:
		0 - Library name [string]
		1 - Required version [number]
	Returns:
		Library status [bool]
*/
core_fnc_checkLibrary = {
	private ["_result"];
	_result = false;
	{ // forEach
		if (toLower(_x select 0) == toLower(_this select 0)) exitWith {
			_result = (_x select 1) >= (_this select 1);
		};
	} forEach core_libraries;
	_result
};

/* Set Variables */
core_libraries = []

/* Load Libraries */
#include "libraries\arrays.sqf"
#include "libraries\chrono.sqf"
#include "libraries\config.sqf"
#include "libraries\diagnostics.sqf"
#include "libraries\filesystem.sqf"
#include "libraries\math.sqf"
#include "libraries\rve.sqf"
#include "libraries\strings.sqf"
