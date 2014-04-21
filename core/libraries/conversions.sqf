
/*
	Title: Conversion Function Library
*/

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
		1. Not safe for user input.
*/
core_fnc_toBool = {
	private ["_eval"];
	_eval = _this select 0;
	
	if (typeName(_eval) == "STRING") then {
		_eval = if (_eval == "") then {false} else {compile _eval};
	};
	
	if (typeName(_eval) == "CODE") then {
		_eval = (if ((count _this) > 1) then {_this select 1} else {[]}) call _eval;
	};
	
	if (typeName(_eval) == "SCALAR") then {
		switch (_eval) do {
			case 0: {_eval = false;};
			case 1: {_eval = true;};
		};
	};
	
	if (typeName(_eval) != "BOOL") then {
		_eval = false;
	};
	
	_eval
};

/*
	Function: core_fnc_toNumber
	Author(s): Naught
	Description:
		Extracts a number value from an expression.
	Parameters:
		0 - Expression [anything]
	Returns:
		Value [number]
	Notes:
		1. Not safe for user input.
*/
core_fnc_toNumber = {
	private ["_val"];
	_val = _this select 0;
	
	if (typeName(_val) == "STRING") then {
		_val = compile _val;
	};
	
	if (typeName(_val) == "CODE") then {
		_val = call _val;
	};
	
	if (typeName(_val) == "BOOL") then {
		_val = if (_val) then {1} else {0};
	};
	
	if (typeName(_val) != "SCALAR") then {
		_val = -1;
	};
	
	_val
};

/*
	Function: core_fnc_toString
	Author(s): Naught
	Description:
		Converts a value to a string.
	Parameters:
		0 - Value [any]
	Returns:
		String conversion [string]
*/
core_fnc_toString = {
	private ["_val"];
	_val = _this select 0;
	
	switch (typeName(_val)) do {
		case "STRING": {_val};
		case "ARRAY": {
			private ["_ret"];
			_ret = "";
			
			{ // forEach
				if (_forEachIndex != 0) then {_ret = _ret + ", "};
				_ret = _ret + ([_x] call core_fnc_toString);
			} forEach _val;
			
			_ret
		};
		case "SIDE": {[_val] call core_fnc_sideToText};
		default {str(_val)};
	};
};
	