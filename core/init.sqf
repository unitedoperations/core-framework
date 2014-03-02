
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
#include "macros.sqf"

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

/* Start Initialization */
private ["_startTime"];
_startTime = diag_tickTime;
["Notice", "Core-Init", "Core initialization has started.", [], __FILE__, __LINE__] call core_fnc_log;

/* Load Mission Parameters */
["Info", "Core-Init", "Loading mission parameters.", [], __FILE__, __LINE__] call core_fnc_log;
[] call core_fnc_loadMissionParams;

/* Load Modules */
// TODO: Load Modules

/* Finalize Reference Variables */
core_init = true;
if (isServer) then {
	core_serverInit = true;
	publicVariable "core_serverInit";
};

/* Finalizing Initialization */
["Notice", "Core-Init", "Core initialization has finished. Benchmark: %1 sec.", [
	(diag_tickTime - _startTime)
], __FILE__, __LINE__] call core_fnc_log;

/* End Loading Screen */
endLoadingScreen;

core_init = true;
