
/*
	Title: Conversion Function Library
	Notes:
		1. When updating the library, increment the
		below library register version number by one.
*/

["conversions", 1] call core_fnc_registerLibrary;

/*
	Function: core_fnc_sideToText
	Author(s): Naught
	Description:
		Converts a side to human-readable text.
	Parameters:
		0 - Side [side]
	Returns:
		Side name [string]
*/
core_fnc_sideToText = {
	switch (_this select 0) do {
		case WEST: {'Blufor'};
		case EAST: {'Opfor'};
		case RESISTANCE: {'Independent'};
		case CIVILIAN: {'Civilian'};
		case SIDEENEMY: {'Renegade'};
		case SIDEFRIENDLY: {'Friendlies'};
		case default {'NULL'};
	};
};

/*
	Function: core_fnc_toBool
	Author(s): Naught
	Description:
		Evaluates an expression to a boolean value.
	Parameters:
		0 - Expression [any]
	Returns:
		Conversion [bool]
	Notes:
		1. Do not use this for raw input or persistant data.
*/
core_fnc_toBool = {
	private ["_eval"];
	_eval = _this select 0;
	if (typeName(_eval) == typeName("")) then {
		_eval = if (_eval == "") then {false} else {compile _eval};
	};
	if (typeName(_eval) == typeName({})) then {
		_eval = (if ((count _this) > 1) then {_this select 1} else {[]}) call _eval;
	};
	if (typeName(_eval) == typeName(1)) then {
		switch (_eval) do {
			case 0: {_eval = false;};
			case 1: {_eval = true;};
		};
	};
	if (typeName(_eval) != typeName(true)) then {
		_eval = false;
	};
	_eval
};
	