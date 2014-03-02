
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
