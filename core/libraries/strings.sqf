
/*
	Title: String Function Library
*/

/*
	Function: core_fnc_selBinStr
	Author(s): Naught
	Description:
		Selects an index value from a binary string.
	Parameters:
		0 - Binary string [string]
		1 - Binary string index [number]
	Returns:
		Index result [bool]
*/
core_fnc_selBinStr = {
	private ["_binStrArr", "_index"];
	_binStrArr = toArray(_this select 0);
	_index = _this select 1;
	((count _binStrArr) > _index) && {(_binStrArr select _index) == 49}; // 49 = Digit One
};

/*
	Function: core_fnc_timeToRead
	Author(s): Naught
	Description:
		Calculates a rough estimate on how long it will take a reader to
		read a string of text, in seconds. Uses 19 characters per second.
	Parameters:
		0 - String [string]
	Returns:
		Time to read in seconds [number]
*/
core_fnc_timeToRead = {
	count(toArray(_this select 0)) / 19;
};

/*
	Function: core_fnc_formatNumber
	Author(s): Naught
	Description:
		Adds zero-based padding to numbers, or shortens them to specification.
	Parameters:
		0 - Number [number:string]
		1 - Integer Width [number] (optional)
		2 - Decimal Width [number] (optional)
	Returns:
		Formatted number [string]
*/
core_fnc_formatNumber = {
	private ["_number", "_intWidth", "_decWidth"];
	_number = _this select 0;
	_intWidth = [_this, 1, ["SCALAR"], 1] call core_fnc_param;
	_decWidth = [_this, 2, ["SCALAR"], 0] call core_fnc_param;
	if (typeName(_number) != "STRING") then {_number = str(_number)};
	private ["_integer", "_decimal", "_decIndex"];
	_integer = toArray(_number);
	_decimal = [];
	_decIndex = _integer find 46;
	if (_decIndex >= 0) then { // Decimal number
		for "_i" from (_decIndex + 1) to ((count _integer) - 1) do {
			[_decimal, (_integer select _i)] call core_fnc_push;
		};
		_integer resize _decIndex;
		while {(count _decimal) < _decWidth} do {
			[_decimal, 48] call core_fnc_push;
		};
		_decimal resize _decWidth;
	};
	for "_i" from 1 to (_intWidth - (count _integer)) do {
		_integer = [48] + _integer;
	};
	_integer resize _intWidth;
	toString(_integer + (if ((count _decimal) > 0) then {[46] + _decimal} else {[]}));
};

/*
	Function: core_fnc_formatDate
	Author(s): Naught
	Description:
		Formats a passed date to specification
	Parameters:
		0 - Date [array]
		1 - Format [string]
	Returns:
		Formatted date [string]
	Notes:
		1. Date is in format [year, month, day, hour, minute].
		2. Format parameters are as follows:
			%1 = Year
			%2 = Month
			%3 = Day
			%4 = Hour
			%5 = Minute
*/
core_fnc_formatDate = {
	private ["_date", "_month"];
	_date = _this select 0;
	_month = switch (_date select 1) do {
		case 1: {"January"};
		case 2: {"February"};
		case 3: {"March"};
		case 4: {"April"};
		case 5: {"May"};
		case 6: {"June"};
		case 7: {"July"};
		case 8: {"August"};
		case 9: {"September"};
		case 10: {"October"};
		case 11: {"November"};
		case 12: {"December"};
		default {"Month"};
	};
	format[(_this select 1),
		(_date select 0),
		_month,
		(_date select 2),
		([(_date select 3), 2] call core_fnc_formatNumber),
		([(_date select 4), 2] call core_fnc_formatNumber)
	];
};