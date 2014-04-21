

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
		3 - Gear class or module-relative loadout file path [string]
		4 - Absolute loadout file path [string] (optional)
	Examples:
		[this, "1'1", "MAIN", "usmc_sl"] call gear_fnc_setLoadout; // Loads "modules\gear\loadouts\usmc_sl.sqf"
		[this, "2'4", "BLUE", "us_army\rifleman.sqf"] call gear_fnc_setLoadout; // Loads "modules\gear\loadouts\us_army\rifleman.sqf"
		[this, "1'6", "RED", "medic", "scripts\gear\idf.sqf"] call gear_fnc_setLoadout; // Loads "scripts\gear\idf.sqf"
	Notes:
		1. For vehicles, the group name or fire team doesn't matter.
		2. The available fire teams are: "MAIN", "RED", "GREEN", "BLUE" or "YELLOW".
		3. You can configure a single file for loading all of the classes for a specific faction/side/etc. by
		   settings the loadout file parameter to point to that file and then using the passed class to internally
		   determine what gear to give the unit, for example by using the switch statement (reference example 3 above).
		4. All parameters passed to this function are then passed to the gear script.
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
	_this spawn compile preprocessFileLineNumbers ([_this, 4, ["STRING"], ("modules\gear\loadouts\" + _class)] call core_fnc_param);
};
