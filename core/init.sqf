
/*
	Title: Core Framework Initialization
	Author(s): Naught
	Description:
		Initialization code which loads libraries,
		modules, parameters, and synchronizes machines.
*/

/* Set Reference Variables */
#define COMPONENT "Core-Init"
core_init = false;
if (isServer) then {
	core_serverInit = false;
	publicVariable "core_serverInit";
};
core_version = call compile preprocessFile "core\$VERSION$";

/* Start Loading Screen */
startLoadingScreen ["Loading Core Mission Framework..."];

/* Load Headers */
#include "headers\oop.h"

/* Load Libraries */
#include "libraries\arrays.sqf"
#include "libraries\chrono.sqf"
#include "libraries\config.sqf"
#include "libraries\conversions.sqf"
#include "libraries\diagnostics.sqf"
#include "libraries\filesystem.sqf"
#include "libraries\math.sqf"
#include "libraries\rve.sqf"
#include "libraries\strings.sqf"
#include "libraries\ui.sqf"

/* Load Objects */
#include "objects\hashmap.sqf"

/* Load Logging Configuration */
#define GET_LOG_LEVEL(cfg) (missionConfigFile >> "Core" >> cfg)
{ // forEach
	[_x, true] call core_fnc_setLogLevel;
} forEach ([(if (!isMultiplayer) then {GET_LOG_LEVEL("sp_log_level")} else {GET_LOG_LEVEL("mp_log_level")}), []] call core_fnc_getConfigValue);
core_logToDiary = [[missionConfigFile >> "Core" >> "log_to_diary", 0] call core_fnc_getConfigValue] call core_fnc_toBool;

/* Start Initialization */
private ["_startTime"];
_startTime = diag_tickTime;
["Notice", COMPONENT, "Core initialization has started.", [], __FILE__, __LINE__] call core_fnc_log;

/* Initialize Client ID System */
if (isServer) then {
	core_clientId = -1;
	"core_clientIdRequest" addPublicVariableEventHandler {
		private ["_clientId"];
		_clientId = owner(_this select 1);
		core_clientId = _clientId;
		_clientId publicVariableClient "core_clientId";
		core_clientId = -1;
	};
};

/* Load Mission Parameters */
private ["_params"];
_params = [];
["Info", COMPONENT, "Loading mission parameters.", [], __FILE__, __LINE__] call core_fnc_log;
#define PARAMS_CONFIG (missionConfigFile >> "Params")
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

/* Load Modules */
["Info", COMPONENT, "Loading mission modules.", [], __FILE__, __LINE__] call core_fnc_log;
#define MODULES_CONFIG (missionConfigFile >> "Modules")
private ["_modules"];
_modules = [];
for "_i" from 0 to ((count MODULES_CONFIG) - 1) do {
	[_modules, (MODULES_CONFIG select _i)] call core_fnc_push;
};

/* Load Module Settings */
["Info", COMPONENT, "Loading module settings.", [], __FILE__, __LINE__] call core_fnc_log;
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
["Info", COMPONENT, "Loading module preinits.", [], __FILE__, __LINE__] call core_fnc_log;
{ // forEach
	[_x, "preinit", false] call core_fnc_loadModule;
} forEach _modules;

/* Process Vehicle Init Code */
processInitCommands;

/* End Loading Screen */
endLoadingScreen;

/* Start Delayed Execution */
[_startTime, _modules, _params] spawn {
	private ["_startTime", "_modules", "_params"];
	_startTime = _this select 0;
	_modules = _this select 1;
	_params = _this select 2;
	
	/* Wait for Player */
	if (!isDedicated) then {
		[{!(isNull player)}, -1, "Player Initialization"] call core_fnc_wait;
	};
	
	/* Wait for Server */
	if (!isServer) then {
		[{!(isNil "core_serverInit") && {core_serverInit}}, -1, "Core Server Initialization"] call core_fnc_wait;
	};
	
	/* Request Client ID */
	if (!isDedicated) then {
		if (isServer) then {
			core_clientId = owner(player);
		} else {
			["Info", COMPONENT, "Requesting Client ID.", [], __FILE__, __LINE__] call core_fnc_log;
			core_clientIdRequest = player;
			publicVariableServer "core_clientIdRequest";
			waitUntil {!isNil "core_clientId"};
		};
	};
	
	/* Wait for XEH Post-Initialization */
	if (isClass(configFile >> "CfgPatches" >> "cba_xeh")) then {
		[{!(isNil "SLX_XEH_MACHINE") && {SLX_XEH_MACHINE select 8}}, -1, "XEH Initialization"] call core_fnc_wait;
	};
	
	/* Load Module Post-Inits */
	["Info", COMPONENT, "Loading module post-inits.", [], __FILE__, __LINE__] call core_fnc_log;
	{ // forEach
		[_x, "postinit", true] call core_fnc_loadModule;
	} forEach _modules;
	
	/* Load Framework Documentation */
	#define DIARY_BUFFER_FLUSH_INTERVAL 1 // second(s)
	if (!isDedicated) then {
		player createDiarySubject ["core_docs", "Core Framework"];
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
		player createDiaryRecord ["core_docs", ["About",
			format["<br/>Core Mission Framework<br/><br/>Version: %1<br/>Authors: Naught, Olsen", core_version]
		]];
		player createDiaryRecord ["core_docs", ["Modules", _modDoc]];
		player createDiaryRecord ["core_docs", ["Parameters", _paramDoc]];
		if (core_logToDiary) then { // Ensure initial load of diary record
			player createDiaryRecord ["core_docs", ["Diagnostics Log", ""]];
		};
		[] spawn {
			while {true} do {
				if (core_logToDiary && {(count core_diaryLogQueue) > 0}) then {
					{ // forEach
						player createDiaryRecord ["core_docs", ["Diagnostics Log", _x]];
					} forEach core_diaryLogQueue;
					core_diaryLogQueue = []; // Okay while SQF variable mutex is guaranteed
				};
				uiSleep DIARY_BUFFER_FLUSH_INTERVAL;
			};
		};
	};
	
	/* Finish world initialization*/
	finishMissionInit;
	
	/* Finalize Reference Variables */
	core_init = true;
	if (isServer) then {
		core_serverInit = true;
		publicVariable "core_serverInit";
	};
	
	/* Finalizing Initialization */
	["Notice", COMPONENT, "Core initialization has finished. Benchmark: %1 sec.", [
		(diag_tickTime - _startTime)
	], __FILE__, __LINE__] call core_fnc_log;
};
