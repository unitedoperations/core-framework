
/*
	Title: Core Framework Initialization
	Author(s): Naught
	Description:
		Initialization code which loads libraries,
		modules, parameters, and synchronizes machines.
*/

/* Set Reference Variables */
core_init = false;
if (isServer) then {
	core_serverInit = false;
	publicVariable "core_serverInit";
};

/* Load Common Macros */
#include "macros.cpp"

/* Start Loading Screen */
startLoadingScreen ["Loading Core Mission Framework..."];

/* Load Libraries */
#include "libraries\arrays.sqf"
#include "libraries\chrono.sqf"
#include "libraries\config.sqf"
#include "libraries\diagnostics.sqf"
#include "libraries\filesystem.sqf"
#include "libraries\math.sqf"
#include "libraries\rve.sqf"
#include "libraries\strings.sqf"

/* Load Logging Configuration */
#define GET_LOG_LEVEL(cfg) (missionConfigFile >> "Core" >> cfg)
{ // forEach
	[_x, true] call core_fnc_setLogLevel;
} forEach ([(if (!isMultiplayer) then {GET_LOG_LEVEL("sp_log_level")} else {GET_LOG_LEVEL("mp_log_level")}), []] call core_fnc_getConfigValue);

/* Start Initialization */
private ["_startTime"];
_startTime = diag_tickTime;
["Notice", "Core-Init", "Core initialization has started.", [], __FILE__, __LINE__] call core_fnc_log;

/* Load Mission Parameters */
["Info", "Core-Init", "Loading mission parameters.", [], __FILE__, __LINE__] call core_fnc_log;
#define PARAMS_CONFIG (missionConfigFile >> "Params")
private ["_params", "_paramDft"];
_params = [];
_paramDft = false;
if (isNil "paramsArray") then {
	_paramDft = true;
	paramsArray = [];
};
for "_i" from 0 to ((count PARAMS_CONFIG) - 1) do {
	private ["_param"];
	_param = PARAMS_CONFIG select _i;
	if (isText(_param >> "loadmodule")) then {
		_modules set [(count _modules), _param];
	} else {
		private ["_var", "_value"];
		_var = if (isText(_param >> "variable")) then {
			getText(_param >> "variable");
		} else {
			format["param_%1", (configName(_param))];
		};
		_value = if (_paramDft) then {
			getNumber(_param >> "default");
			paramsArray set [_i, _value];
		} else {
			paramsArray select _i;
		};
		if ((isNumber(_param >> "boolean")) && {(getNumber(_param >> "boolean")) == 1}) then {
			_value = [_value] call core_fnc_toBool;
		};
		if (isText(_param >> "execute")) then {
			_value = _value call compile (getText(_param >> "execute"));
		};
		if (_var != "") then {
			missionNameSpace setVariable [_var, _value];
		};
		_params = _params + [[getText(_param >> "title"), _var, _value]];
	};
};

/* Load Modules */
["Info", "Core-Init", "Loading mission modules.", [], __FILE__, __LINE__] call core_fnc_log;
#define MODULES_CONFIG (missionConfigFile >> "Modules")
private ["_modules"];
_modules = [];
for "_i" from 0 to ((count MODULES_CONFIG) - 1) do {
	[_modules, (MODULES_CONFIG select _i)] call core_fnc_push;
};

/* Load Module Settings */
["Info", "Core-Init", "Loading module settings.", [], __FILE__, __LINE__] call core_fnc_log;
{ // forEach
	private ["_settings"];
	_settings = _x >> "settings";
	if (isClass _settings) then {
		for "_i" from 0 to ((count _settings) - 1) do {
			private ["_setting"];
			_setting = _settings select _i;
			if (!(isClass _setting)) then {
				missionNamespace setVariable [
					(configName _setting),
					([_setting] call core_fnc_getConfigValue)
				];
			};
		};
	};
} forEach _modules;

/* Load Module Pre-Inits */
["Info", "Core-Init", "Loading module pre-inits.", [], __FILE__, __LINE__] call core_fnc_log;
{ // forEach
	private ["_cfgName"];
	_cfgName = configName _x;
	["Info", "Core-Init", "Loading module '%1' pre-init.", [_cfgName], __FILE__, __LINE__] call core_fnc_log;
	[] call (["modules\" + _cfgName + "\preinit.sqf"] call core_fnc_compileFile);
} forEach _modules;

/* End Loading Screen */
endLoadingScreen;

/* Start Delayed Execution */
[_startTime, _modules] spawn {
	
	/* Wait for XEH Post-Initialization */
	if (isClass(configFile >> "CfgPatches" >> "cba_xeh")) then {
		[{!(isNil "SLX_XEH_MACHINE") && {SLX_XEH_MACHINE select 8}}, -1, "XEH Initialization"] call core_fnc_wait;
	};
	
	/* Wait for Server */
	if (!isServer) then {
		[{!(isNil "core_serverInit") && {core_serverInit}}, -1, "Core Server Initialization"] call core_fnc_wait;
	};
	
	/* Wait for Player */
	if (!isDedicated) then {
		[{!(isNull player)}, -1, "Player Initialization"] call core_fnc_wait;
	};
	
	/* Load Module Post-Inits */
	["Info", "Core-Init", "Loading module post-inits.", [], __FILE__, __LINE__] call core_fnc_log;
	{ // forEach
		private ["_cfgName"];
		_cfgName = configName _x;
		["Info", "Core-Init", "Loading module '%1' post-init.", [_cfgName], __FILE__, __LINE__] call core_fnc_log;
		[] spawn (["modules\" + _cfgName + "\postinit.sqf"] call core_fnc_compileFile);
	} forEach (_this select 1);
	
	/* Load Framework Documentation */
	if (!isDedicated) then {
		player createDiarySubject ["core_docs", "Core Framework"];
		// TODO
		player createDiaryRecord ["core_docs", ["Diagnostics Log", ""]];
		player createDiaryRecord ["core_docs", ["Parameters", ""]];
		player createDiaryRecord ["core_docs", ["Modules", ""]];
		player createDiaryRecord ["core_docs", ["About", ""]];
	};
	
	/* Finalize Reference Variables */
	core_init = true;
	if (isServer) then {
		core_serverInit = true;
		publicVariable "core_serverInit";
	};
	
	/* Finalizing Initialization */
	["Notice", "Core-Init", "Core initialization has finished. Benchmark: %1 sec.", [
		(diag_tickTime - (_this select 0))
	], __FILE__, __LINE__] call core_fnc_log;
};
