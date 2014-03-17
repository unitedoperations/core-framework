
/*
	Title: Gear Macros
	Author(s): Naught
	Description:
		Adds macros for adding gear in both Arma 2 and Arma 3 scenarios.
	Syntax:
		#include "system\macros.sqf" // Include in all loadout files
	Macros:
		// Arma 2 or Arma 3
		REMOVE_ALL_WEAPONS;
		REMOVE_ALL_MAGAZINES;
		REMOVE_ALL_ITEMS;
		REMOVE_BACKPACK;
		REMOVE_ALL_WEAPONS_CARGO;
		REMOVE_ALL_MAGAZINES_CARGO;
		REMOVE_ALL_BACKPACKS_CARGO;
		ADD_WEAPON("className");
		ADD_MAGAZINE("className", count);
		ADD_BACKPACK("className");
		ADD_WEAPON_CARGO("className", count);
		ADD_MAGAZINE_CARGO("className", count);
		ADD_BACKPACK_CARGO("className", count);
		// ACE 2
		REMOVE_ALL_ACE_ITEMS;
		ADD_WEAPON_RUCK("className", count);
		ADD_MAGAZINE_RUCK("className", count);
		ADD_WEAPON_ON_BACK("className", count);
		ADD_IFAK_SUPPLIES(slot1, slot2, slot3);
		SET_IFAK_SUPPLIES(slot1, slot2, slot3);
		// Arma 3
		REMOVE_ALL_CONTAINERS;
		REMOVE_HEADGEAR;
		REMOVE_GOGGLES;
		REMOVE_ALL_ASSIGNED_ITEMS;
		REMOVE_ALL_ITEMS_CARGO;
		ADD_ITEM("className");
		ADD_ITEM_INVENTORY("className", count);
		ADD_UNIFORM("className");
		ADD_VEST("className");
		ADD_HEADGEAR("className");
		ADD_GOGGLES("className");
		ADD_PRIMARY_WEAPON_ITEM("className");
		ADD_SECONDARY_WEAPON_ITEM("className");
		ADD_HANDGUN_WEAPON_ITEM("className");
		ADD_ITEM_CARGO("className", count);
	Notes:
		1. Do not use any Arma 3 macros in Arma 2 and vice-versa, otherwise
		   the compiler may exit without running the code.
*/

#ifndef gear_macros
#define gear_macros

/*
	Group: Generic Macros
*/

#define FOR_CYCLE(iterations,code) \
	for "_i" from 1 to iterations do { \
		code; \
	}

/*
	Group: Common Gear Macros
*/

#define REMOVE_ALL_WEAPONS \
	removeAllWeapons _this

#define REMOVE_ALL_MAGAZINES \
	{_this removeMagazine _x} forEach (magazines _this)

#define REMOVE_ALL_ITEMS \
	removeAllItems _this

#define REMOVE_BACKPACK \
	removeBackpack _this

#define REMOVE_ALL_WEAPONS_CARGO \
	clearWeaponCargoGlobal _this

#define REMOVE_ALL_MAGAZINES_CARGO \
	clearMagazineCargoGlobal _this

#define REMOVE_ALL_BACKPACKS_CARGO \
	clearBackpackCargoGlobal _this

#define ADD_WEAPON(class) \
	_this addWeapon class

#define ADD_MAGAZINE(class,amount) \
	FOR_CYCLE(amount,_this addMagazine class)

#define ADD_BACKPACK(class) \
	_this addBackpack class

#define ADD_WEAPON_CARGO(class,amount) \
	_this addWeaponCargoGlobal [class,amount]

#define ADD_MAGAZINE_CARGO(class,amount) \
	_this addMagazineCargoGlobal [class,amount]

#define ADD_BACKPACK_CARGO(class,amount) \
	_this addBackpackCargoGlobal [class,amount]

/*
	Group: ACE 2 Gear Macros
*/

#define REMOVE_ALL_ACE_ITEMS \
	[_this, "ALL"] call ACE_fnc_RemoveGear

#define ADD_WEAPON_RUCK(class,amount) \
	[_this, class, amount] call ACE_fnc_PackWeapon

#define ADD_MAGAZINE_RUCK(class,amount) \
	[_this, class, amount] call ACE_fnc_packMagazine

#define ADD_WEAPON_ON_BACK(class) \
	_this setVariable ["ace_weaponOnBack", class]
	
#define ADD_IFAK_SUPPLIES(slot1, slot2, slot3) \
	[_this, slot1, slot2, slot3] call ACE_fnc_PackIFAK

#define SET_IFAK_SUPPLIES(slot1, slot2, slot3) \
	[_this, slot1, slot2, slot3, true] call ACE_fnc_PackIFAK

/*
	Group: Arma 3 Gear Macros
*/

#define REMOVE_ALL_CONTAINERS \
	removeAllContainers _this

#define REMOVE_HEADGEAR \
	removeHeadgear _this

#define REMOVE_GOGGLES \
	removeGoggles _this
	
#define REMOVE_ALL_ASSIGNED_ITEMS \
	removeAllAssignedItems _this

#define REMOVE_ALL_ITEMS_CARGO \
	clearItemCargoGlobal _this

#define ADD_ITEM(class) \
	_this linkItem class

#define ADD_ITEM_INVENTORY(class,amount) \
	FOR_CYCLE(amount,_this addItem class)

#define ADD_UNIFORM(class) \
	_this addUniform class

#define ADD_VEST(class) \
	_this addVest class

#define ADD_HEADGEAR(class) \
	_this addHeadgear class

#define ADD_GOGGLES(class) \
	_this addGoggles class

#define ADD_PRIMARY_WEAPON_ITEM(class) \
	_this addPrimaryWeaponItem class

#define ADD_SECONDARY_WEAPON_ITEM(class) \
	_this addSecondaryWeaponItem class

#define ADD_HANDGUN_WEAPON_ITEM(class) \
	_this addHandgunItem class

#define ADD_ITEM_CARGO(class,amount) \
	_this addItemCargoGlobal [class,amount]

#endif
