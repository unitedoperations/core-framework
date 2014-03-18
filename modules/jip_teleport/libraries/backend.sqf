
jt_fnc_getTarget = {
	private ["_unit", "_target", "_rankId"];
	_unit = _this select 0;
	_target = objNull;
	_rankId = -1;
	{ // forEach
		if (
			(alive _unit) &&
			{((leader _unit) == _x) ||
			{(rankId _x) > _rankId}} &&
			{!(_x getVariable ["ace_sys_wounds_uncon", false])} &&
			{!(_x getVariable ["spectating", false])} &&
			{_x != _unit}
		) then {
			_target = _x;
			_rankId = rankId(_target);
		};
	} forEach (units(group(_unit)));
	_target
};

jt_fnc_jipTeleport = {
	private ["_unit", "_target"];
	_unit = _this select 0;
	_target = [_unit] call jt_fnc_getTarget;
	
	if (isNull(_target)) exitWith {
		hint "Cannot find suitable group member to teleport to.";
	};
	
	if ((vehicle _target) != _target) then { // Checks if the target is in a vehicle
		if (((vehicle _target) emptyPositions "cargo") == 0) then { // Checks if vehicle has empty seats
			hint format["No room in %1's vehicle.\nPlease try again later.", name(_target)];
		}
		else {
			_unit moveInCargo (vehicle _target);
			hint format["Teleported to %1's vehicle.", name(_target)];
		}; 
	} else {
		_unit setPos (getPos _target);
		hint format["Teleported to %1's position.", name(_target)];
	};
};
