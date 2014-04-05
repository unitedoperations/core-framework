if (!isDedicated) then {

	jt_visible = false;
	jt_jipActionId = ["selfInteraction", "Teleport to Squad", "[] call jt_fnc_jipTeleport", "main", true, {jt_visible && {(player distance jtp_spawnPos) <= jtp_spawnDistance}}] call fmh_fnc_addFlexiButton;

	#include "libraries\backend.sqf"

	sleep 3;
	
	_target = [] call jt_fnc_getTarget;

	if ((_target distance player) >  jtp_jipDistance) then {
		[] call jt_fnc_enableJip;
		["You can JIP Teleport with ACE Self Interaction."] call core_fnc_hint
		
		[] spawn {
			_spawnPos = getPosATL player;
			while {jt_visible} do {
				if ((player distance _spawnPos) > jtp_spawnDistance) exitWith {
					[] call jt_fnc_disableJip;
				};
				sleep (60); //Runs every min
			};
		};
	};
};
