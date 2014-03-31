
private ["_res", "_count", "_alive"];
_res = nil;
_count = 0;
_max = ({(alive _x) && {str(side _x) in gl_occupy_sides} && {!(_x getVariable ["ace_sys_wounds_uncon", false])} && {!(_x getVariable ["spectating", false])}} count allUnits) * (gl_occupy_force_percentage / 100);

{ // forEach
	if ((alive _x) && {str(side _x) in gl_occupy_sides} && {!(_x getVariable ["ace_sys_wounds_uncon", false])} && {[_x, gl_occupy_area] call cba_fnc_inArea}) then {
		_count = _count + 1;
	};
	if (_count >= _max) exitWith {
		_res = format["Area '%1' has been occupied.", gl_occupy_area];
	};
} forEach allUnits;

_res
