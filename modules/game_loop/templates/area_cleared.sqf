
private ["_count"];
_count = 0;

{ // forEach
	if ((alive _x) && {str(side _x) in gl_clear_sides} && {!(_x getVariable ["ace_sys_wounds_uncon", false])} && {[_x, gl_clear_area] call cba_fnc_inArea}) then {
		_count = _count + 1;
	};
	if (_count > gl_clear_maximum) exitWith {};
} forEach allUnits;

if (_count <= gl_clear_maximum) then {
	format["Area '%1' has been cleared.", gl_clear_area];
} else {
	nil;
};
