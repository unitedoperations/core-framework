if (!isDedicated) then {
	if (player hasWeapon "ACE_Earplugs") then {
		[] spawn {
			sleep (0.1);
			[player, "ACE_Earplugs"] execFSM "x\ace\addons\sys_goggles\use_earplug.fsm";
		};
	};
};