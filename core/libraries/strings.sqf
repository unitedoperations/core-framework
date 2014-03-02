
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
	((count _binStrArr) > _index) && {(_binStrArr select _index) == 31}; // U+0031 = Digit One
};