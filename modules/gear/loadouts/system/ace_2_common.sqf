
/*
	Title: ACE 2 Common Gear Runtime
	Author(s): Naught
	Description:
		Runs common code for removing gear in ACE 2 (Arma 2 OA/CO).
	Syntax:
		#include "system\ace_2_common.sqf" // Include in all loadout files
*/

#include "macros.sqf"
#include "arma_2_common.sqf"

REMOVE_ALL_ACE_ITEMS;
SET_IFAK_SUPPLIES(0, 0, 0);
