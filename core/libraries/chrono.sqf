
/*
	Title: Chronography Function Library
*/

/*
	Function: core_fnc_wait
	Author(s): Naught
	Parameters:
		0 - Wait condition [code:string]
		1 - Max wait duration in seconds [number] (optional)
		2 - Trace component [string] (optional)
	Returns:
		Value [bool]
*/

core_fnc_wait = {
	private ["_condCode", "_maxDuration", "_traceComp", "_startTime", "_endTime", "_val"];
	_condCode = if (typeName(_this select 0) == "CODE") then {_this select 0} else {compile(_this select 0)};
	_maxDuration = [_this, 1, ["SCALAR"], -1] call core_fnc_param;
	_traceComp = [_this, 2, ["STRING"], "component"] call core_fnc_param;
	_startTime = diag_tickTime;
	_endTime = _startTime + _maxDuration;
	
	LOG_FORMAT("Info", "Core-Wait", "Waiting for %1.", [_traceComp]);
	
	waitUntil {
		_val = call _condCode;
		_val || {(_maxDuration > 0) && {diag_tickTime > _endTime}};
	};
	
	["Info", "Core-Wait", "Done waiting for %1. Benchmark: %2 sec. Value: %3.", [
		_traceComp,
		(diag_tickTime - _startTime),
		_val
	], __FILE__, __LINE__] call core_fnc_log;
	
	_val
};