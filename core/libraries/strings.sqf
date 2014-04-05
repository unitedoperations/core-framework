
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