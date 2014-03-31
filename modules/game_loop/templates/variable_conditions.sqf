
private ["_res"];
_res = nil;

{ // forEach
	private ["_temp"];
	_temp = call _x;
	if (!isNil "_temp") exitWith {
		_res = _temp;
	};
} forEach gl_variable_conditions;

_res

