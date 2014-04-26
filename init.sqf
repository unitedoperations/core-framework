
// You may run pre-core-init scripts here

/**********************************/
/* DO NOT EDIT BELOW THIS COMMENT */
/**********************************/

if (isNil "core_init") then {
	call compile preprocessFileLineNumbers "core\boot.sqf";
} else {
	waitUntil {core_init};
};

/**********************************/
/* DO NOT EDIT ABOVE THIS COMMENT */
/**********************************/

// You may run post-core-init scripts here
