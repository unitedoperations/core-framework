
/*
	Function: fmh_fnc_addFlexiButton
	Author(s): Naught
	Description:
		Adds a button to the CBA flexi menu.
	Parameters:
		0 - Button type [string] ('interaction' or 'selfInteraction')
		1 - Button name [string]
		2 - Button action [string:code]
		3 - Parent menu [string] (optional)
		4 - Enabled condition [bool:string:code] (optional)
		5 - Visible condition [bool:string:code] (optional)
		6 - Icon path [string] (optional)
		7 - Tool-tip [string] (optional)
		8 - Shortcut key code [number] (optional)
	Returns:
		Button ID [number]
*/
fmh_fnc_addFlexiButton = {
	private ["_type", "_menu", "_menuDefs", "_menuDefIndex", "_buttonIndex", "_keyIndex", "_flexiMenu"];
	_type = _this select 0;	// 'interaction' or 'selfInteraction'
	_menu = [_this, 3, ["STRING"], "main"] call core_fnc_param;
	_menuDefs = [_type, 0] call fmh_fnc_flexiMenuType;
	_menuDefIndex = -1;
	for "_i" from 0 to ((count _menuDefs) - 1) do {
		private ["_menuDef"];
		_menuDef = _menuDefs select _i;
		if (((_menuDef select 0) select 0) == _menu) exitWith {_menuDefIndex = _i};
	};
	if (_menuDefIndex < 0) then {
		_flexiMenu = [[_menu, ([_this, 10, ["STRING"], "Main Menu"] call core_fnc_param)], []];
		_menuDefIndex = count _menuDefs;
	} else {
		_flexiMenu = _menuDefs select _menuDefIndex;
	};
	_buttonArray = _flexiMenu select 1;
	_buttonIndex = count _buttonArray;
	_buttonArray set [_buttonIndex, [
		(_this select 1),
		(_this select 2),
		[_this, 6, ["STRING"], ""] call core_fnc_param,
		[_this, 7, ["STRING"], ""] call core_fnc_param,
		[_this, 9, ["STRING"], ""] call core_fnc_param,
		[_this, 8, ["SCALAR"], -1] call core_fnc_param,
		[_this, 4, ["BOOL"], true] call core_fnc_param,
		[_this, 5, ["BOOL"], true] call core_fnc_param,
	]];
	_flexiMenu set [1, _buttonArray];
	_menuDefs set [_menuDefIndex, _flexiMenu];
	[_type, 1, _menuDefs] call fmh_fnc_flexiMenuType;
	_keyIndex = count fmh_flexiMenuKeys;
	fmh_flexiMenuKeys set [_keyIndex, [_type, _menuDefIndex, _buttonIndex]];
	_keyIndex
};

/*
	Function: fmh_fnc_addFlexiMenu
	Author(s): Naught
	Description:
		Adds a new menu button to the CBA flexi menu.
	Parameters:
		0 - Menu type [string] ('interaction' or 'selfInteraction')
		1 - Menu identifier [string]
		2 - Menu name/caption [string]
		3 - Enabled condition [bool:string:code] (optional)
		4 - Visible condition [bool:string:code] (optional)
		5 - Menu button name [string] (optional)
		6 - Menu button action [string:code] (optional)
		7 - Icon path [string] (optional)
		8 - Tool-tip [string] (optional)
		9 - Shortcut key code [number] (optional)
		10 - Parent menu identifier [string] (optional)
		11 - Embedded menu [number] (optional)
	Returns:
		Menu button ID [number]
*/
fmh_fnc_addFlexiMenu = {
	[
		(_this select 0),
		[_this, 5, ["STRING"], format["%1 >",(_this select 2)]] call core_fnc_param,
		[_this, 6, ["STRING"], ""] call core_fnc_param,
		[_this, 10, ["STRING"], "main"] call core_fnc_param,
		[_this, 3, ["BOOL"], true] call core_fnc_param,
		[_this, 4, ["BOOL"], true] call core_fnc_param,
		[_this, 7, ["STRING"], ""] call core_fnc_param,
		[_this, 8, ["STRING"], ""] call core_fnc_param,
		[_this, 9, ["SCALAR"], -1] call core_fnc_param,
		["_this call fmh_fnc_loadFlexiMenu;", (_this select 1), [_this, 12, ["SCALAR"], 1] call core_fnc_param],
		[_this, 11, ["STRING"], "Main Menu"] call core_fnc_param
	] call fmh_fnc_addFlexiButton;
};

/*
	Function: fmh_fnc_removeFlexiButton
	Author(s): Naught
	Description:
		Removes a button from the CBA flexi menu.
	Parameters:
		0 - Button ID [number]
	Returns:
		Result [bool]
*/
fmh_fnc_removeFlexiButton = {
	[(_this select 0), 1] call FMH_fnc_removeFlexiEntry;
};

/*
	Function: fmh_fnc_removeFlexiMenu
	Author(s): Naught
	Description:
		Removes a menu button from the CBA flexi menu.
	Parameters:
		0 - Menu button ID [number]
	Returns:
		Result [bool]
*/
fmh_fnc_removeFlexiMenu = {
	[(_this select 0), 0] call FMH_fnc_removeFlexiEntry;
};
