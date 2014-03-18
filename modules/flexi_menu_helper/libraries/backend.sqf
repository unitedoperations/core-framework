
fmh_fnc_flexiMenuType = {
	private ["_type", "_call", "_data"];
	_type = _this select 0;
	_call = _this select 1; // 0 - get, 1 - set
	_data = if (_call == 1) then {_this select 2} else {[]};
	switch (_call) do { 
		case 0: {
			switch (_type) do {
				case "interaction": {
					fmh_interactMenuDefs;
				};
				case "selfInteraction": {
					fmh_selfInteractMenuDefs;
				};
			};
		};
		case 1: {
			switch (_type) do {
				case "interaction": {
					fmh_interactMenuDefs = _data;
				};
				case "selfInteraction": {
					fmh_selfInteractMenuDefs = _data;
				};
			};
		};
	};
};

fmh_fnc_loadFlexiMenu = {
	private ["_menuDefs", "_target", "_params", "_menuName", "_menuRsc", "_menus", "_menuDef"];
	#define ENABLED_INDEX	6
	#define VISIBLE_INDEX	7
	// _this==[_target, _menuNameOrParams]
	_target = _this select 0;
	_params = _this select 1;
	_menuName = "";
	_menuRsc = "popup";
	_menus = [];
	_menuDef = [];
	switch (typeName(_params)) do {
		case (typeName([])): {
			if (count _params < 1) exitWith {diag_log format["Error: Invalid params: %1, %2", _this, __FILE__];};
			_menuName = _params select 0;
			_menuRsc = if (count _params > 1) then {_params select 1} else {_menuRsc};
		};
		case (typeName("")): {
			_menuName = _params;
		};
	};
	if (_target == player) then {
		_menuDefs =+ fmh_selfInteractMenuDefs;
	} else {
		_menuDefs =+ fmh_interactMenuDefs;
	};
	/*
		_menuDefs = [
			[
				["menu", "Menu Name"],
				[
					"Button Name",
					{Button_Code},
					"icon",
					"toolTip",
					[SubMenuEntry | ""],
					-1 (DIK shortcut),
					Bool (enabled),
					Bool (visible)
				], ...
			], ...
		];
	*/
	{ // forEach
		if (((_x select 0) select 0) == _menuName) exitWith {
			_menuDef = _x;
		};
	} forEach _menuDefs;
	if ((count _menuDef) > 0) then {
		private ["_buttonArray"];
		_buttonArray = _menuDef select 1;
		(_menuDef select 0) set [2, _menuRsc];
		if ((count _buttonArray) > 0) then {
			{ // forEach
				private ["_button"];
				_button = _x;
				{ // forEach
					_button set [_x, ([(_button select _x), _this] call core_fnc_toBool)];
				} forEach [ENABLED_INDEX, VISIBLE_INDEX];
			} forEach _buttonArray;
		};
	};
	fmh_target = _target;
	_menuDef
};

fmh_fnc_removeFlexiEntry = {
	private ["_keyIdx", "_key", "_call", "_result"];
	_keyIdx = _this select 0;
	_call = _this select 1;
	_result = false;
	if !((_keyIdx >= 0) && (_keyIdx < (count fmh_flexiMenuKeys))) exitWith {false};
	_key = fmh_flexiMenuKeys select _keyIdx;
	if ((count _key) > 2) then {
		private ["_type", "_menuDefIndex", "_buttonIndex", "_menuDefs"];
		_type = _key select 0;
		_menuDefIndex = _key select 1;
		_buttonIndex = _key select 2;
		_menuDefs = [_type, 0] call fmh_fnc_flexiMenuType;
		_menuCount = count _menuDefs;
		if (_menuCount > _menuDefIndex) then {
			switch (_call) do {
				case 0: { // Remove Menu
					_menuDefs set [_menuDefIndex, (_menuDefs select (_menuCount - 1))];
					_menuDefs resize (_menuCount - 1);
					_result = true;
				};
				case 1: { // Remove Button
					if (_buttonIndex > 0) then {
						private ["_menuDef", "_menuDefCount"];
						_menuDef = _menuDefs select _menuDefIndex;
						_menuDefCount = count _menuDef;
						if (_buttonIndex < _menuDefCount) then {
							_menuDef set [_buttonIndex, (_menuDef select (_menuDefCount - 1))];
							_menuDef resize (_menuDefCount - 1);
							_menuDefs set [_menuDefIndex, _menuDef];
							_result = true;
						};
					};
				};
			};
		};
		[_type, 1, _menuDefs] call fmh_fnc_flexiMenuType;
	};
	_result
};
