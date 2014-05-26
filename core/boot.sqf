
/*
	Title: Core Framework Bootstrap
	Author(s): Naught
*/

/* Don't Double Load */
if !(isNil "core_init") exitWith {};

/* Set Defines */
#define COMPONENT "Core-Init"

/* Load Version Number */
core_version = parseNumber(loadFile "core\version");

/* Start Loading Screen */
if (hasInterface) then {
	startLoadingScreen [format["Loading Core Mission Framework v%1...", core_version]];
};

/* Load Data and Libraries */
#include "load.sqf"

/* Load Core Initialization */
#include "init.sqf"

/* End Loading Screen */
if (hasInterface) then {
	endLoadingScreen;
};
