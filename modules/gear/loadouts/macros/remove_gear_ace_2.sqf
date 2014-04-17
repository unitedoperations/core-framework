
/*
	Title: ACE 2 Common Gear Runtime
	Author(s): Naught
	Description:
		Runs common code for removing gear in ACE 2 (Arma 2 OA/CO).
	Syntax:
		#include "system\ace_2_common.sqf" // Include in all loadout files
*/

#ifndef remove_gear_ace_2
#define remove_gear_ace_2

#include "remove_gear_arma_2.sqf"

waitUntil {!(isNil "ACE_fnc_RemoveGear") && {!(isNil "ACE_fnc_PackIFAK")}};

REMOVE_ALL_ACE_ITEMS;
SET_IFAK_SUPPLIES(0,0,0);

#endif
