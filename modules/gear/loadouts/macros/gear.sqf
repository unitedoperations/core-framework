
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
	Section: Gear Initialization
*/

private ["_object", "_groupName", "_fireTeam", "_class"];
_object = _this select 0;
_groupName = _this select 1;
_fireTeam = _this select 2;
_class = _this select 3;

/*
	Group: Generic Macros
*/

#define FOR_CYCLE(iterations,code) \
	(for "_i" from 1 to iterations do {code})

/*
	Group: Common Gear Macros
*/

#define REMOVE_ALL_WEAPONS \
	removeAllWeapons _object

#define REMOVE_ALL_MAGAZINES \
	{_object removeMagazine _x} forEach (magazines _object)

#define REMOVE_ALL_ITEMS \
	removeAllItems _object

#define REMOVE_BACKPACK \
	removeBackpack _object

#define REMOVE_ALL_WEAPONS_CARGO \
	clearWeaponCargoGlobal _object

#define REMOVE_ALL_MAGAZINES_CARGO \
	clearMagazineCargoGlobal _object

#define REMOVE_ALL_BACKPACKS_CARGO \
	clearBackpackCargoGlobal _object

#define ADD_WEAPON(class) \
	_object addWeapon class

#define ADD_MAGAZINE(class,amount) \
	FOR_CYCLE(amount,_object addMagazine class)

#define ADD_BACKPACK(class) \
	_object addBackpack class

#define ADD_WEAPON_CARGO(class,amount) \
	_object addWeaponCargoGlobal [class,amount]

#define ADD_MAGAZINE_CARGO(class,amount) \
	_object addMagazineCargoGlobal [class,amount]

#define ADD_BACKPACK_CARGO(class,amount) \
	_object addBackpackCargoGlobal [class,amount]

/*
	Group: ACE 2 Gear Macros
*/

#define REMOVE_ALL_ACE_ITEMS \
	([_object, "ALL"] call ACE_fnc_RemoveGear)

#define ADD_WEAPON_RUCK(class,amount) \
	([_object, class, amount] call ACE_fnc_PackWeapon)

#define ADD_MAGAZINE_RUCK(class,amount) \
	([_object, class, amount] call ACE_fnc_packMagazine)

#define ADD_WEAPON_ON_BACK(class) \
	_object setVariable ["ace_weaponOnBack", class, true]
	
#define ADD_IFAK_SUPPLIES(slot1, slot2, slot3) \
	([_object, slot1, slot2, slot3] call ACE_fnc_PackIFAK)

#define SET_IFAK_SUPPLIES(slot1, slot2, slot3) \
	([_object, slot1, slot2, slot3, true] call ACE_fnc_PackIFAK)

/*
	Group: Arma 3 Gear Macros
*/

#define REMOVE_ALL_CONTAINERS \
	removeAllContainers _object

#define REMOVE_HEADGEAR \
	removeHeadgear _object

#define REMOVE_GOGGLES \
	removeGoggles _object
	
#define REMOVE_ALL_ASSIGNED_ITEMS \
	removeAllAssignedItems _object

#define REMOVE_ALL_ITEMS_CARGO \
	clearItemCargoGlobal _object

#define ADD_ITEM(class) \
	_object linkItem class

#define ADD_ITEM_INVENTORY(class,amount) \
	FOR_CYCLE(amount,_object addItem class)

#define ADD_UNIFORM(class) \
	_object addUniform class

#define ADD_VEST(class) \
	_object addVest class

#define ADD_HEADGEAR(class) \
	_object addHeadgear class

#define ADD_GOGGLES(class) \
	_object addGoggles class

#define ADD_PRIMARY_WEAPON_ITEM(class) \
	_object addPrimaryWeaponItem class

#define ADD_SECONDARY_WEAPON_ITEM(class) \
	_object addSecondaryWeaponItem class

#define ADD_HANDGUN_WEAPON_ITEM(class) \
	_object addHandgunItem class

#define ADD_ITEM_CARGO(class,amount) \
	_object addItemCargoGlobal [class,amount]

#endif
