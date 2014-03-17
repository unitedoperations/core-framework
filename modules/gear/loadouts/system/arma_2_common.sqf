
/*
	Title: Arma 2 Common Gear Runtime
	Author(s): Naught
	Description:
		Runs common code for removing gear in Arma 2.
	Syntax:
		#include "system\arma_2_common.sqf" // Include in all loadout files
*/

#ifndef arma_2_common
#define arma_2_common

#include "macros.sqf"

REMOVE_ALL_WEAPONS;
REMOVE_ALL_MAGAZINES;
REMOVE_ALL_ITEMS;
REMOVE_BACKPACK;
REMOVE_ALL_WEAPONS_CARGO;
REMOVE_ALL_MAGAZINES_CARGO;
REMOVE_ALL_BACKPACKS_CARGO;

#endif
