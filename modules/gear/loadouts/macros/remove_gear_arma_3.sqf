
/*
	Title: Arma 3 Common Gear Runtime
	Author(s): Naught
	Description:
		Runs common code for removing gear in Arma 3.
	Syntax:
		#include "system\arma_3_common.sqf" // Include in all loadout files
*/

#ifndef remove_gear_arma_3
#define remove_gear_arma_3

#include "remove_gear_arma_2.sqf"

REMOVE_ALL_CONTAINERS;
REMOVE_HEADGEAR;
REMOVE_GOGGLES;
REMOVE_ALL_ASSIGNED_ITEMS;
REMOVE_ALL_ITEMS_CARGO;

#endif
