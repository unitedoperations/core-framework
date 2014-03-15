
/*
	Title: Arma 3 Common Gear Runtime
	Author(s): Naught
	Description:
		Runs common code for removing gear in Arma 3.
	Syntax:
		#include "system\arma_3_common.sqf" // Include in all loadout files
*/

#include "macros.sqf"
#include "arma_2_common.sqf"

REMOVE_ALL_CONTAINERS;
REMOVE_HEADGEAR;
REMOVE_GOGGLES;
REMOVE_ALL_ASSIGNED_ITEMS;
REMOVE_ALL_ITEMS_CARGO;
