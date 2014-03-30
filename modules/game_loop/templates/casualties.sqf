
private ["_res"];
_res = nil;

{ // forEach
	private ["_side", "_totalCount", "_aliveCount"];
	_side = _x select 0;
	_totalCount = {(side _x) == _side} count allUnits;
	_aliveCount = { // count
		((side _x) == _side)
		{alive _x} &&
		{!(_x getVariable ["ace_sys_wounds_uncon", false])} &&
		{!(_x getVariable ["spectating", false])}
	} count allUnits;
	if (_aliveCount < (_totalCount * (missionNamespace getVariable [(_x select 1), 0]) / 100)) exitWith {
		_res = format["%1 has suffered too many casualties (%2%) to proceed.",
			[_side] call core_fnc_sideToText,
			round(((_totalCount - _aliveCount) / _totalCount) * 100)
		];
	};
} forEach [
	[WEST, "gl_blufor_limit"],
	[EAST, "gl_opfor_limit"],
	[RESISTANCE, "gl_independent_limit"],
	[CIVILIAN, "gl_civilian_limit"]
];

_res
