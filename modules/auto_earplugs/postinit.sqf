if (!isDedicated) then {
	[] spawn {
		sleep 3;
		waitUntil {!isNull player};
		if (player hasWeapon "ACE_Earplugs") then {
			player setVariable ["ace_sys_goggles_earplugs", true];
			player setVariable ["ACE_Ear_Protection", true];
			player removeWeapon "ACE_Earplugs";
		};
	};
};