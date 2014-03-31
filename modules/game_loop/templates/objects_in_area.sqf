
private ["_res"];
_res = nil;

{ // forEach
	private ["_obj"];
	_obj = call _x;
	if ([_obj, gl_active_area] call cba_fnc_inArea) exitWith {
		_res = format["%1 has safely moved to the %2 area.", (name _obj), gl_active_area];
	};
} forEach gl_objects_in_area;

_res
