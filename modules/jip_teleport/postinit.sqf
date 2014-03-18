if (!isDedicated) then {
	
	jt_fnc_getTarget = {
		private["_target", "_rank"];
		_target = leader player;
		
		if (player == _target || {[_target] call ace_sys_wounds_fnc_isUncon || {!(alive _target) || {_target getVariable ["spectating", false]}}}) then {
			_rank = -1;
		
			{
				if (rankId _x > _rank && {!([_x] call ace_sys_wounds_fnc_isUncon) && {alive _target && {!(_target getVariable ["spectating", false])}}}) then {
					_rank = rankId _x;
					_target = _x;
				};
			} forEach ((units (group player)) - [player]);
		};
		
		_target
	};

	jt_fnc_jipTeleport = {
		private["_target"];
		_target = [] call jt_fnc_getTarget;

		if (_target == player) exitWith {
			[] call jt_fnc_removeJip;
			hint "There is no one conscious or alive left";
		};

		if ((vehicle _target) != _target) then { //Checks if the target is in a vehicle
			if ((vehicle _target) emptyPositions "cargo" == 0) then { //Checks if vehicle has empty seats
				hint "No more room in the vehicle, try again later";
			}
			else {
				player moveincargo (vehicle _target);
				[] call jt_fnc_removeJip;
			};
		}
		else {
			player setPos (getpos _target);
			[] call jt_fnc_removeJip;
		};
	};
	
	jt_fnc_addJip = {
		player setVariable ["jipActionId", ["selfInteraction", "Teleport to Squad", "[] call jt_fnc_jipTeleport;"] call fmh_fnc_addFlexiButton];
	};
	
	jt_fnc_removeJip = {
		private["_id"];
		_id = player getVariable ["jipActionId", -1];
		if (_id != -1) then {
			[player getVariable "jipActionId"] call fmh_fnc_removeFlexiButton;
		};
	};

	_target = [] call jt_fnc_getTarget;

	if ((_target distance player) >  jtp_jipDistance) then {
		[] call jt_fnc_addJip;
		
		[] spawn { //Spawns code running in parallel
			_spawnPos = getPosATL player;
			while {true} do {
				if (player distance _spawnPos > jtp_spawnDistance) exitWith { //Exitwith ends the loop
					[] call jt_fnc_removeJip;
				};
				sleep (60); //Runs every min
			};
		};
	};
};