0 spawn {
	waitUntil {
		// Make sure after clearWeapons ACE_Safe persists
		if !(player hasWeapon "ACE_Safe") then {
			player addWeapon "ACE_Safe";
		};
		time > 0;
	};
	
	player playMove "aidlpknlmstpslowwrfldnon_idlesteady02";
	sleep 5;
	player selectWeapon "ACE_Safe";
};