[] spawn {
	waitUntil {
		if !(player hasWeapon "ACE_Safe") then {
			player addWeapon "ACE_Safe";
		};
		time > 0;
	};
	player playMove "aidlpknlmstpslowwrfldnon_idlesteady02";
	sleep 1;
	player selectWeapon "ACE_Safe";
};