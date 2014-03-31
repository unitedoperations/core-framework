
private ["_res"];
_res = nil;

{ // forEach
	private ["_obj"];
	_obj = call _x;
	if (isNull "_obj" || {!(alive _obj)}) exitWith {
		_res = format["%1 has been killed.", (name _obj)];
	};
} forEach gl_objects_destroyed;

_res
