
/*
	Function: core_fnc_getConfigValue
	Author(s): Naught
	Description:
		Retrieves any config value.
	Parameters:
		0 - Config path [config]
	Returns:
		Config value [string:number:array:config:nil]
*/
core_fnc_getConfigValue = {
	private ["_cfg"];
	_cfg = _this select 0;
	switch (true) do {
		case (isText(_cfg)): {
			getText(_cfg);
		};
		case (isNumber(_cfg)): {
			getNumber(_cfg);
		};
		case (isArray(_cfg)): {
			getArray(_cfg);
		};
		case (isClass(_cfg)): {
			_cfg;
		};
		default {
			nil;
		};
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
		2 - Convert to bool [bool]
	Returns:
		Setting [any]
*/
core_fnc_getSetting = {
	private ["_ret"];
	_ret = [missionConfigFile >> "Params" >> (_this select 0) >> (_this select 1)] call core_fnc_getConfigValue;
	if ([_this, 2, ["BOOLEAN"], false] call core_fnc_param) then {
		[_ret] call core_fnc_toBool;
	} else {_ret};
};
