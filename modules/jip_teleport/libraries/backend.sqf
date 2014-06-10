jt_fnc_getTarget = {
	if (!isNull(group player)) then {
		private["_target", "_rank"];
		_target = leader(group player);
		
		if (player == _target || {_target getVariable ["ace_sys_wounds_uncon", false] || {!(alive _target) || {_target getVariable ["spectating", false]}}}) then {
			_rank = -1;
		
			{
				if (rankId _x > _rank && {!(_x getVariable ["ace_sys_wounds_uncon", false]) && {alive _x && {!(_x getVariable ["spectating", false])}}}) then {
					_rank = rankId _x;
					_target = _x;
				};
			} forEach ((units (group player)) - [player]);
		};
		
		_target
	} else {player};
};

jt_fnc_jipTeleport = {
	private ["_target"];
	_target = [] call jt_fnc_getTarget;
	
	if (_target == player) exitWith {
		["JIP Teleport is no longer possible.\n\nSince no suitable group member could be found."] call core_fnc_hint;
		[] call jt_fnc_disableJip;
	};
	
	if ((vehicle _target) != _target) then { // Checks if the target is in a vehicle
		if (((vehicle _target) emptyPositions "cargo") == 0) then { // Checks if vehicle has empty seats
			["No room in %1's vehicle.\nPlease try again later.", [name(_target)]] call core_fnc_hint;
		}
		else {
			player moveInCargo (vehicle _target);
			["Teleported to %1's vehicle.", [name(_target)]] call core_fnc_hint;
			[] call jt_fnc_disableJip;
		}; 
	} else {
		player setPos (getPos _target);
		["Teleported to %1's position.", [name(_target)]] call core_fnc_hint;
		[] call jt_fnc_disableJip;
	};
};

jt_fnc_enableJip = {
	jt_visible = true;
};

jt_fnc_disableJip = {
	jt_visible = false;
};