
/*
	File: exec.sqf
	Author(s): Naught
	Description:
		Executes code from an addAction event.
	Syntax:
		http://community.bistudio.com/wiki/addAction
	Example:
		player addAction ["Run free!", "core\exec.sqf", {_this call my_fnc_name}];
	Notes:
		1. The argument (index 3) should be the code to run.
		2. The code is called from the addAction runtime environment.
		3. The first 3 parameters of the addAction function will be
		   passed to the called code as would a normal addAction event.
*/

private ["_target", "_caller", "_actionID", "_code"];
_target		= _this select 0;
_caller		= _this select 1;
_actionID	= _this select 2;
_code		= _this select 3;

if (typeName(_code) == typeName("")) then {
	_code = compile _code;
};

if (typeName(_code) == typeName({})) then {
	[_target, _caller, _actionID] call _code;
};
