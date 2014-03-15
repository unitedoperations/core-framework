

/*
	Function: gear_fnc_setLoadout
	Author(s): Naught
	Description:
		Sets the loadout of a unit or vehicle by loading
		a loadout script file in the "loadouts" directory.
	Parameters:
		0 - Unit or vehicle [object]
		1 - Gear class or loadout file [string]
	Examples:
		[this, "squadleader"] call gear_fnc_setLoadout;
		[this, "west\rifleman.sqf"] call gear_fnc_setLoadout;
	Returns:
		Success [bool]
*/
gear_fnc_setLoadout = {
	private ["_obj", "_class"];
	_obj = _this select 0;
	_class = _this select 1;
	if !([_class] call core_fnc_isFilePath) then {
		_class = _class + ".sqf";
	};
	_obj call compile preprocessFileLineNumbers ("modules\gear\loadouts\" + _class);
};
