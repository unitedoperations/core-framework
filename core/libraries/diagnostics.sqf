
/*
	Function: core_fnc_param
	Parameters:
		0 - Parameter list [array]
		1 - Parameter selection index [number]
		2 - Type list [array] (optional)
		3 - Default value [any] (optional)
*/
core_fnc_param = {
	private ["_list", "_index", "_typeList"];
	_list = _this select 0;
	_index = _this select 1;
	_typeList = if ((count _this) > 2) then {_this select 2} else {[]};
	if (((count _list) > _index) && {((count _typeList) == 0) || {typeName(_list select _index) in _typeList}}) then {
		_list select _index; // Valid value
	} else {
		if ((count _this) > 2) then {
			_this select 3; // Default value
		} else {
			nil; // No valid matching value
		};
	};
};

/*
	Group: Logging
*/

#define LOG_LEVELS ["info", "notice", "warning", "error", "critical"];
core_log_level = "";

/*
	Function: core_fnc_convLogLevel
	Parameters:
		0 - Log level [string] || [number]
*/
core_fnc_convLogLevel = {
	private ["_index"];
	_index = _this select 0;
	switch (typeName(_index)) do {
		case "SCALAR": {
			LOG_LEVELS select _index;
		};
		case "STRING": {
			LOG_LEVELS find _index;
		};
	};
};

/*
	Function: core_fnc_setLogLevel
	Parameters:
		0 - Log level [string]
*/
core_fnc_setLogLevel = {
	private ["_index"];
	_index = [toLower(_this select 0)] call core_fnc_convLogLevel;
	if (_index >= 0) then {
		private ["_logLevel"];
		_logLevel = toArray(core_log_level);
		/*
			Note:
				U+0030 = Digit Zero
				U+0031 = Digit One
		*/
		while {(count _logLevel) < _index} do {
			_logLevel set [(count _logLevel), 30];
		};
		_logLevel set [_index, (if (_this select 1) then {31} else {30})];
		core_log_level = toString(_logLevel);
	};
};

/*
	Function: core_fnc_log
	Parameters:
		0 - Log level [string]
		1 - Component [string]
		2 - Message [string]
		3 - Message parameters [array] (optional)
		4 - File path [string] (optional)
		5 - Line number [number] (optional)
*/
core_fnc_log = {
	private ["_index"];
	_index = [toLower(_this select 0)] call core_fnc_convLogLevel;
	if ([core_log_level, _index] call core_fnc_selBinStr) then {
		private ["_output"];
		_output = format[
			"%1: %2 [ T: %3 | TT: %4 | F: '%5:%6' | M: %7 | W: %8 ] %9",
			(_this select 0),
			(_this select 1),
			time,
			diag_tickTime,
			([_this, 4, ["STRING"], "File Not Found"] call core_fnc_param),
			str([_this, 5, ["SCALAR"], 0] call core_fnc_param),
			missionName,
			worldName,
			format([_this select 2] + ([_this, 3, ["ARRAY"], []] call core_fnc_param))
		];
		diag_log _output;
	};
};