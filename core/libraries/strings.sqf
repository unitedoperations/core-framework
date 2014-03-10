
/*
	Title: String Function Library
	Notes:
		1. When updating the library, increment the
		below library register version number by one.
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