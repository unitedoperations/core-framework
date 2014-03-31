
private ["_res"];
_res = nil;

{ // forEach
	private ["_trigger"];
	_trigger = call _x;
	if (triggerActivated _trigger) exitWith {
		_res = triggerText _trigger;
	};
} forEach gl_active_triggers;

_res
