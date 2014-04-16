

/*
	Function: gear_fnc_setLoadout
	Author(s): Naught
	Description:
		Sets the loadout of a unit or vehicle by loading
		a loadout script file in the "loadouts" directory.
	Parameters:
		0 - Unit or vehicle [object]
		1 - Group Name [string]
		2 - Fire Team [string]
		3 - Gear class or loadout file [string]
	Examples:
		[this, "1'1", "MAIN", "usmc_sl"] call gear_fnc_setLoadout;
		[this, "1'2", "BLUE", "west\rifleman.sqf"] call gear_fnc_setLoadout;
	Notes:
		1. For vehicles, the group name or fire team doesn't matter.
		2. The availabe fire teams are: "MAIN", "RED", "GREEN", "BLUE" or "YELLOW".
	Returns:
		Nothing [nil]
*/
gear_fnc_setLoadout = {
	private ["_obj", "_class"];
	_obj = _this select 0;
	_class = _this select 3;
	if (_obj isKindOf "Man") then {
		(group _obj) setGroupId [_this select 1];
		_obj assignTeam (_this select 2);
	};
	if !([_class] call core_fnc_isFilePath) then {
		_class = _class + ".sqf";
	};
	_obj spawn compile preprocessFileLineNumbers ("modules\gear\loadouts\" + _class);
};
