if (!isDedicated) then {
	if (player hasWeapon "ACE_Earplugs") then {
		player setVariable ["ace_sys_goggles_earplugs", true, false];
		player setVariable ["ACE_Ear_Protection", true];
		player removeWeapon "ACE_Earplugs";
	};
};