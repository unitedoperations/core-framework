
if (hasInterface) then {
	[] spawn {
		sleep 3;
		jtp_playerStartPos = getPos player;
		["selfInteraction", "Teleport to Squad", "[player] call jt_fnc_jipTeleport", "main", true, {
			if ((player distance jtp_playerStartPos) <= jtp_jipDistance) then { // Player must be at spawn
				private ["_target"];
				_target = [player] call jt_fnc_getTarget;
				!(isNull _target) && {(player distance _target) > jtp_jipDistance};
			} else {false};
		}] call fmh_fnc_addFlexiButton;
	};
};
