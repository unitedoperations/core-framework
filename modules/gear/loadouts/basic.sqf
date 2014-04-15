
/* Arma 2 and ACE 2 Gear Removal */
#include "system\ace_2_common.sqf"

/* Item Slots */
ADD_WEAPON("ItemMap");
ADD_WEAPON("ItemWatch");
ADD_WEAPON("ItemCompass");
ADD_WEAPON("ACRE_PRC343");

/* ACE Ruck Medical Slots */
ADD_MAGAZINE_RUCK("ACE_Tourniquet", 1);
ADD_MAGAZINE_RUCK("ACE_LargeBandage", 1);
ADD_MAGAZINE_RUCK("ACE_Morphine", 1);
ADD_MAGAZINE_RUCK("ACE_Epinephrine", 1);
ADD_MAGAZINE_RUCK("ACE_Bandage", 2);

/* ACE IFAK Loadout */
SET_IFAK_SUPPLIES(1, 1, 1);
