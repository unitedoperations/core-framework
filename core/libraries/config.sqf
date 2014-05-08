
/*
	Title: Config Function Library
*/

/*
	Function: core_fnc_getConfigValue
	Author(s): Naught
	Description:
		Retrieves any config value.
	Parameters:
		0 - Config path [config]
		1 - Default value [any] (optional)
	Returns:
		Config value [any]
*/

core_fnc_getConfigValue = {
	private ["_cfg"];
	_cfg = _this select 0;
	
	switch (true) do {
		case (isText(_cfg)): {getText(_cfg)};
		case (isNumber(_cfg)): {getNumber(_cfg)};
		case (isArray(_cfg)): {getArray(_cfg)};
		case (isClass(_cfg)): {_cfg};
		default {[_this, 1, [], nil] call core_fnc_param};
	};
};

/*
	Function: core_fnc_getSetting
	Author(s): Naught
	Description:
		Retrieves a module setting.
	Parameters:
		0 - Module name [string]
		1 - Setting name [string]
		2 - Convert to bool [bool] (optional)
	Returns:
		Setting [any]
*/

core_fnc_getSetting = {
	private ["_ret"];
	_ret = [missionConfigFile >> "modules" >> (_this select 0) >> "settings" >> (_this select 1)] call core_fnc_getConfigValue;
	if ([_this, 2, ["BOOL"], false] call core_fnc_param) then {[_ret] call core_fnc_toBool} else {_ret};
};
