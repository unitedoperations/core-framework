
/*
	Title: Core Framework Initialization
	Author(s): Naught
	Description:
		Initialization code which loads libraries,
		modules, parameters, and synchronizes machines.
*/

/* Set Reference Variables */
core_init = false;

/* Immediately Send Server Status */
if (isServer) then {
	core_serverInit = false;
	publicVariable "core_serverInit";
};

LOG_NOTICE(COMPONENT, "Core initialization has started.");

/* Start Initialization */
private ["_startTime"];
_startTime = diag_tickTime;

LOG_INFO(COMPONENT, "Loading mission parameters.");

/* Load Mission Parameters */
#define PARAMS_CONFIG (missionConfigFile >> "Params")
private ["_params"];
_params = [];

if (isNil "paramsArray") then {paramsArray = []};

for "_i" from 0 to ((count PARAMS_CONFIG) - 1) do {
	private ["_param", "_var", "_value"];
	_param = PARAMS_CONFIG select _i;
	
	_var = if (isText(_param >> "variable")) then {
		getText(_param >> "variable");
	} else {
		format["param_%1", (configName(_param))];
	};
	
	_value = if ((count paramsArray) > _i) then {
		paramsArray select _i;
	} else {
		[_param >> "default"] call core_fnc_getConfigValue;
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
	
	[_params, [getText(_param >> "title"), _value]] call core_fnc_push;
	paramsArray set [_i, _value];
};

LOG_INFO(COMPONENT, "Loading mission modules.");

/* Load Modules */
#define MODULES_CONFIG (missionConfigFile >> "Modules")
private ["_modules"];
_modules = [];

for "_i" from 0 to ((count MODULES_CONFIG) - 1) do {
	[_modules, (MODULES_CONFIG select _i)] call core_fnc_push;
};

LOG_INFO(COMPONENT, "Loading module settings.");

/* Load Module Settings */
{ // forEach
	private ["_settings"];
	_settings = _x >> "settings";
	
	if (isClass _settings) then {
		for "_i" from 0 to ((count _settings) - 1) do {
			private ["_setting"];
			_setting = _settings select _i;
			
			if (!(isClass _setting)) then {
				missionNamespace setVariable [(configName _setting), ([_setting] call core_fnc_getConfigValue)];
			};
		};
	};
} forEach _modules;

LOG_INFO(COMPONENT, "Loading module preinits.");

/* Load Module Pre-Inits */
{ // forEach
	[_x, "preinit", false] call core_fnc_loadModule;
} forEach _modules;

/* Process Vehicle Init Code */
processInitCommands;

/* Finish world initialization*/
finishMissionInit;

/* Start Delayed Execution */
private ["_postInit"];
_postInit = [_startTime, _modules, _params] spawn {
	private ["_startTime", "_modules", "_params"];
	_startTime = _this select 0;
	_modules = _this select 1;
	_params = _this select 2;
	
	/* Wait for Player */
	if (isMultiplayer && {!isDedicated}) then {
		[{!(isNull player)}, -1, "Player Initialization"] call core_fnc_wait;
	};
	
	/* Wait for Server */
	if (!isServer) then {
		[{!(isNil "core_serverInit") && {core_serverInit}}, -1, "Core Server Initialization"] call core_fnc_wait;
	};
	
	/* Wait for XEH Post-Initialization */
	if (isClass(configFile >> "CfgPatches" >> "cba_xeh")) then {
		[{!(isNil "SLX_XEH_MACHINE") && {SLX_XEH_MACHINE select 8}}, -1, "XEH Initialization"] call core_fnc_wait;
	};
	
	LOG_INFO("Loading module post-inits.");
	
	/* Load Module Post-Inits */
	{ // forEach
		[_x, "postinit", true] call core_fnc_loadModule;
	} forEach _modules;
	
	/* Load Framework Documentation */
	if (hasInterface) then {
		private ["_modDoc", "_paramDoc"];
		_modDoc = "<br/>Mission Modules:";
		_paramDoc = "<br/>Mission Parameters:<br/>";
		
		{ // forEach
			_modDoc = _modDoc + format["<br/><br/>------------------------<br/><br/>    Module: %1<br/>    Version: %2<br/>    Author(s): %3<br/>    URL: %4",
				[_x >> "name", "N/A"] call core_fnc_getConfigValue,
				[_x >> "version", "N/A"] call core_fnc_getConfigValue,
				[[_x >> "authors", "N/A"] call core_fnc_getConfigValue] call core_fnc_toString,
				[_x >> "url", "N/A"] call core_fnc_getConfigValue
			];
		} forEach _modules;
		
		{ // forEach
			_paramDoc = _paramDoc + format["<br/>    %1: %2", (_x select 0), (_x select 1)];
		} forEach _params;
		
		waitUntil {player diarySubjectExists C_DIARY_SUBJECT};
		player createDiaryRecord [C_DIARY_SUBJECT, ["About", format["<br/>Core Mission Framework<br/><br/>Version: %1<br/>Authors: Naught, Olsen", core_version]]];
		player createDiaryRecord [C_DIARY_SUBJECT, ["Modules", _modDoc]];
		player createDiaryRecord [C_DIARY_SUBJECT, ["Parameters", _paramDoc]];
		
		if (core_logToDiary) then { // Ensure initial load of logging diary record
			player createDiaryRecord [C_DIARY_SUBJECT, ["Diagnostics Log", ""]];
		};
	};
	
	/* Wait For Post-Inits To Finish Processing */
	if ((count core_scheduledModules) > 0) then {
		[{{if !(scriptDone _x) exitWith {false}; true} forEach core_scheduledModules}, 15, "Core Post-Initialization"] call core_fnc_wait;
	};
	
	/* Finalize Reference Variables */
	core_init = true;
	if (isServer) then {
		core_serverInit = true;
		publicVariable "core_serverInit";
	};
	
	/* Finalizing Initialization */
	LOG_FORMAT("Notice", COMPONENT, "Core initialization has finished. Benchmark: %1 sec.", [diag_tickTime - _startTime]);
};
