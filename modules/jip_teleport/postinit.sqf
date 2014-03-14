if (!isDedicated) then {
	_target = leader player;
	
	if (player == _target || {[_target] call ace_sys_wounds_fnc_isUncon}) then {
		_rank = -1;
	
		{
			if (rankId _x > _rank && {!([_x] call ace_sys_wounds_fnc_isUncon)}) then {
				_rank = rankId _x;
				_target = _x;
			};
		} forEach ((units group player) - [player]);
	};

	if ((_target distance player) >  jtp_jipDistance) then {
		_teleportAction = player addAction ["Teleport to Squad", "modules\jip_teleport\teleportAction.sqf", _target];
		
		[_teleportAction] spawn { //Spawns code running in parallel
			_spawnPos = getPosATL player;
			while {true} do {
				if (player distance _spawnPos > jtp_spawnDistance) exitWith { //Exitwith ends the loop
					player removeAction (_this select 0);
				};
				sleep (60); //Runs every min
			};
		};
	};
};