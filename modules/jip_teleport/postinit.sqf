if (!isDedicated) then {

	jt_visible = false;
	jt_jipActionId = ["selfInteraction", "Teleport to Squad", "[] call jt_fnc_jipTeleport", "main", true, {jt_visible}] call fmh_fnc_addFlexiButton;

	#include "libraries\backend.sqf"

	sleep 3;
	
	_target = [] call jt_fnc_getTarget;

	if ((_target distance player) >  jtp_jipDistance) then {
		[] call jt_fnc_enableJip;
		hint format["You can JIP Teleport with ACE Self Interaction.\n\nBecause your squad is more then %1 meters away.", jtp_jipDistance];
		
		[] spawn {
			_spawnPos = getPosATL player;
			while {jt_visible} do {
				if ((player distance _spawnPos) > jtp_spawnDistance) exitWith {
					[] call jt_fnc_disableJip;
					hint format["JIP Teleport is no longer possible.\n\nBecause you went more than %1 meters away from your spawnpoint.", jtp_spawnDistance];
				};
				sleep (60); //Runs every min
			};
		};
	};
};
